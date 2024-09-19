//
// ModelContainer.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelDataCore

  public import BushelLogging

  public import SwiftData

  extension ModelContainer: @retroactive Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .data
    }

    public convenience init(
      versionedSchema: VersionedSchema.Type,
      migrationPlan: (any SchemaMigrationPlan.Type)? = nil,
      configurations _: ModelConfiguration...
    ) {
      do {
        try self.init(for: Schema(versionedSchema: versionedSchema), migrationPlan: migrationPlan)
      } catch {
        if EnvironmentConfiguration.shared.disallowDatabaseRebuild {
          assertionFailure(error: error)
        }
        Self.logger.error("Unable to read database. Rebuilding the database.")
        // swiftlint:disable force_try
        if #available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, macCatalyst 15, *) {
          try! ModelContainer().erase()
        } else {
          try! ModelContainer().deleteAllData()
        }
        try! self.init(for: Schema(versionedSchema: versionedSchema), migrationPlan: migrationPlan)
        // swiftlint:enable force_try
      }
    }
  }
#endif
