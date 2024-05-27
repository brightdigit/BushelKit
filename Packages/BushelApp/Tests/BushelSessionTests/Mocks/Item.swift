//
// Item.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

internal struct Item: Codable {
  var id: UUID

  init(id: UUID = .init()) {
    self.id = id
  }
}
