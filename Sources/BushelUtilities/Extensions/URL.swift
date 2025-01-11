//
//  URL.swift
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

extension URL {
  /// Initializes a `URL` instance from a `StaticString`.
  ///
  /// - Parameter staticString: The static string to be used as the URL string.
  public init(_ staticString: StaticString) {
    guard let url = URL(string: .init(describing: staticString)) else {
      fatalError("Invalid URL String")
    }
    self = url
  }

  #if !os(Linux)
    /// Initializes a `URL` instance by resolving a security-scoped bookmark data.
    ///
    /// - Parameters:
    ///   - data: The bookmark data to be resolved.
    ///   - bookmarkDataIsStale: A boolean value indicating whether the bookmark data is stale.
    /// - Throws: An error if the bookmark data cannot be resolved.
    public init(resolvingSecurityScopeBookmarkData data: Data, bookmarkDataIsStale: inout Bool)
      throws
    {
      #if os(macOS)
        try self.init(
          resolvingBookmarkData: data,
          options: [.withSecurityScope],
          bookmarkDataIsStale: &bookmarkDataIsStale
        )
      #else
        try self.init(resolvingBookmarkData: data, bookmarkDataIsStale: &bookmarkDataIsStale)
      #endif
    }

    /// Creates bookmark data with security scope.
    ///
    /// - Returns: The bookmark data with security scope.
    /// - Throws: An error if the bookmark data cannot be created.
    public func bookmarkDataWithSecurityScope() throws -> Data {
      #if os(macOS)
        return try bookmarkData(options: .withSecurityScope)
      #else
        return try self.bookmarkData()
      #endif
    }
  #endif
}
