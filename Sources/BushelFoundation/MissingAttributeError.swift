//
//  MissingAttributeError.swift
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

/// An error that represents a missing file attribute.
public struct MissingAttributeError: LocalizedError {
  /// Represents the name of a header attribute.
  public enum HeaderName: String {
    /// Represents the "Content-Length" header.
    case contentLength = "Content-Length"
    /// Represents the "Last-Modified" header.
    case lastModified = "Last-Modified"
  }

  /// The file attribute key that is missing.
  public let attributeKey: FileAttributeKey
  /// The URL of the file.
  public let url: URL
  /// The headers associated with the file, if available.
  public let headers: [String: String]?

  /// Initializes a `MissingAttributeError` instance for a specific header name.
  ///
  /// - Parameters:
  ///   - headerName: The name of the missing header.
  ///   - url: The URL of the file.
  ///   - headers: The headers associated with the file, if available.
  public init(_ headerName: HeaderName, from url: URL, headers: [AnyHashable: Any]? = nil) {
    self.attributeKey = .init(headerName: headerName)
    self.url = url
    self.headers =
      (headers?.map { _ in
        ("\\(pair.key)", "\\(pair.value)")
      }).map(Dictionary.init(uniqueKeysWithValues:))
  }

  /// Initializes a `MissingAttributeError` instance for a specific file attribute key.
  ///
  /// - Parameters:
  ///   - attributeKey: The file attribute key that is missing.
  ///   - url: The URL of the file.
  ///   - headers: The headers associated with the file, if available.
  public init(_ attributeKey: FileAttributeKey, from url: URL, headers: [String: String]? = nil) {
    self.attributeKey = attributeKey
    self.url = url
    self.headers = headers
  }
}

extension FileAttributeKey {
  fileprivate init(headerName: MissingAttributeError.HeaderName) {
    switch headerName {
    case .contentLength:
      self = .size
    case .lastModified:
      self = .modificationDate
    }
  }
}

#if canImport(FoundationNetworking)
  extension FileAttributeKey: @unchecked Sendable {}
#endif
