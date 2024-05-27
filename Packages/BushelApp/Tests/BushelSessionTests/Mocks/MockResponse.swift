//
// MockResponse.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

internal struct MockResponse: Codable, Equatable {
  let id: UUID
  internal init(id: UUID = .init()) {
    self.id = id
  }
}
