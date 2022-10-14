//
// RestoreImageLibraryContext.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct RestoreImageLibraryContext: Codable, Hashable, UserDefaultsCodable {
  public init(url: URL) {
    self.url = url
  }

  public let url: URL

  public static var key: UserDefaultsKey {
    .libraries
  }
}
