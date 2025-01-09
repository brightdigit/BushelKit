//
//  BookmarkError.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

/// An error that represents a problem with a bookmark.
public struct BookmarkError: Error, Sendable {
  /// Represents the details of a `BookmarkError`.
  public enum Details: Equatable, Sendable {
    /// Indicates a database-related error.
    case database
    /// Indicates that access was denied at a specific URL.
    case accessDeniedAt(URL)
    /// Indicates that a file does not exist at a specific URL.
    case fileDoesNotExistAt(URL)
    /// Indicates that a bookmark with the given identifier was not found.
    case notFound(Identifier)
  }

  /// Represents the identifier of a bookmark.
  public enum Identifier: Equatable, Sendable {
    /// Identifies a bookmark by its UUID.
    case id(UUID)
    /// Identifies a bookmark by its URL.
    case url(URL)
  }

  /// The underlying error, if any.
  public let innerError: (any Error)?
  /// The details of the error.
  public let details: Details
}

extension BookmarkError {
  /// Creates a `BookmarkError` with the `notFound` details.
  ///
  /// - Parameter identifier: The identifier of the bookmark that was not found.
  /// - Returns: A `BookmarkError` with the `notFound` details.
  public static func notFound(_ identifier: Identifier) -> BookmarkError {
    BookmarkError(innerError: nil, details: .notFound(identifier))
  }

  /// Creates a `BookmarkError` with the `database` details.
  ///
  /// - Parameter error: The underlying error that occurred.
  /// - Returns: A `BookmarkError` with the `database` details.
  public static func databaseError(_ error: any Error) -> BookmarkError {
    BookmarkError(innerError: error, details: .database)
  }

  /// Creates a `BookmarkError` with the `accessDeniedAt` or `fileDoesNotExistAt` details,
  /// depending on the underlying error.
  ///
  /// - Parameters:
  ///   - error: The underlying error that occurred.
  ///   - url: The URL associated with the error.
  /// - Returns: A `BookmarkError` with the appropriate details.
  public static func accessDeniedError(_ error: any Error, at url: URL) -> BookmarkError {
    let nsError = error as NSError
    if nsError.code == NSFileReadNoSuchFileError {
      return BookmarkError(innerError: error, details: .fileDoesNotExistAt(url))
    } else {
      return BookmarkError(innerError: error, details: .accessDeniedAt(url))
    }
  }
}
