//
// MachineConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

public extension MachineConfiguration {
  init(
    configurable: some MachineConfigurable
  ) throws {
    guard let machineSystem = configurable.machineSystem else {
      throw ConfigurationError.missingSystemManager
    }

    guard let image = configurable.selectedBuildImage.image else {
      throw ConfigurationError.missingRestoreImageID
    }

    guard let specificationConfiguration = configurable.specificationConfiguration else {
      throw ConfigurationError.missingSpecifications
    }

    self.init(
      restoreImage: image,
      machineSystem: machineSystem,
      specificationConfiguration: specificationConfiguration
    )
  }

  init(
    restoreImage: any InstallerImage,
    machineSystem: any MachineSystem,
    specificationConfiguration: SpecificationConfiguration<some Any>
  ) {
    let storage = MachineStorageSpecification(
      label: machineSystem.defaultStorageLabel,
      size: .init(specificationConfiguration.storage)
    )
    let cpuCount = Int(specificationConfiguration.cpuCount)
    let memory = Int(specificationConfiguration.memory)

    self.init(
      restoreImageFile: restoreImage.identifier,
      vmSystemID: machineSystem.id,
      snapshotSystemID: machineSystem.defaultSnapshotSystem,
      operatingSystemVersion: restoreImage.operatingSystemVersion,
      buildVersion: restoreImage.buildVersion,
      storage: [storage],
      cpuCount: cpuCount,
      memory: memory
    )
  }
}
