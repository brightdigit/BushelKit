//
// Database.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import BushelLogging

  public import Foundation

  public import SwiftData

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

    func existingModel<T: PersistentModel & Sendable>(for objectID: PersistentIdentifier) async throws -> T?
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

    public func delete<T: PersistentModel & Sendable>(
      model _: T.Type,
      where predicate: Predicate<T>? = nil
    ) async throws {
      try await self.delete(where: predicate)
    }
  }
#endif
