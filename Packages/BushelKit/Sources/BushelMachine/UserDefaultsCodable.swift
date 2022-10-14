//
// UserDefaultsCodable.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public protocol UserDefaultsCodable: Codable {
  static var key: UserDefaultsKey {
    get
  }
}
