//
//  FileHandler.swift
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

#if canImport(FoundationNetworking)
  public import FoundationNetworking
#endif

/// A protocol that defines the required methods for handling files.
public protocol FileHandler: Sendable {
  /// Retrieves the size of the file at the specified URL.
  ///
  /// - Parameter url: The URL of the file to get the size for.
  /// - Returns: The size of the file in bytes, or `nil` if the size could not be determined.
  /// - Throws: Any errors that occur while trying to get the file size.
  func sizeOf(_ url: URL) throws -> Int?

  /// Copies a file from one URL to another.
  ///
  /// - Parameters:
  ///   - fromURL: The URL of the file to be copied.
  ///   - toURL: The URL of the destination for the copied file.
  /// - Throws: Any errors that occur during the copy operation.
  func copy(at fromURL: URL, to toURL: URL) async throws
}
