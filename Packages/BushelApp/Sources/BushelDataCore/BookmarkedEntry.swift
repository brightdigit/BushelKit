//
// BookmarkedEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import Foundation

  public protocol BookmarkedEntry {
    associatedtype BookmarkedErrorType: BookmarkedError
    var bookmarkData: BookmarkData? { get }
  }

  public extension BookmarkedEntry {
    func accessibleURL(from database: any Database) async throws -> BookmarkURL {
      guard let bookmarkData = self.bookmarkData else {
        throw BookmarkedErrorType.missingBookmark()
      }

      let libraryURL: URL
      do {
        libraryURL = try await bookmarkData.fetchURL(using: database, withURL: nil)
      } catch {
        throw try BookmarkedErrorType.bookmarkError(error)
      }

      let canAccessFile = libraryURL.startAccessingSecurityScopedResource()

      guard canAccessFile else {
        throw BookmarkedErrorType.accessDeniedError(at: libraryURL)
      }

      return .init(
        data: bookmarkData,
        url: libraryURL,
        databaseError: BookmarkedErrorType.databaseError(_:)
      )
    }
  }
#endif
