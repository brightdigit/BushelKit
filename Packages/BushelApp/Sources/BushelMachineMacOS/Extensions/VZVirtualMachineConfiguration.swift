//
// VZVirtualMachineConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

#if arch(arm64) && canImport(Virtualization)
  import BushelLogging
  import BushelMachine
  import Virtualization

  extension VZVirtualMachineConfiguration: Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .machine
    }

    static let oneMegabyte: UInt64 = (1024 * 1024)
    static let minimumHardDiskSize = UInt64(64 * 1024 * 1024 * 1024)

    convenience init(
      toDirectory machineDirectory: URL,
      basedOn specification: MachineConfiguration,
      withRestoreImage restoreImage: VZMacOSRestoreImage
    ) throws {
      self.init()

      let platform = try VZMacPlatformConfiguration(
        toDirectory: machineDirectory,
        basedOn: specification,
        withRestoreImage: restoreImage
      )
      self.platform = platform

      try configurationAt(machineDirectory, withSpecifications: specification, createDisks: true)
    }

    convenience init(
      contentsOfDirectory directoryURL: URL,
      basedOn specification: MachineConfiguration
    ) throws {
      self.init()

      let platform = try VZMacPlatformConfiguration(fromDirectory: directoryURL)
      self.platform = platform
      try configurationAt(directoryURL, withSpecifications: specification, createDisks: false)
    }

    #warning("logging-note: thinking about how to log these information")
    func configurationAt(
      _ machineDirectory: URL,
      withSpecifications specifications: MachineConfiguration,
      createDisks: Bool
    ) throws {
      cpuCount = specifications.cpuCount
      let memoryMB = (UInt64(specifications.memory) / Self.oneMegabyte)
      memorySize = memoryMB * Self.oneMegabyte

      if specifications.memory != memorySize {
        Self.logger.warning(
          "Memory \(specifications.memory) does not match. Must be multiple of \(Self.oneMegabyte)"
        )
      }

      let disksDirectory = machineDirectory
        .appendingPathComponent("disks", isDirectory: true)
      try FileManager.default
        .createDirectory(at: disksDirectory, withIntermediateDirectories: true)

      storageDevices = try specifications.storage.map { specification in
        try VZVirtioBlockDeviceConfiguration(
          specification: specification,
          createDisk: createDisks,
          parentDirectoryURL: disksDirectory,
          readOnly: false
        )
      }

      networkDevices = specifications.networkConfigurations.map { _ in
        let networkDevice = VZVirtioNetworkDeviceConfiguration()
        networkDevice.attachment = VZNATNetworkDeviceAttachment()
        return networkDevice
      }

      graphicsDevices = specifications.graphicsConfigurations.map { config in
        let displayConfig = VZMacGraphicsDeviceConfiguration()
        displayConfig.displays = config.displays.map { display in
          .init(
            widthInPixels: display.widthInPixels,
            heightInPixels: display.heightInPixels,
            pixelsPerInch: display.pixelsPerInch
          )
        }
        return displayConfig
      }
      networkDevices = networkDevices
      bootLoader = VZMacOSBootLoader()
      pointingDevices = [VZUSBScreenCoordinatePointingDeviceConfiguration()]
      pointingDevices.append(VZMacTrackpadConfiguration())

      keyboards = [VZUSBKeyboardConfiguration()]
    }
  }
#endif
