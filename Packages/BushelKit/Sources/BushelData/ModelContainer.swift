//
// ModelContainer.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelDataCore
  import BushelLogging
  import SwiftData

  extension ModelContainer: LoggerCategorized {
    public static var loggingCategory: Loggers.Category {
      .data
    }

    public static func forTypes(_ forTypes: [any PersistentModel.Type]) -> ModelContainer {
      do {
        return try ModelContainer(for: Schema(forTypes))
      } catch {
        if !EnvironmentConfiguration.shared.allowDatabaseRebuild {
          assertionFailure(error: error)
        }
        Self.logger.error("Unable to read database. Rebuilding the database.")
        // swiftlint:disable:next force_try
        try! ModelContainer().deleteAllData()
        return self.forTypes(forTypes)
      }
    }
  }
#endif
