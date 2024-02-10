//
// Database.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import Foundation
  import SwiftData
  public protocol Database {
    func delete<T>(_ model: T) async where T: PersistentModel
    func insert<T>(_ model: T) async where T: PersistentModel
    func save() async throws
    func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel

    func delete<T: PersistentModel>(
      where predicate: Predicate<T>?
    ) async throws
    func transaction(_ block: @escaping (ModelContext) throws -> Void) async throws
  }

  public extension Database {
    func deleteAll(of types: [any PersistentModel.Type]) async throws {
      try await self.transaction { context in
        try types.forEach {
          try context.delete(model: $0)
        }
      }
    }

    internal func fetch<T: PersistentModel>(
      where predicate: Predicate<T>?,
      sortBy: [SortDescriptor<T>]
    ) async throws -> [T] {
      try await self.fetch(FetchDescriptor<T>(predicate: predicate, sortBy: sortBy))
    }

    func fetch<T: PersistentModel>(
      _ predicate: Predicate<T>,
      sortBy: [SortDescriptor<T>] = []
    ) async throws -> [T] {
      try await self.fetch(where: predicate, sortBy: sortBy)
    }

    func fetch<T: PersistentModel>(
      _: T.Type,
      predicate: Predicate<T>? = nil,
      sortBy: [SortDescriptor<T>] = []
    ) async throws -> [T] {
      try await self.fetch(where: predicate, sortBy: sortBy)
    }

    func delete<T: PersistentModel>(
      model _: T.Type,
      where predicate: Predicate<T>? = nil
    ) async throws {
      try await self.delete(where: predicate)
    }
  }
#endif
