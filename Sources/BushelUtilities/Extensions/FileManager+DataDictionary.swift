//
//  FileManager+DataDictionary.swift
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

#if !os(Android)
  extension FileManager {
    /// Writes a dictionary of data to a directory.
    ///
    /// - Parameters:
    ///   - dataDictionary: A dictionary of relative paths and data to write.
    ///   - directoryURL: The URL of the directory to write the data to.
    /// - Throws: An error if the data cannot be written.
    public func write(
      _ dataDictionary: [String: Data],
      to directoryURL: URL
    ) throws {
      for (relativePath, data) in dataDictionary {
        let fullURL = directoryURL.appendingPathComponent(relativePath)
        let parentURL = fullURL.deletingLastPathComponent()
        if self.directoryExists(at: parentURL) == .notExists {
          try self.createEmptyDirectory(
            at: parentURL,
            withIntermediateDirectories: true,
            deleteExistingFile: true
          )
        }
        try data.write(to: fullURL)
      }
    }

    /// Retrieves a dictionary of data from a directory.
    ///
    /// - Parameter directoryURL: The URL of the directory to retrieve data from.
    /// - Returns: A dictionary of relative paths and data.
    /// - Throws: An error if the data cannot be retrieved.
    public func dataDictionary(
      directoryAt directoryURL: URL
    ) throws -> [String: Data] {
      let keys: Set<URLResourceKey> = Set([.isDirectoryKey, .isRegularFileKey])
      guard
        let enumerator = self.enumerator(
          at: directoryURL,
          includingPropertiesForKeys: Array(keys)
        )
      else {
        throw .fileNotFound(at: directoryURL)
      }

      return try enumerator.reduce(into: [String: Data]()) { dictionary, item in
        guard let url = item as? URL else {
          return
        }
        guard try url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile == true else {
          return
        }
        assert(dictionary[url.lastPathComponent] == nil)
        dictionary[url.lastPathComponent] = try Data(contentsOf: url)
      }
    }
  }
#endif
