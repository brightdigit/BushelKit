//
//  MissingAttributeError.swift
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

public struct MissingAttributeError: LocalizedError {
  public enum HeaderName: String {
    case contentLength = "Content-Length"
    case lastModified = "Last-Modified"
  }

  public let attributeKey: FileAttributeKey
  public let url: URL
  public let headers: [String: String]?

  public init(_ headerName: HeaderName, from url: URL, headers: [AnyHashable: Any]? = nil) {
    attributeKey = .init(headerName: headerName)
    self.url = url
    self.headers = (headers?.map { pair in ("\(pair.key)", "\(pair.value)") })
      .map(Dictionary.init(uniqueKeysWithValues:))
  }

  public init(_ attributeKey: FileAttributeKey, from url: URL, headers: [String: String]? = nil) {
    self.attributeKey = attributeKey
    self.url = url
    self.headers = headers
  }
}

extension FileAttributeKey {
  fileprivate init(headerName: MissingAttributeError.HeaderName) {
    switch headerName {
    case .contentLength: self = .size

    case .lastModified: self = .modificationDate
    }
  }
}

#if canImport(FoundationNetworking)
  extension FileAttributeKey: @unchecked Sendable {}
#endif
