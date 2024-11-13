//
//  FileManager+Errors.swift
//  BushelKit
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

/// The file manager extension that provides additional functionality.
extension FileManager {
  /// An error that occurs during file creation.
  public struct CreationError: Error {
    /// The source of the error.
    public enum Source: Sendable {
      case open
      case ftruncate
      case close
    }

    /// The error code.
    public let code: Int
    /// The source of the error.
    public let source: Source
  }
}

extension Error where Self == NSError {
  internal static func fileNotFound(at url: URL) -> NSError {
    NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileNoSuchFileError,
      userInfo: [
        NSFilePathErrorKey: url.path,
        NSUnderlyingErrorKey: POSIXError(.ENOENT),
      ]
    )
  }
}