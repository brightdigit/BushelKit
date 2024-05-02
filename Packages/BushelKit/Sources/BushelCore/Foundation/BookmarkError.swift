//
// BookmarkError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct BookmarkError: Error, Sendable {
  public enum Details: Equatable, Sendable {
    case database
    case accessDeniedAt(URL)
    case fileDoesNotExistAt(URL)
  }

  public let innerError: any Error
  public let details: Details
}

public extension BookmarkError {
  static func databaseError(_ error: any Error) -> BookmarkError {
    BookmarkError(innerError: error, details: .database)
  }

  static func accessDeniedError(_ error: any Error, at url: URL) -> BookmarkError {
    let nsError = error as NSError
    if nsError.code == NSFileReadNoSuchFileError {
      return BookmarkError(innerError: error, details: .fileDoesNotExistAt(url))
    } else {
      return BookmarkError(innerError: error, details: .accessDeniedAt(url))
    }
  }
}
