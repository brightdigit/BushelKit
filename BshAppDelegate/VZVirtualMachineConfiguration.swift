
#if arch(arm64)
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
        
        self.cpuCount = Self.computeCPUCount()
        self.memorySize = Self.computeMemorySize() //machine.memorySize
        
        
        let disksDirectory = machineDirectory.appendingPathComponent("disks", isDirectory: true)
        try FileManager.default.createDirectory(at: disksDirectory, withIntermediateDirectories: true)
        let diskImageURL = disksDirectory.appendingPathComponent("macOS").appendingPathExtension("img")
        if createDisks{
            try FileManager.default.createFile(atPath: diskImageURL.path, withSize: Int64( 64 * 1024 * 1024 * 1024))
        }
        let diskAttachment = try VZDiskImageStorageDeviceAttachment(url: diskImageURL, readOnly: false)
        self.storageDevices = [VZVirtioBlockDeviceConfiguration(attachment: diskAttachment)]
        //    let disksDirectory = machineDirectory.appendingPathComponent("disks", isDirectory: true)
        //    try FileManager.default.createDirectory(at: disksDirectory, withIntermediateDirectories: true)
        //    // disks
        //    let storageDevices = try machine.disks.map{ disk -> VZVirtioBlockDeviceConfiguration in
        //      let diskImageURL = disksDirectory.appendingPathComponent( disk.id.uuidString).appendingPathExtension("img")
        //
        //      try FileManager.default.createFile(atPath: diskImageURL.path, withSize: Int64(disk.size))
        //
        //      let attachment = try VZDiskImageStorageDeviceAttachment(url: diskImageURL, readOnly: disk.readOnly)
        //
        //      return VZVirtioBlockDeviceConfiguration(attachment: attachment)
        //    }
        
        // network
        let networkDevice = VZVirtioNetworkDeviceConfiguration()
        networkDevice.attachment = VZNATNetworkDeviceAttachment()
        self.networkDevices = [networkDevice]
        
        //    let networkDevices = machine.networks.map { network -> VZVirtioNetworkDeviceConfiguration in
        //      let networkDevice = VZVirtioNetworkDeviceConfiguration()
        //
        //      let networkAttachment : VZNetworkDeviceAttachment?
        //
        //      switch network.type {
        //      case .NAT:
        //        networkAttachment = VZNATNetworkDeviceAttachment()
        //      case .bridgeHostInterfaceWithID(let identifier):
        //        let interface = VZBridgedNetworkInterface.networkInterfaces.first( where: { $0.identifier == identifier})
        //        networkAttachment = interface.map(VZBridgedNetworkDeviceAttachment.init(interface: ))
        //      }
        //      networkDevice.attachment = networkAttachment
        //
        //      let macAddress : VZMACAddress?
        //
        //      switch network.macAddress {
        //      case .random:
        //        macAddress = .randomLocallyAdministered()
        //      case .string(let value):
        //        macAddress = .init(string: value)
        //      }
        //
        //      networkDevice.macAddress = macAddress ?? .randomLocallyAdministered()
        //      return networkDevice
        //    }
        
        //    let directorySharingDevices = machine.shares.map { share -> VZDirectorySharingDeviceConfiguration in
        //      let configuration = VZVirtioFileSystemDeviceConfiguration(tag: share.tag)
        //      let configShare = VZSingleDirectoryShare(directory: .init(url: share.url, readOnly: share.readOnly))
        //      configuration.share = configShare
        //      return configuration
        //    }
        let displayConfig =    VZMacGraphicsDeviceConfiguration()
        displayConfig.displays = [
            .init(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80)
        ]
        self.graphicsDevices = [
            displayConfig
        ]
        self.storageDevices = storageDevices
        self.networkDevices = networkDevices
        // self.directorySharingDevices = directorySharingDevices
        self.bootLoader = VZMacOSBootLoader()
        self.pointingDevices = [VZUSBScreenCoordinatePointingDeviceConfiguration()]
        self.keyboards = [VZUSBKeyboardConfiguration()]
    }
    
    convenience init (restoreImage : VZMacOSRestoreImage, in machineDirectory: URL) throws {
    self.init()
    
    let platform = try VZMacPlatformConfiguration(restoreImage: restoreImage, in: machineDirectory)
        self.platform = platform
        try defaultConfiguration(machineDirectory, createDisks: true)
    //self.audioDevices = machine.useHostAudio ? [Self.createAudioDeviceConfiguration()] : []
  }
    
    convenience init(contentsOfDirectory directoryURL: URL) throws {
        self.init()
        
        let platform = try VZMacPlatformConfiguration(fromDirectory: directoryURL)
            self.platform = platform
        try defaultConfiguration(directoryURL, createDisks: false)
    }
   
}
#endif
