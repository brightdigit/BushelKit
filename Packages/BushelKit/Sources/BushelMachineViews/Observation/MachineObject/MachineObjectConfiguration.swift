//
// MachineObjectConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelDataCore
  import BushelMachine
  import Foundation
  import SwiftData

  struct MachineObjectConfiguration {
    let url: URL
    let restoreImageDB: InstallerImageRepository
    let modelContext: ModelContext
    let systemManager: MachineSystemManaging
    let labelProvider: MetadataLabelProvider
    let snapshotFactory: SnapshotProvider

    internal init(
      url: URL,
      restoreImageDB: InstallerImageRepository,
      modelContext: ModelContext,
      systemManager: MachineSystemManaging,

      snapshotFactory: SnapshotProvider,
      labelProvider: @escaping MetadataLabelProvider
    ) {
      self.url = url
      self.restoreImageDB = restoreImageDB
      self.modelContext = modelContext
      self.systemManager = systemManager
      self.labelProvider = labelProvider
      self.snapshotFactory = snapshotFactory
    }
  }

  extension MachineObjectConfiguration {
    init(
      url: URL,
      modelContext: ModelContext,
      systemManager: MachineSystemManaging,
      snapshotterFactory: SnapshotProvider,
      installerImageRepositoryFrom: @escaping (ModelContext) -> InstallerImageRepository,
      labelProvider: @escaping MetadataLabelProvider
    ) {
      self.init(
        url: url,
        restoreImageDB: installerImageRepositoryFrom(modelContext),
        modelContext: modelContext,
        systemManager: systemManager,
        snapshotFactory: snapshotterFactory,
        labelProvider: labelProvider
      )
    }
  }

#endif
