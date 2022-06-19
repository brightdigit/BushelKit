
#if arch(arm64)
import Virtualization


extension VZVirtualMachineConfiguration {
  
  
  convenience init (restoreImage : VZMacOSRestoreImage, in machineDirectory: URL) throws {
    self.init()
    
    self.platform = try VZMacPlatformConfiguration(restoreImage: restoreImage, in: machineDirectory)
    self.cpuCount = 1 //machine.cpuCount
      self.memorySize = VZVirtualMachineConfiguration.minimumAllowedMemorySize //machine.memorySize
    
    
      let disksDirectory = machineDirectory.appendingPathComponent("disks", isDirectory: true)
      try FileManager.default.createDirectory(at: disksDirectory, withIntermediateDirectories: true)
      let diskImageURL = disksDirectory.appendingPathComponent("macOS").appendingPathExtension("img")
      try FileManager.default.createFile(atPath: diskImageURL.path, withSize: Int64(16000000000 * 2))
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
    
    self.storageDevices = storageDevices
    self.networkDevices = networkDevices
   // self.directorySharingDevices = directorySharingDevices
    self.bootLoader = VZMacOSBootLoader()
    self.pointingDevices = [VZUSBScreenCoordinatePointingDeviceConfiguration()]
    self.keyboards = [VZUSBKeyboardConfiguration()]
    //self.audioDevices = machine.useHostAudio ? [Self.createAudioDeviceConfiguration()] : []
  }
}
#endif
