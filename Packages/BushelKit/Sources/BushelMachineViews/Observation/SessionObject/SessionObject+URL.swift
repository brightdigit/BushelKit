//
// SessionObject+URL.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)

  import BushelCore
  import BushelDataCore
  import BushelMachine
  import Foundation
  import SwiftData
  extension SessionObject {
    func loadURL(
      _ url: URL,
      withDatabase database: any Database,
      restoreImageDBfrom: @escaping (any Database) -> any InstallerImageRepository,
      snapshotFactory: any SnapshotProvider,
      using systemManager: any MachineSystemManaging,

      labelProvider: @escaping MetadataLabelProvider
    ) async {
      do {
        self.machineObject = try await MachineObject(
          parent: self,
          configuration: .init(
            url: url,
            database: database,
            systemManager: systemManager,
            snapshotterFactory: snapshotFactory,
            installerImageRepositoryFrom: restoreImageDBfrom,
            labelProvider: labelProvider
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
