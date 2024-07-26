//
// ModelContainer.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelDataCore

  public import BushelLogging

  public import SwiftData

  extension ModelContainer: Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .data
    }

    public static func forTypes(_ forTypes: [any PersistentModel.Type]) -> ModelContainer {
      do {
        return try ModelContainer(for: Schema(forTypes))
      } catch {
        if EnvironmentConfiguration.shared.disallowDatabaseRebuild {
          assertionFailure(error: error)
        }
        logger.error("Unable to read database. Rebuilding the database.")
        // swiftlint:disable:next force_try
        try! ModelContainer().deleteAllData()
        return self.forTypes(forTypes)
      }
    }
  }
#endif
