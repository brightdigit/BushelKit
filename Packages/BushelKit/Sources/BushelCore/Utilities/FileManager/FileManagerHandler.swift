//
//  FileManagerHandler.swift
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

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public actor FileManagerHandler: FileHandler {
  private let fileManager: @Sendable () -> FileManager

  public init(fileManager: @Sendable @escaping () -> FileManager) {
    self.fileManager = fileManager
  }

  public func attributesAt(_ url: URL) async throws -> any AttributeSet {
    #if canImport(FoundationNetworking)
      let dictionary = try self.fileManager().attributesOfItem(atPath: url.path)
    #else
      let dictionary = try self.fileManager().attributesOfItem(atPath: url.path(percentEncoded: false))
    #endif
    return DictionaryAttributeSet(dictionary: dictionary)
  }

  public func copy(at fromURL: URL, to toURL: URL) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
      do {
        try self.fileManager().copyItem(at: fromURL, to: toURL)
      } catch {
        // self.logger?.error("Error Copying: \(error)")
        // self.killTimer()
        continuation.resume(throwing: error)
        return
      }
      // self.logger?.debug("Copy is done. Quitting timer.")
      // self.killTimer()

      continuation.resume(returning: ())
    }
  }
}
