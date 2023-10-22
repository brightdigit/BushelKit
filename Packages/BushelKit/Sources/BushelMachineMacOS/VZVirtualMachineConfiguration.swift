//
// VZVirtualMachineConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

#if arch(arm64) && canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension VZVirtualMachineConfiguration {
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

    static func computeCPUCount() -> Int {
      let totalAvailableCPUs = ProcessInfo.processInfo.processorCount

      var virtualCPUCount = totalAvailableCPUs <= 1 ? 1 : totalAvailableCPUs - 1
      virtualCPUCount = max(
        virtualCPUCount, VZVirtualMachineConfiguration.minimumAllowedCPUCount
      )
      virtualCPUCount = min(
        virtualCPUCount, VZVirtualMachineConfiguration.maximumAllowedCPUCount
      )

      return virtualCPUCount
    }

    static func computeMemorySize() -> UInt64 {
      // We arbitrarily choose 4GB.
      var memorySize = (4 * 1024 * 1024 * 1024) as UInt64
      memorySize = max(
        memorySize, VZVirtualMachineConfiguration.minimumAllowedMemorySize
      )
      memorySize = min(
        memorySize, VZVirtualMachineConfiguration.maximumAllowedMemorySize
      )

      return memorySize
    }

    #warning("logging-note: thinking about how to log these information")
    func configurationAt(
      _ machineDirectory: URL,
      withSpecifications specifications: MachineConfiguration,
      createDisks: Bool
    ) throws {
      cpuCount = Self.computeCPUCount()
      memorySize = Self.computeMemorySize() // machine.memorySize

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
        displayConfig.displays = config.displays.map { _ in
          .init(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80)
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
