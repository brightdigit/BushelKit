//
//  JSON.swift
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

/// A static namespace for working with JSON data.
public enum JSON {
  #if canImport(FoundationNetworking)
    /// A thread-safe, shared instance of `JSONEncoder` with the following configuration:
    /// - `outputFormatting: .prettyPrinted`
    /// - `dateEncodingStrategy: .iso8601`
    public static let encoder: JSONEncoder = {
      let value = JSONEncoder()
      value.outputFormatting = .prettyPrinted
      value.dateEncodingStrategy = .iso8601
      return value
    }()

    /// A thread-safe, shared instance of `JSONDecoder` with the following configuration:
    /// - `dateDecodingStrategy: .iso8601`
    public static let decoder: JSONDecoder = {
      let value = JSONDecoder()
      value.dateDecodingStrategy = .iso8601
      return value
    }()
  #else
    /// A shared instance of `JSONEncoder` with the following configuration:
    /// - `outputFormatting: .prettyPrinted`
    /// - `dateEncodingStrategy: .iso8601`
    public static let encoder: JSONEncoder = {
      let value = JSONEncoder()
      value.outputFormatting = .prettyPrinted
      value.dateEncodingStrategy = .iso8601
      return value
    }()

    /// A shared instance of `JSONDecoder` with the following configuration:
    /// - `dateDecodingStrategy: .iso8601`
    public static let decoder: JSONDecoder = {
      let value = JSONDecoder()
      value.dateDecodingStrategy = .iso8601
      return value
    }()
  #endif
}
