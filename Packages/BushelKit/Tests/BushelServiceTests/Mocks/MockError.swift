//
// MockError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct MockError: Error {
  let id: UUID

  init(id: UUID = .init()) {
    self.id = id
  }
}
