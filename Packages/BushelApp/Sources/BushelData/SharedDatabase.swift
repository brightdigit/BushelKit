//
// SharedDatabase.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import Foundation

  public import SwiftData

  public struct SharedDatabase: Sendable {
    public static let shared: SharedDatabase = .init()

    public let schemas: [any PersistentModel.Type]
    public let modelContainer: ModelContainer
    public let database: any Database

    private init(
      schemas: [any PersistentModel.Type] = .all,
      modelContainer: ModelContainer? = nil,
      database: (any Database)? = nil
    ) {
      self.schemas = schemas
      let modelContainer = modelContainer ?? .forTypes(schemas)
      self.modelContainer = modelContainer
      self.database = database ?? BackgroundDatabase(modelContainer: modelContainer)
    }
  }
#endif
