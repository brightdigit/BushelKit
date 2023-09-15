//
// BookmarkError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct BookmarkError: Error {
  public enum Details: Equatable {
    case database
    case accessDeniedAt(URL)
    case fileDoesNotExistAt(URL)
  }

  public let innerError: Error
  public let details: Details
}

public extension BookmarkError {
  static func databaseError(_ error: Error) -> BookmarkError {
    BookmarkError(innerError: error, details: .database)
  }

  static func accessDeniedError(_ error: Error, at url: URL) -> BookmarkError {
    let nsError = error as NSError
    if nsError.code == NSFileReadNoSuchFileError {
      return BookmarkError(innerError: error, details: .fileDoesNotExistAt(url))
    } else {
      return BookmarkError(innerError: error, details: .accessDeniedAt(url))
    }
  }
}