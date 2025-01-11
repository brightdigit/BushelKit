//
//  DirectoryExists.swift
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

/// Represents the existence of a directory or file.
public enum DirectoryExists {
  /// The path exists as a directory.
  case directoryExists
  /// The path exists as a file.
  case fileExists
  /// The path does not exist.
  case notExists
}

extension DirectoryExists {
  /// Initializes a `DirectoryExists` value based on the existence and type of the file system entry.
  ///
  /// - Parameters:
  ///   - fileExists: A boolean indicating whether the file system entry exists.
  ///   - isDirectory: A boolean indicating whether the file system entry is a directory.
  public init(fileExists: Bool, isDirectory: Bool) {
    if fileExists {
      self = isDirectory ? .directoryExists : .fileExists
    } else {
      self = .notExists
    }
  }
}
