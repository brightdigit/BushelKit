//
// MockMessage.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelMessageCore
  import Foundation
  import SwiftData

  internal struct MockMessage: Message {
    typealias ResponseType = MockResponse
    let id: UUID
    let count: Int
    internal init(id: UUID = .init(), count: Int = .random(in: 3 ... 7)) {
      self.id = id
      self.count = count
    }

    func run(from service: any ServiceInterface) async throws -> MockResponse {
      let models = try await service.database.fetch {
        var selectDescriptor = FetchDescriptor<ItemModel>()
        selectDescriptor.fetchLimit = count
        return selectDescriptor
      }
      return MockResponse(id: id, items: models.map { Item(id: $0.id) })
    }
  }
#endif
