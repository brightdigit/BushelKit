//
// SharedDatabase.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import Foundation

  public import SwiftData

  public import BushelLogging

  public import DataThespian

  public struct SharedDatabase: Sendable, Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .data
    }

    public static let shared: SharedDatabase = .init()

    public let modelContainer: ModelContainer
    public let database: any Database

    private init(
      database: (any Database)? = nil
    ) {
      self.modelContainer = ModelContainer(
        versionedSchema: NorthernSpySchema.self,
        migrationPlan: MigrationPlan.self
      )
      self.database = database ?? BackgroundDatabase(modelContainer: modelContainer)
    }
  }
#endif
