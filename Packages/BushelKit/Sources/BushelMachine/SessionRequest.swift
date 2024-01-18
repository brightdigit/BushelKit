//
// SessionRequest.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct SessionRequest: Codable, Hashable {
  public let url: URL

  public init(url: URL) {
    self.url = url
  }
}
