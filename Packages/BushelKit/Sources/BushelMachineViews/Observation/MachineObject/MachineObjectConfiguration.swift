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
    let restoreImageDB: any InstallerImageRepository
    let modelContext: ModelContext
    let systemManager: any MachineSystemManaging
    let labelProvider: MetadataLabelProvider
    let snapshotFactory: any SnapshotProvider

    internal init(
      url: URL,
      restoreImageDB: any InstallerImageRepository,
      modelContext: ModelContext,
      systemManager: any MachineSystemManaging,

      snapshotFactory: any SnapshotProvider,
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
      systemManager: any MachineSystemManaging,
      snapshotterFactory: any SnapshotProvider,
      installerImageRepositoryFrom: @escaping (ModelContext) -> any InstallerImageRepository,
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
