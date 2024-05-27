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

    func fetch<T>(
      _ descriptor: @Sendable @escaping () -> FetchDescriptor<T>
    ) async throws -> [T] where T: PersistentModel & Sendable

    func delete<T: PersistentModel & Sendable>(
      where predicate: Predicate<T>?
    ) async throws
    func transaction(_ block: @Sendable @escaping (ModelContext) throws -> Void) async throws
    @available(*, deprecated)
    func contextMatchesModel<T>(_ model: T) async -> Bool where T: PersistentModel & Sendable
  }

  extension Database {
    public static var loggingCategory: LoggingSystemType.Category {
      .data
    }

    public func deleteAll(of types: [any (PersistentModel & Sendable).Type]) async throws {
      try await self.transaction { context in
        try types.forEach {
          try context.delete(model: $0)
        }
      }
    }

    public func first<T: PersistentModel & Sendable>(
      where predicate: Predicate<T>,
      sortBy: [SortDescriptor<T>] = []
    ) async throws -> T? {
      try await self.fetch(where: predicate, sortBy: sortBy, fetchLimit: 1).first
    }

    public func fetchAll<T: PersistentModel & Sendable>() async throws -> [T] {
      try await self.fetch {
        FetchDescriptor<T>()
      }
    }

    internal func fetch<T: PersistentModel & Sendable>(
      where predicate: Predicate<T>?,
      sortBy: [SortDescriptor<T>],
      fetchLimit: Int?
    ) async throws -> [T] {
      try await self.fetch {
        FetchDescriptor(predicate: predicate, sortBy: sortBy, fetchLimit: fetchLimit)
      }
    }

    public func fetch<T: PersistentModel & Sendable>(
      _ predicate: Predicate<T>,
      sortBy: [SortDescriptor<T>] = [],
      fetchLimit: Int? = nil
    ) async throws -> [T] {
      try await self.fetch(where: predicate, sortBy: sortBy, fetchLimit: fetchLimit)
    }

    public func fetch<T: PersistentModel & Sendable>(
      _: T.Type,
      predicate: Predicate<T>? = nil,
      sortBy: [SortDescriptor<T>] = [],
      fetchLimit: Int? = nil
    ) async throws -> [T] {
      try await self.fetch(where: predicate, sortBy: sortBy, fetchLimit: fetchLimit)
    }

    public func delete<T: PersistentModel & Sendable>(
      model _: T.Type,
      where predicate: Predicate<T>? = nil
    ) async throws {
      try await self.delete(where: predicate)
    }
  }

  extension Database {
    @available(*, unavailable)
    public func switchContextFor<T: FetchIdentifiable>(model: T) async throws -> T {
      if await self.contextMatchesModel(model) {
        return model
      }

      return try await self.fetchContextFor(model: model)
    }

    public func fetchContextFor<T: FetchIdentifiable>(model: T) async throws -> T {
      Self.logger.notice("Switching Context for Model: \(T.self)")
      let array = try await self.fetch(model.selectDescriptor)
      return try T.model(from: array)
    }
  }
#endif
