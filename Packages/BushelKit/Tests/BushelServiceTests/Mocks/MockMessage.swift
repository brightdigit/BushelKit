//
// MockMessage.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelMessageCore
  import Foundation
  import SwiftData

  struct MockMessage: Message {
    typealias ResponseType = MockResponse
    let id: UUID
    let count: Int
    internal init(id: UUID = .init(), count: Int = .random(in: 3 ... 7)) {
      self.id = id
      self.count = count
    }

    func run(from service: any ServiceInterface) async throws -> MockResponse {
      var descriptor = FetchDescriptor<ItemModel>()
      descriptor.fetchLimit = count
      let models = try await service.database.fetch(descriptor)
      return MockResponse(id: id, items: models.map { Item(id: $0.id) })
    }
  }
#endif
