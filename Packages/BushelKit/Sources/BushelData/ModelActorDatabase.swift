//
// ModelActorDatabase.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelLogging
  import Foundation
  import SwiftData

  @ModelActor
  public actor ModelActorDatabase: Database, Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .data
    }

    public func transaction(_ block: @escaping (ModelContext) throws -> Void) async throws {
      assert(isMainThread: false)

      try self.modelContext.transaction {
        assert(isMainThread: false)
        try block(modelContext)
      }
    }

    public func delete(_ model: some PersistentModel) async {
      assert(isMainThread: false)
      assert(model.modelContext == self.modelContext || model.modelContext == nil)
      guard model.modelContext == self.modelContext else {
        return
      }
      Self.logger.debug("Delete begun: \(type(of: model).self)")
      self.modelContext.delete(model)
    }

    public func insert(_ model: some PersistentModel) async {
      assert(isMainThread: false)
      assert(model.modelContext == self.modelContext || model.modelContext == nil)
      guard model.modelContext == self.modelContext || model.modelContext == nil else {
        return
      }
      Self.logger.debug("Insert begun: \(type(of: model).self)")
      self.modelContext.insert(model)
    }

    public func delete<T: PersistentModel>(
      where predicate: Predicate<T>?
    ) async throws {
      assert(isMainThread: false)

      Self.logger.debug("Delete begun: \(T.self)")
      try self.modelContext.delete(model: T.self, where: predicate)
    }

    public func save() async throws {
      assert(isMainThread: false)
      Self.logger.debug("Save begun")
      try self.modelContext.save()
    }

    public func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
      assert(isMainThread: false)
      Self.logger.debug("Fetch begun: \(T.self)")
      return try self.modelContext.fetch(descriptor)
    }

    public func contextMatchesModel(_ model: some PersistentModel) async -> Bool {
      model.modelContext == self.modelContext
    }
  }
#endif
