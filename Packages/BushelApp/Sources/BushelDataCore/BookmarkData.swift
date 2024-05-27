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
  public final class BookmarkData:
    Loggable, FetchIdentifiable, Sendable {
    public private(set) var path: String

    @Attribute(.unique)
    private var data: Data

    @Attribute(.unique)
    public var bookmarkID: UUID

    @Attribute
    public var updatedAt: Date

    @Attribute
    public var createdAt: Date

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
      let item: BookmarkData?
      do {
        item = try await database.first(where: #Predicate { $0.path == path })
      } catch {
        throw BookmarkError.databaseError(error)
      }
      if let item {
        Self.logger.debug("Refresh Bookmark for \(url, privacy: .public) with ID: \(item.bookmarkID)")
        do {
          try await item.refreshBookmark(using: database)
        } catch {
          throw BookmarkError.accessDeniedError(error, at: url)
        }

        return item
      } else {
        return try await creteNewBookmarkFromURL(url, database)
      }
    }

    public func selectDescriptor() -> FetchDescriptor<BookmarkData> {
      let id = self.bookmarkID
      var selectDescriptor = FetchDescriptor<BookmarkData>(predicate: #Predicate { input in
        input.bookmarkID == id
      })
      selectDescriptor.fetchLimit = 1
      return selectDescriptor
    }

    public func update(using database: any Database, at updateAt: Date = Date()) async throws {
      self.updatedAt = updateAt
      Self.logger.debug("Nothing updated bookmark \(self.path)")
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

    private func refreshBookmark(using database: any Database) async throws {
      _ = try await fetchURL(using: database)
    }

    public func fetchURL(using database: any Database) async throws -> URL {
      var isStale = false
      let url = try URL(resolvingSecurityScopeBookmarkData: data, bookmarkDataIsStale: &isStale)
      Self.logger.debug("Bookmark for \(url, privacy: .public) stale: \(isStale)")
      try await updateURL(url, withNewBookmarkData: isStale, using: database)
      return url
    }
  }

  extension BookmarkData {
    public static func fetchURLs<Key: Hashable & Sendable>(
      from bookmarks: [BookmarkData],
      using database: any Database,
      keyBy key: @Sendable @escaping (BookmarkData) async throws -> Key
    ) async throws -> [Key: URL] {
      try await withThrowingTaskGroup(of: (Key, URL).self, returning: [Key: URL].self) { group in
        for bookmark in bookmarks {
          group.addTask {
            async let key = key(bookmark)
            async let url = bookmark.fetchURL(using: database)
            return try await (key, url)
          }
        }

        return try await group.reduce(into: [Key: URL]()) { partialResult, tuple in
          assert(partialResult[tuple.0] == nil)
          partialResult[tuple.0] = tuple.1
        }
      }
    }
  }
#endif
