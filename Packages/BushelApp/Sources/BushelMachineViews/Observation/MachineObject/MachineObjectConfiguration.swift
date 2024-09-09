//
// MachineObjectConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelDataCore
  import BushelMachine
  import Combine
  import DataThespian
  import Foundation
  import SwiftData

  internal struct MachineObjectConfiguration: Sendable {
    let url: URL
    let restoreImageDB: any InstallerImageRepository
    let database: any Database
    let systemManager: any MachineSystemManaging
    let labelProvider: MetadataLabelProvider
    let snapshotFactory: any SnapshotProvider
    let databasePublisherFactory: @Sendable (String) -> any Publisher<any DatabaseChangeSet, Never>

    internal init(
      url: URL,
      restoreImageDB: any InstallerImageRepository,
      database: any Database,
      systemManager: any MachineSystemManaging,
      snapshotFactory: any SnapshotProvider,
      labelProvider: @escaping MetadataLabelProvider,
      databasePublisherFactory: @escaping @Sendable (String) -> any Publisher<any DatabaseChangeSet, Never>
    ) {
      self.url = url
      self.restoreImageDB = restoreImageDB
      self.database = database
      self.systemManager = systemManager
      self.labelProvider = labelProvider
      self.snapshotFactory = snapshotFactory
      self.databasePublisherFactory = databasePublisherFactory
    }
  }

  extension MachineObjectConfiguration {
    init(
      url: URL,
      database: any Database,
      systemManager: any MachineSystemManaging,
      snapshotterFactory: any SnapshotProvider,
      installerImageRepositoryFrom: @escaping (any Database) -> any InstallerImageRepository,
      labelProvider: @escaping MetadataLabelProvider,
      databasePublisherFactory: @escaping @Sendable (String) -> any Publisher<any DatabaseChangeSet, Never>
    ) {
      self.init(
        url: url,
        restoreImageDB: installerImageRepositoryFrom(database),
        database: database,
        systemManager: systemManager,
        snapshotFactory: snapshotterFactory,
        labelProvider: labelProvider,
        databasePublisherFactory: databasePublisherFactory
      )
    }
  }

#endif
