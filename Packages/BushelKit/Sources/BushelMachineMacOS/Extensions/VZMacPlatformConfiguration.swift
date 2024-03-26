//
// VZMacPlatformConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && canImport(Combine) && arch(arm64)
  import BushelMachine
  import BushelMacOSCore
  import Virtualization

  extension VZMacPlatformConfiguration {
    convenience init(fromDirectory machineDirectory: URL) throws {
      self.init()
      let auxiliaryStorageURL = machineDirectory
        .appendingPathComponent("auxiliary.storage")
      let hardwareModelURL = machineDirectory
        .appendingPathComponent("hardware.model.bin")
      let machineIdentifierURL = machineDirectory
        .appendingPathComponent("machine.identifier.bin")
      #if swift(>=5.7.1)
        if #available(macOS 13.0, *) {
          self.auxiliaryStorage = VZMacAuxiliaryStorage(url: auxiliaryStorageURL)
        } else {
          auxiliaryStorage = VZMacAuxiliaryStorage(contentsOf: auxiliaryStorageURL)
        }
      #else
        auxiliaryStorage = VZMacAuxiliaryStorage(contentsOf: auxiliaryStorageURL)
      #endif

      #warning("logging-note: are the VirtualizationError thrown in this file printed somewhere?")
      guard let hardwareModel = try VZMacHardwareModel(
        dataRepresentation: Data(contentsOf: hardwareModelURL)
      ) else {
        throw BuilderError.corrupted(.hardwareModel, dataAtURL: hardwareModelURL)
      }
      self.hardwareModel = hardwareModel
      guard let machineIdentifier = try VZMacMachineIdentifier(
        dataRepresentation: .init(contentsOf: machineIdentifierURL)
      ) else {
        throw BuilderError.corrupted(.machineIdentifier, dataAtURL: machineIdentifierURL)
      }
      self.machineIdentifier = machineIdentifier
    }

    #warning("logging-note: to print what has been done here")
    convenience init(
      toDirectory machineDirectory: URL?,
      basedOn _: MachineConfiguration,
      withRestoreImage restoreImage: VZMacOSRestoreImage
    ) throws {
      self.init()

      guard let configuration = restoreImage.mostFeaturefulSupportedConfiguration else {
        let label = MacOSVirtualization.label(fromMetadata: restoreImage.operatingSystem)
        throw BuilderError.noSupportedConfigurationImage(label, isSupported: restoreImage.isSupported)
      }

      if let machineDirectory {
        try FileManager.default.createDirectory(
          at: machineDirectory,
          withIntermediateDirectories: true
        )
        let auxiliaryStorageURL = machineDirectory
          .appendingPathComponent("auxiliary.storage")
        let hardwareModelURL = machineDirectory
          .appendingPathComponent("hardware.model.bin")
        let machineIdentifierURL = machineDirectory
          .appendingPathComponent("machine.identifier.bin")

        let auxiliaryStorage = try VZMacAuxiliaryStorage(
          creatingStorageAt: auxiliaryStorageURL,

          hardwareModel: configuration.hardwareModel,

          options: []
        )

        self.auxiliaryStorage = auxiliaryStorage
        hardwareModel = configuration.hardwareModel
        machineIdentifier = .init()

        try hardwareModel.dataRepresentation.write(to: hardwareModelURL)
        try machineIdentifier.dataRepresentation.write(to: machineIdentifierURL)
      }
    }
  }
#endif
