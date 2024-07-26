//
// BackgroundDatabase.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelLogging

  public import Foundation

  public import SwiftData
  import SwiftUI

  public final class BackgroundDatabase: Database {
    private actor DatabaseContainer {
      private let factory: @Sendable () -> any Database
      private var wrappedTask: Task<any Database, Never>?

      // swiftlint:disable:next strict_fileprivate
      fileprivate init(factory: @escaping @Sendable () -> any Database) {
        self.factory = factory
      }

      // swiftlint:disable:next strict_fileprivate
      fileprivate var database: any Database {
        get async {
          if let wrappedTask {
            return await wrappedTask.value
          }
          let task = Task {
            factory()
          }
          self.wrappedTask = task
          return await task.value
        }
      }
    }

    private let container: DatabaseContainer

    private var database: any Database {
      get async {
        await container.database
      }
    }

    package convenience init(modelContainer: ModelContainer) {
      self.init {
        assert(isMainThread: false)
        return ModelActorDatabase(modelContainer: modelContainer)
      }
    }

    internal init(_ factory: @Sendable @escaping () -> any Database) {
      self.container = .init(factory: factory)
    }

    public func transaction(_ block: @escaping @Sendable (ModelContext) throws -> Void) async throws {
      assert(isMainThread: false)
      try await self.database.transaction(block)
    }

    public func delete(where predicate: Predicate<some PersistentModel & Sendable>?) async throws {
      assert(isMainThread: false)
      return try await self.database.delete(where: predicate)
    }

    public func fetch<T>(
      _ selectDescriptor: @escaping @Sendable () -> FetchDescriptor<T>
    ) async throws -> [T] where T: Sendable, T: PersistentModel {
      assert(isMainThread: false)
      return try await self.database.fetch(selectDescriptor)
    }

    public func delete(_ model: some PersistentModel & Sendable) async {
      assert(isMainThread: false)
      return await self.database.delete(model)
    }

    public func insert(_ model: some PersistentModel & Sendable) async {
      assert(isMainThread: false)
      return await self.database.insert(model)
    }

    public func save() async throws {
      assert(isMainThread: false)
      return try await self.database.save()
    }

    public func existingModel<T>(
      for objectID: PersistentIdentifier
    ) async throws -> T? where T: Sendable, T: PersistentModel {
      assert(isMainThread: false)
      return try await self.database.existingModel(for: objectID)
    }
  }
#endif
