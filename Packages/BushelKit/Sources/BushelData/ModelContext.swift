//
// ModelContext.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import Foundation
  import SwiftData

  public extension ModelContext {
    func clearDatabase() throws {
      try self.transaction {
        try [any PersistentModel.Type].all.forEach {
          try self.delete(model: $0)
        }
      }
      try self.save()
    }
  }
#endif
