//
//  FileManagerHandler.swift
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
  import FoundationNetworking
#endif

/// A struct that provides a wrapper around FileManager for file-related operations.
public struct FileManagerHandler: FileHandler {
  /// A closure that provides a `FileManager` instance.
  private let fileManager: @Sendable () -> FileManager

  /// Initializes a `FileManagerHandler` with a closure that returns a `FileManager` instance.
  ///
  /// - Parameter fileManager: A closure that returns a `FileManager` instance.
  public init(fileManager: @Sendable @escaping () -> FileManager) {
    self.fileManager = fileManager
  }

  /// Returns the size of a file at the specified URL, if available.
  ///
  /// - Parameter url: The URL of the file.
  /// - Returns: The size of the file, or `nil` if the size is unavailable.
  public func sizeOf(_ url: URL) throws -> Int? {
    let dictionary: [FileAttributeKey: Any] = try self.fileManager().attributesOfItem(
      atPath: url.path
    )
    return dictionary[.size] as? Int
  }

  /// Copies a file from one URL to another asynchronously.
  ///
  /// - Parameters:
  ///   - fromURL: The URL of the source file.
  ///   - toURL: The URL of the destination file.
  /// - Throws: Any errors that occur during the file copy operation.
  public func copy(at fromURL: URL, to toURL: URL) async throws {
    try await withCheckedThrowingContinuation {
      (continuation: CheckedContinuation<Void, any Error>) in
      do {
        try self.fileManager().copyItem(at: fromURL, to: toURL)
      } catch {
        continuation.resume(throwing: error)
        return
      }

      continuation.resume(returning: ())
    }
  }
}
