//
// BookmarkError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct BookmarkError: Error {
  let innerError: Error
  let details: Details

  enum Details: Equatable {
    case database
    case accessDeniedAt(URL)
  }
}

public extension BookmarkError {
  static func databaseError(_ error: Error) -> BookmarkError {
    BookmarkError(innerError: error, details: .database)
  }

  static func accessDeniedError(_ error: Error, at url: URL) -> BookmarkError {
    BookmarkError(innerError: error, details: .accessDeniedAt(url))
  }
}
