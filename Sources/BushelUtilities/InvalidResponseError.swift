//
//  InvalidResponseError.swift
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
  // swiftlint:disable file_types_order
  public import FoundationNetworking
// swiftlint:enable file_types_order
#endif

/// Error representing an invalid response from a URL request.
public struct InvalidResponseError: LocalizedError {
  /// The URL response that was considered invalid.
  public let response: URLResponse
  /// The URL the response was received from.
  public let url: URL

  /// Initializes a new `InvalidResponseError` instance.
  /// - Parameters:
  ///   - response: The `URLResponse` that was considered invalid.
  ///   - url: The `URL` the response was received from.
  public init(_ response: URLResponse, from url: URL) {
    self.response = response
    self.url = url
  }
}
