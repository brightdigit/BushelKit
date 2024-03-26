//
// BookmarkData.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelLogging
  import Foundation
  import SwiftData

  @Model
  public final class BookmarkData: Loggable, FetchIdentifiable {
    public private(set) var path: String

    @Attribute(.unique)
    private var data: Data

    @Attribute(.unique)
    public var bookmarkID: UUID

    @Attribute
    public var updatedAt: Date

    @Attribute
    public var createdAt: Date

    @Transient
    public var modelFetchDescriptor: FetchDescriptor<BookmarkData> {
      let id = self.bookmarkID
      var descriptor = FetchDescriptor<BookmarkData>(predicate: #Predicate { input in
        input.bookmarkID == id
      })
      descriptor.fetchLimit = 1
      return descriptor
    }

    private convenience init(url: URL, bookmarkData: Data) {
      let path = url.standardizedFileURL.path
      self.init(path: path, bookmarkData: bookmarkData)
    }

    private init(
      path: String,
      bookmarkData: Data,
      bookmarkID: UUID = .init(),
      createdAt: Date = Date(),
      updatedAt: Date = Date()
    ) {
      self.path = path
      self.bookmarkID = bookmarkID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      data = bookmarkData
      Self.logger.debug(
        "new bookmark for \(path, privacy: .public) with ID: \(self.bookmarkID, privacy: .public)"
      )
    }

    private static func creteNewBookmarkFromURL(
      _ url: URL,
      _ database: any Database
    ) async throws -> BookmarkData {
      let bookmarkData: Data
      do {
        bookmarkData = try url.bookmarkDataWithSecurityScope()
      } catch {
        throw BookmarkError.accessDeniedError(error, at: url)
      }

      let bookmark = BookmarkData(url: url, bookmarkData: bookmarkData)
      Self.logger.debug(
        "Creating Bookmark for \(url, privacy: .public) with ID: \(bookmark.bookmarkID, privacy: .public)"
      )
      await database.insert(bookmark)
      do {
        try await database.save()
      } catch {
        throw BookmarkError.databaseError(error)
      }
      return bookmark
    }

    public static func resolveURL(_ url: URL, with database: any Database) async throws -> BookmarkData {
      let path = url.standardizedFileURL.path
      var predicate = FetchDescriptor<BookmarkData>(
        predicate: #Predicate { $0.path == path }
      )
      predicate.fetchLimit = 1
      let items: [BookmarkData]
      do {
        items = try await database.fetch(predicate)
      } catch {
        throw BookmarkError.databaseError(error)
      }
      if let item = items.first {
        Self.logger.debug("Refresh Bookmark for \(url, privacy: .public) with ID: \(item.bookmarkID)")
        do {
          try await item.refreshBookmark(using: database, withURL: url)
        } catch {
          throw BookmarkError.accessDeniedError(error, at: url)
        }

        return item
      } else {
        return try await creteNewBookmarkFromURL(url, database)
      }
    }

    public func update(using database: any Database, at updateAt: Date = Date()) async throws {
      self.updatedAt = updateAt
      Self.logger.debug("Noting updated bookmark \(self.path)")
      try await database.save()
    }

    private func updateURL(
      _ url: URL,
      withNewBookmarkData: Bool,
      using database: any Database
    ) async throws {
      if withNewBookmarkData {
        let accessingSecurityScopedResource = url.startAccessingSecurityScopedResource()

        let bookmarkData = try url.bookmarkDataWithSecurityScope()
        if accessingSecurityScopedResource {
          url.stopAccessingSecurityScopedResource()
        }
        let path = url.standardizedFileURL.path
        data = bookmarkData
        self.path = path
        try await database.save()
      }
    }

    private func refreshBookmark(using database: any Database, withURL newURL: URL?) async throws {
      _ = try await fetchURL(using: database, withURL: newURL)
    }

    public func fetchURL(using database: any Database, withURL _: URL?) async throws -> URL {
      var isStale = false
      let url = try URL(resolvingSecurityScopeBookmarkData: data, bookmarkDataIsStale: &isStale)
      Self.logger.debug("Bookmark for \(url, privacy: .public) stale: \(isStale)")
      try await updateURL(url, withNewBookmarkData: isStale, using: database)
      return url
    }
  }
#endif
