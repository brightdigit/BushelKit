//
// BuildError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BuildError: Error, Hashable {
  static func == (lhs: BuildError, rhs: BuildError) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  internal init(innerError: Error) {
    self.init(innerError: innerError, id: .init())
  }

  internal init(innerError: Error, id: UUID) {
    self.id = id
    self.innerError = innerError
  }

  let id: UUID
  let innerError: Error
}
