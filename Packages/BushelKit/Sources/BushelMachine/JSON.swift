//
// JSON.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum JSON {
  public static let encoder: JSONEncoder = {
    let value = JSONEncoder()
    value.outputFormatting = .prettyPrinted
    value.dateEncodingStrategy = .iso8601
    return value
  }()

  static let decoder: JSONDecoder = {
    let value = JSONDecoder()
    value.dateDecodingStrategy = .iso8601
    return value
  }()

  static let legacyDecoder = JSONDecoder()

  public static func tryDecoding<T: Decodable>(_ data: Data) throws -> T {
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      guard let result = try? legacyDecoder.decode(T.self, from: data) else {
        throw error
      }
      return result
    }
  }
}
