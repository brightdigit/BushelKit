//
// BookmarkURL.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore

  public import DataThespian

  public import Foundation

  public struct BookmarkURL: Sendable {
    private let model: ModelID<BookmarkData>
    public let url: URL
    private let databaseError: @Sendable (any Error) -> any Error

    internal init(
      model: ModelID<BookmarkData>,
      url: URL,
      databaseError: @escaping @Sendable (any Error) -> any Error
    ) {
      self.model = model
      self.url = url
      self.databaseError = databaseError
    }

    public func stopAccessing(updateTo database: any Database) async throws {
      try await database.with(self.model) {
        $0.update()
      }

      url.stopAccessingSecurityScopedResource()
    }
  }

  extension BookmarkURL {
    public init<BookmarkedErrorType: BookmarkedError>(
      bookmarkID: UUID,
      database: any Database,
      failureType _: BookmarkedErrorType.Type
    ) async throws {
      self = try await Self.withDatabase(database, bookmarkID: bookmarkID) { bookmarkData in
        guard let bookmarkData else {
          throw BookmarkedErrorType.missingBookmark()
        }

        let libraryURL: URL
        do {
          libraryURL = try bookmarkData.fetchURL()
        } catch {
          throw try BookmarkedErrorType.bookmarkError(error)
        }

        let canAccessFile = libraryURL.startAccessingSecurityScopedResource()

        guard canAccessFile else {
          throw BookmarkedErrorType.accessDeniedError(at: libraryURL)
        }

        return BookmarkURL(
          model: .init(bookmarkData),
          url: libraryURL,
          databaseError: BookmarkedErrorType.databaseError(_:)
        )
      }
    }

    public static func withDatabase<T: Sendable>(
      _ database: any Database,
      bookmarkID: UUID,
      _ body: @Sendable @escaping (BookmarkData?) throws -> T
    ) async throws -> T {
      try await database.first(#Predicate<BookmarkData> { $0.bookmarkID == bookmarkID }, with: body)
    }
  }
#endif
