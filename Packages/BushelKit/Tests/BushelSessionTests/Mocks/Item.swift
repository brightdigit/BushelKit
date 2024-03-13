//
// Item.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct Item: Codable {
  var id: UUID

  init(id: UUID = .init()) {
    self.id = id
  }
}
