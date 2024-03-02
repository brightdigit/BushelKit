//
// BackgroundDatabase.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelLogging
  import Foundation
  import SwiftData
  import SwiftUI

  public final class BackgroundDatabase: Database {
    private actor DatabaseContainer {
      private let factory: @Sendable () -> any Database
      private var wrapped: (any Database)?

      // swiftlint:disable:next strict_fileprivate
      fileprivate init(factory: @escaping @Sendable () -> any Database) {
        self.factory = factory
      }

      // swiftlint:disable:next strict_fileprivate
      fileprivate var database: any Database {
        get async {
          guard let wrapped else {
            let wrapped = await Task.detached {
              assert(isMainThread: false)

              return self.factory()
            }.value
            self.wrapped = wrapped
            return wrapped
          }
          return wrapped
        }
      }
    }

    private let container: DatabaseContainer

    private var database: any Database {
      get async {
        await container.database
      }
    }

    internal convenience init(modelContainer: ModelContainer) {
      self.init {
        assert(isMainThread: false)
        return ModelActorDatabase(modelContainer: modelContainer)
      }
    }

    internal init(_ factory: @Sendable @escaping () -> any Database) {
      self.container = .init(factory: factory)
    }

    public func transaction(_ block: @escaping (ModelContext) throws -> Void) async throws {
      assert(isMainThread: false)
      try await self.database.transaction(block)
    }

    public func delete(where predicate: Predicate<some PersistentModel>?) async throws {
      assert(isMainThread: false)
      return try await self.database.delete(where: predicate)
    }

    public func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
      assert(isMainThread: false)
      return try await self.database.fetch(descriptor)
    }

    public func delete(_ model: some PersistentModel) async {
      assert(isMainThread: false)
      return await self.database.delete(model)
    }

    public func insert(_ model: some PersistentModel) async {
      assert(isMainThread: false)
      return await self.database.insert(model)
    }

    public func save() async throws {
      assert(isMainThread: false)
      return try await self.database.save()
    }

    public func contextMatchesModel(_ model: some PersistentModel) async -> Bool {
      await self.database.contextMatchesModel(model)
    }
  }
#endif
