//
// ModelActorDatabase.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore

  public import BushelLogging

  public import Foundation

  public import SwiftData

  @ModelActor
  public actor ModelActorDatabase: Database, Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .data
    }

    public func transaction(_ block: @escaping @Sendable (ModelContext) throws -> Void) async throws {
      assert(isMainThread: false)

      try self.modelContext.transaction {
        assert(isMainThread: false)
        try block(modelContext)
      }
    }

    public func delete(_ model: some PersistentModel & Sendable) async {
      assert(isMainThread: false)
      assert(model.modelContext == self.modelContext || model.modelContext == nil)
      guard model.modelContext == self.modelContext else {
        return
      }
      Self.logger.debug("Delete begun: \(type(of: model).self)")
      self.modelContext.delete(model)
    }

    public func insert(_ model: some PersistentModel & Sendable) async {
      assert(isMainThread: false)
      assert(model.modelContext == self.modelContext || model.modelContext == nil)
      guard model.modelContext == self.modelContext || model.modelContext == nil else {
        return
      }
      Self.logger.debug("Insert begun: \(type(of: model).self)")
      self.modelContext.insert(model)
    }

    public func delete<T: PersistentModel & Sendable>(
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

    public func fetch<T>(
      _ selectDescriptor: @escaping @Sendable () -> FetchDescriptor<T>
    ) async throws -> [T] where T: Sendable, T: PersistentModel {
      assert(isMainThread: false)
      Self.logger.debug("Fetch begun: \(T.self)")
      return try self.modelContext.fetch(selectDescriptor())
    }

    public func fetch<T>(
      _ selectDescriptor: FetchDescriptor<T>
    ) async throws -> [T] where T: PersistentModel & Sendable {
      assert(isMainThread: false)
      Self.logger.debug("Fetch begun: \(T.self)")
      return try self.modelContext.fetch(selectDescriptor)
    }

    public func existingModel<T>(
      for objectID: PersistentIdentifier
    ) async throws -> T? where T: Sendable, T: PersistentModel {
      try self.modelContext.existingModel(for: objectID)
    }
  }

#endif
