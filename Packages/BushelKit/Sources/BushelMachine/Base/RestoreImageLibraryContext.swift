//
// RestoreImageLibraryContext.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct RestoreImageLibraryContext: Codable, Hashable {
  public init(url: URL) {
    self.url = url
  }

  public let url: URL
}
