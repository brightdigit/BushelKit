//
//  JSONDecoder.swift
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

extension JSONDecoder {
  /// Decode JSON data with enhanced error context
  ///
  /// This method wraps the standard decode method to provide additional context
  /// about the data source in error messages, making debugging easier.
  ///
  /// - Parameters:
  ///   - type: The type to decode to
  ///   - data: The JSON data to decode
  ///   - source: Source name for error context (e.g., "appledb.dev", "ipsw.me")
  /// - Returns: Decoded object
  /// - Throws: DecodingError with enhanced context including source name
  public func decode<T: Decodable>(
    _ type: T.Type,
    from data: Data,
    source: String
  ) throws -> T {
    do {
      return try decode(type, from: data)
    } catch let decodingError as DecodingError {
      // Re-throw with source context for better debugging
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: [],
          debugDescription: "Failed to decode \(type) from \(source): \(decodingError)"
        )
      )
    }
  }
}
