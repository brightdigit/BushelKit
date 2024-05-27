//
// MockResponse.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

internal struct MockResponse: Codable {
  let id: UUID
  let items: [Item]
}
