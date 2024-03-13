//
// Database.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelLogging
  import Foundation
  import SwiftData
  public protocol Database: Sendable, Loggable {
    func delete<T>(_ model: T) async where T: PersistentModel & Sendable
    func insert<T>(_ model: T) async where T: PersistentModel & Sendable
    func save() async throws
    func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel & Sendable

    func delete<T: PersistentModel & Sendable>(
      where predicate: Predicate<T>?
    ) async throws
    func transaction(_ block: @Sendable @escaping (ModelContext) throws -> Void) async throws
    func contextMatchesModel<T>(_ model: T) async -> Bool where T: PersistentModel & Sendable
  }

  public extension Database {
    static var loggingCategory: LoggingSystemType.Category {
      .data
    }

    func deleteAll(of types: [any (PersistentModel & Sendable).Type]) async throws {
      try await self.transaction { context in
        try types.forEach {
          try context.delete(model: $0)
        }
      }
    }

    internal func fetch<T: PersistentModel & Sendable>(
      where predicate: Predicate<T>?,
      sortBy: [SortDescriptor<T>]
    ) async throws -> [T] {
      try await self.fetch(FetchDescriptor<T>(predicate: predicate, sortBy: sortBy))
    }

    func fetch<T: PersistentModel & Sendable>(
      _ predicate: Predicate<T>,
      sortBy: [SortDescriptor<T>] = []
    ) async throws -> [T] {
      try await self.fetch(where: predicate, sortBy: sortBy)
    }

    func fetch<T: PersistentModel & Sendable>(
      _: T.Type,
      predicate: Predicate<T>? = nil,
      sortBy: [SortDescriptor<T>] = []
    ) async throws -> [T] {
      try await self.fetch(where: predicate, sortBy: sortBy)
    }

    func delete<T: PersistentModel & Sendable>(
      model _: T.Type,
      where predicate: Predicate<T>? = nil
    ) async throws {
      try await self.delete(where: predicate)
    }
  }

  public extension Database {
    func switchContextFor<T: FetchIdentifiable>(model: T) async throws -> T {
      if await self.contextMatchesModel(model) {
        return model
      }

      return try await self.fetchContextFor(model: model)
    }

    func fetchContextFor<T: FetchIdentifiable>(model: T) async throws -> T {
      Self.logger.notice("Switching Context for Model: \(T.self)")
      let array = try await self.fetch(model.modelFetchDescriptor)
      return try T.model(from: array)
    }
  }
#endif
