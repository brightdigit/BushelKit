//
// VZMacPlatformConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && canImport(Combine) && arch(arm64)
  import BushelVirtualization
  import Combine
  import Virtualization

  extension VZMacPlatformConfiguration {
    // swiftlint:disable:next function_body_length
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

      guard let hardwareModel = VZMacHardwareModel(
        dataRepresentation: try Data(contentsOf: hardwareModelURL)
      ) else {
        throw VirtualizationError.undefinedType(
          "Invalid hardware model url",
          hardwareModelURL
        )
      }
      self.hardwareModel = hardwareModel
      guard let machineIdentifier = VZMacMachineIdentifier(
        dataRepresentation: try .init(contentsOf: machineIdentifierURL)
      ) else {
        throw VirtualizationError.undefinedType(
          "Invalid machineIdentifierURL",
          machineIdentifierURL
        )
      }
      self.machineIdentifier = machineIdentifier
    }

    // swiftlint:disable:next function_body_length
    convenience init(
      toDirectory machineDirectory: URL,
      basedOn _: MachineSpecification,
      withRestoreImage restoreImage: VZMacOSRestoreImage
    ) throws {
      self.init()

      guard let configuration = restoreImage.mostFeaturefulSupportedConfiguration else {
        if restoreImage.isImageSupported {
          throw VirtualizationError.undefinedType(
            "This image contains no valid machine configuration.",
            restoreImage
          )
        } else {
          throw VirtualizationError.undefinedType(
            "This image is not supported.",
            restoreImage
          )
        }
      }

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
#endif
