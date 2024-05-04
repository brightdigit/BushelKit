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
    let database: any Database
    let systemManager: any MachineSystemManaging
    let labelProvider: MetadataLabelProvider
    let snapshotFactory: any SnapshotProvider

    internal init(
      url: URL,
      restoreImageDB: any InstallerImageRepository,
      database: any Database,
      systemManager: any MachineSystemManaging,
      snapshotFactory: any SnapshotProvider,
      labelProvider: @escaping MetadataLabelProvider
    ) {
      self.url = url
      self.restoreImageDB = restoreImageDB
      self.database = database
      self.systemManager = systemManager
      self.labelProvider = labelProvider
      self.snapshotFactory = snapshotFactory
    }
  }

  extension MachineObjectConfiguration {
    init(
      url: URL,
      database: any Database,
      systemManager: any MachineSystemManaging,
      snapshotterFactory: any SnapshotProvider,
      installerImageRepositoryFrom: @escaping (any Database) -> any InstallerImageRepository,
      labelProvider: @escaping MetadataLabelProvider
    ) {
      self.init(
        url: url,
        restoreImageDB: installerImageRepositoryFrom(database),
        database: database,
        systemManager: systemManager,
        snapshotFactory: snapshotterFactory,
        labelProvider: labelProvider
      )
    }
  }

#endif
