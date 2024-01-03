//
// ModelContext.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import Foundation
  import SwiftData

  public extension ModelContext {
    @MainActor
    func clearDatabase() throws {
      try self.transaction {
        try [any PersistentModel.Type].all.forEach {
          try self.delete(model: $0)
        }
      }
      try self.save()
    }

    func clearDatabaseBegin(timeout _: DispatchTime = .now() + .seconds(10)) throws {
      Task { @MainActor [weak self] in
        do {
          try await self?.clearDatabase()
        } catch {
          assertionFailure(error: error)
        }
      }
    }
  }
#endif
