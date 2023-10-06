//
// XCTestCase+Decode.swift
// Copyright (c) 2023 BrightDigit.
//

import XCTest

public extension XCTestCase {
  func decode<T: Decodable>(
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
