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

  public static let decoder: JSONDecoder = {
    let value = JSONDecoder()
    value.dateDecodingStrategy = .iso8601
    return value
  }()
}
