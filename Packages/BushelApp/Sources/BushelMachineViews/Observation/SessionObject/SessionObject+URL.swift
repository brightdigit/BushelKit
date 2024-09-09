//
// SessionObject+URL.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)

  import BushelCore
  import BushelDataCore
  import BushelMachine
  import Combine
  import Foundation
  import SwiftData

  import DataThespian

  extension SessionObject {
    func loadURL(
      _ url: URL,
      withDatabase database: any Database,
      restoreImageDBfrom: @escaping (any Database) -> any InstallerImageRepository,
      snapshotFactory: any SnapshotProvider,
      using systemManager: any MachineSystemManaging,
      labelProvider: @escaping MetadataLabelProvider,
      databasePublisherFactory: @escaping @Sendable (String) -> some Publisher<any DatabaseChangeSet, Never>
    ) async {
      do {
        self.machineObject = try await MachineObject(
          id: "session",
          parent: self,
          configuration: .init(
            url: url,
            database: database,
            systemManager: systemManager,
            snapshotterFactory: snapshotFactory,
            installerImageRepositoryFrom: restoreImageDBfrom,
            labelProvider: labelProvider,
            databasePublisherFactory: databasePublisherFactory
          )
        )
        self.url = url
      } catch {
        Self.logger.error("Could not open \(url, privacy: .public): \(error, privacy: .public)")

        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
    }
  }
#endif
