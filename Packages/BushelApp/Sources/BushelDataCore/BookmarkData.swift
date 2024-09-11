//
// BookmarkData.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore

  public import DataThespian

  public import BushelLogging

  public import Foundation

  public import SwiftData

  @Model
  public final class BookmarkData:
    Loggable {
    public var path: String

    @Attribute(.unique)
    public var data: Data

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

    public static func withDatabase(
      _ database: any Database,
      fromURL url: URL
    ) async throws -> ModelID<BookmarkData>? {
      let path = url.standardizedFileURL.path

      return try await database.first(#Predicate<BookmarkData> { $0.path == path })
    }

    public static func withDatabase<T: Sendable>(
      _ database: any Database,
      fromURL url: URL,
      _ body: @escaping @Sendable (BookmarkData) throws -> T
    ) async throws -> T {
      let path = url.standardizedFileURL.path

      let bookmarkData: Data
      do {
        bookmarkData = try url.bookmarkDataWithSecurityScope()
      } catch {
        throw BookmarkError.accessDeniedError(error, at: url)
      }

      return try await database.first(fetchWith: #Predicate<BookmarkData> { $0.path == path }) {
        .init(url: url, bookmarkData: bookmarkData)
      } with: {
        try body($0)
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

    public func update(at updateAt: Date = Date()) {
      self.updatedAt = updateAt
      Self.logger.debug("Nothing updated bookmark \(self.path)")
    }

    private func updateURL(
      _ url: URL,
      withNewBookmarkData: Bool
    ) throws {
      if withNewBookmarkData {
        let accessingSecurityScopedResource = url.startAccessingSecurityScopedResource()

        let bookmarkData = try url.bookmarkDataWithSecurityScope()
        if accessingSecurityScopedResource {
          url.stopAccessingSecurityScopedResource()
        }
        let path = url.standardizedFileURL.path
        data = bookmarkData
        self.path = path
      }
    }

    public func fetchURL() throws -> URL {
      var isStale = false
      let url = try URL(resolvingSecurityScopeBookmarkData: data, bookmarkDataIsStale: &isStale)
      Self.logger.debug("Bookmark for \(url, privacy: .public) stale: \(isStale)")
      try updateURL(url, withNewBookmarkData: isStale)
      return url
    }
  }

#endif
