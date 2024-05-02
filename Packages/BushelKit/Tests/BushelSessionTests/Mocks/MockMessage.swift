//
// MockMessage.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMessageCore
import Foundation

struct MockMessage: Message, Equatable {
  typealias ResponseType = MockResponse

  let id: UUID
  let response: MockResponse
  internal init(id: UUID = .init(), response: MockResponse = .init()) {
    self.id = id
    self.response = response
  }

  func run(from _: any ServiceInterface) async throws -> MockResponse {
    response
  }
}
