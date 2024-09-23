//
//  BookmarkError.swift
//  Sublimation
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

public struct BookmarkError: Error, Sendable {
  public enum Details: Equatable, Sendable {
    case accessDeniedAt(URL)
    case fileDoesNotExistAt(URL)
    case notFound(Identifier)
  }

  public enum Identifier: Equatable, Sendable {
    case id(UUID)
    case url(URL)
  }

  public let innerError: (any Error)?
  public let details: Details
}

extension BookmarkError {
  public static func notFound(_ identifier: Identifier) -> BookmarkError {
    BookmarkError(innerError: nil, details: .notFound(identifier))
  }


  public static func accessDeniedError(_ error: any Error, at url: URL) -> BookmarkError {
    let nsError = error as NSError
    if nsError.code == NSFileReadNoSuchFileError {
      return BookmarkError(innerError: error, details: .fileDoesNotExistAt(url))
    }
    else {
      return BookmarkError(innerError: error, details: .accessDeniedAt(url))
    }
  }
}
