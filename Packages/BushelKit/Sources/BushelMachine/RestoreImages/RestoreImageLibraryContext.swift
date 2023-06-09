//
// RestoreImageLibraryContext.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct RestoreImageLibraryContext: Codable, Hashable, UserDefaultsCodable {
  public static var key: UserDefaultsKey {
    .libraries
  }

  public let url: URL
  public init(url: URL) {
    self.url = url
  }
}
