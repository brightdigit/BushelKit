//
//  XCTestCase+Decode.swift
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

public import XCTest

extension XCTestCase {
  /// Decodes a value of the given type from a string, failing the test if the data cannot be produced.
  /// - Parameters:
  ///   - type: The type to decode.
  ///   - string: The source string to decode from.
  ///   - decoder: The decoder to use.
  /// - Returns: The decoded value.
  /// - Throws: ``TestDecodingError/dataEncoding`` if the string cannot be encoded, or any decoding error.
  public func decode<T: Decodable>(
    _: T.Type,
    from string: String,
    using decoder: JSONDecoder
  ) throws -> T {
    guard let data = string.data(using: .utf8) else {
      XCTFail("Expect data out of \(string)")
      throw TestDecodingError.dataEncoding
    }

    return try decoder.decode(T.self, from: data)
  }
}
