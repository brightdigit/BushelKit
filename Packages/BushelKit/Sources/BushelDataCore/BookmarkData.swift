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
  public final class BookmarkData: Loggable {
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
      _ context: ModelContext
    ) throws -> BookmarkData {
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
      context.insert(bookmark)
      do {
        try context.save()
      } catch {
        throw BookmarkError.databaseError(error)
      }
      return bookmark
    }

    public static func resolveURL(_ url: URL, with context: ModelContext) throws -> BookmarkData {
      let path = url.standardizedFileURL.path
      var predicate = FetchDescriptor<BookmarkData>(
        predicate: #Predicate { $0.path == path }
      )
      predicate.fetchLimit = 1
      let items: [BookmarkData]
      do {
        items = try context.fetch(predicate)
      } catch {
        throw BookmarkError.databaseError(error)
      }
      if let item = items.first {
        Self.logger.debug("Refresh Bookmark for \(url, privacy: .public) with ID: \(item.bookmarkID)")
        do {
          try item.refreshBookmark(using: context, withURL: url)
        } catch {
          throw BookmarkError.accessDeniedError(error, at: url)
        }

        return item
      } else {
        return try creteNewBookmarkFromURL(url, context)
      }
    }

    @MainActor
    public func update(using context: ModelContext, at updateAt: Date = Date()) throws {
      self.updatedAt = updateAt
      Self.logger.debug("Noting updated bookmark \(self.path)")
      try context.save()
    }

    #warning("logging-note: any useful logs here")
    private func updateURL(_ url: URL, withNewBookmarkData: Bool, using context: ModelContext) throws {
      if withNewBookmarkData {
        let accessingSecurityScopedResource = url.startAccessingSecurityScopedResource()

        let bookmarkData = try url.bookmarkDataWithSecurityScope()
        if accessingSecurityScopedResource {
          url.stopAccessingSecurityScopedResource()
        }
        let path = url.standardizedFileURL.path
        data = bookmarkData
        self.path = path
        try context.save()
      }
    }

    private func refreshBookmark(using context: ModelContext, withURL newURL: URL?) throws {
      _ = try fetchURL(using: context, withURL: newURL)
    }

    public func fetchURL(using context: ModelContext, withURL _: URL?) throws -> URL {
      var isStale = false
      let url = try URL(resolvingSecurityScopeBookmarkData: data, bookmarkDataIsStale: &isStale)
      Self.logger.debug("Bookmark for \(url, privacy: .public) stale: \(isStale)")
      try updateURL(url, withNewBookmarkData: isStale, using: context)
      return url
    }
  }
#endif
