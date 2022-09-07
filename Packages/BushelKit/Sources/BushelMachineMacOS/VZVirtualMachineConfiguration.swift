//
// VZVirtualMachineConfiguration.swift
// Copyright (c) 2022 BrightDigit.
//

#if arch(arm64) && canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension VZVirtualMachineConfiguration {
    static func computeCPUCount() -> Int {
      let totalAvailableCPUs = ProcessInfo.processInfo.processorCount

      var virtualCPUCount = totalAvailableCPUs <= 1 ? 1 : totalAvailableCPUs - 1
      virtualCPUCount = max(virtualCPUCount, VZVirtualMachineConfiguration.minimumAllowedCPUCount)
      virtualCPUCount = min(virtualCPUCount, VZVirtualMachineConfiguration.maximumAllowedCPUCount)

      return virtualCPUCount
    }

    static func computeMemorySize() -> UInt64 {
      // We arbitrarily choose 4GB.
      var memorySize = (4 * 1024 * 1024 * 1024) as UInt64
      memorySize = max(memorySize, VZVirtualMachineConfiguration.minimumAllowedMemorySize)
      memorySize = min(memorySize, VZVirtualMachineConfiguration.maximumAllowedMemorySize)

      return memorySize
    }

    fileprivate func defaultConfiguration(_ machineDirectory: URL, createDisks: Bool) throws {
      cpuCount = Self.computeCPUCount()
      memorySize = Self.computeMemorySize() // machine.memorySize

      let disksDirectory = machineDirectory.appendingPathComponent("disks", isDirectory: true)
      try FileManager.default.createDirectory(at: disksDirectory, withIntermediateDirectories: true)
      let diskImageURL = disksDirectory.appendingPathComponent("macOS").appendingPathExtension("img")
      if createDisks {
        try FileManager.default.createFile(atPath: diskImageURL.path, withSize: Int64(64 * 1024 * 1024 * 1024))
      }
      let diskAttachment = try VZDiskImageStorageDeviceAttachment(url: diskImageURL, readOnly: false)
      storageDevices = [VZVirtioBlockDeviceConfiguration(attachment: diskAttachment)]

      let networkDevice = VZVirtioNetworkDeviceConfiguration()
      networkDevice.attachment = VZNATNetworkDeviceAttachment()
      networkDevices = [networkDevice]

      let displayConfig = VZMacGraphicsDeviceConfiguration()
      displayConfig.displays = [
        .init(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80)
      ]
      graphicsDevices = [
        displayConfig
      ]
      storageDevices = storageDevices
      networkDevices = networkDevices
      bootLoader = VZMacOSBootLoader()
      pointingDevices = [VZUSBScreenCoordinatePointingDeviceConfiguration()]
      keyboards = [VZUSBKeyboardConfiguration()]
    }

    convenience init(toDirectory machineDirectory: URL, basedOn machine: Machine, withRestoreImage restoreImage: VZMacOSRestoreImage) throws {
      self.init()

      let platform = try VZMacPlatformConfiguration(toDirectory: machineDirectory, basedOn: machine, withRestoreImage: restoreImage)
      self.platform = platform
      try defaultConfiguration(machineDirectory, createDisks: true)
    }

    convenience init(contentsOfDirectory directoryURL: URL) throws {
      self.init()

      let platform = try VZMacPlatformConfiguration(fromDirectory: directoryURL)
      self.platform = platform
      try defaultConfiguration(directoryURL, createDisks: false)
    }
  }
#endif
