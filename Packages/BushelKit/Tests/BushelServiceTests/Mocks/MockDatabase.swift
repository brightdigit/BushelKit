//
// MockDatabase.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelDataCore
  import Foundation
  import SwiftData
  class MockDatabase: Database {
    var didRequestCount: Int?
    func contextMatchesModel(_: some PersistentModel) async -> Bool {
      false
    }

    func delete(where _: Predicate<some PersistentModel>?) async throws {}

    func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
      guard let count = descriptor.fetchLimit else {
        return []
      }
      self.didRequestCount = count
      return (0 ..< count).map { _ in
        ItemModel()
      }
      .compactMap { $0 as? T }
    }

    func delete(_: some PersistentModel) async {}

    func insert(_: some PersistentModel) async {}

    func save() async throws {}

    func transaction(_: @escaping (ModelContext) throws -> Void) async throws {}
  }
#endif
