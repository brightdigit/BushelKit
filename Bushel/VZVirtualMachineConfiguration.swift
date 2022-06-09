
#if arch(arm64)
import Virtualization


extension VZVirtualMachineConfiguration {
  static func validateMachine(_ machine: Machine) throws {
    try self.validateMachine(machine, machineParentDirectory: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true))
  }
  static func validateMachine(_ machine: Machine, machineParentDirectory: URL) throws {
    
    _ = try self.validatedConfiguration(fromMachine: machine, machineParentDirectory: machineParentDirectory)
  }
  static func validatedConfiguration(fromMachine machine : Machine, machineParentDirectory: URL) throws -> VZVirtualMachineConfiguration {
    let configuration = try VZVirtualMachineConfiguration(machine: machine, machineParentDirectory: machineParentDirectory)
    try configuration.validate()
    return configuration
  }
  
  static func createAudioDeviceConfiguration() -> VZVirtioSoundDeviceConfiguration {
      let audioConfiguration = VZVirtioSoundDeviceConfiguration()

      let inputStream = VZVirtioSoundDeviceInputStreamConfiguration()
      inputStream.source = VZHostAudioInputStreamSource()

      let outputStream = VZVirtioSoundDeviceOutputStreamConfiguration()
      outputStream.sink = VZHostAudioOutputStreamSink()

      audioConfiguration.streams = [inputStream, outputStream]
      return audioConfiguration
  }
  
  convenience init (machine: Machine, machineParentDirectory: URL) throws {
    self.init()
    
    
    let machineDirectory = machineParentDirectory.appendingPathComponent(machine.id.uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: machineDirectory, withIntermediateDirectories: true)
    
    
    self.platform = try VZMacPlatformConfiguration(machine: machine, in: machineDirectory)
    self.cpuCount = machine.cpuCount
    self.memorySize = machine.memorySize
    
    
    let disksDirectory = machineDirectory.appendingPathComponent("disks", isDirectory: true)
    try FileManager.default.createDirectory(at: disksDirectory, withIntermediateDirectories: true)
    // disks
    let storageDevices = try machine.disks.map{ disk -> VZVirtioBlockDeviceConfiguration in
      let diskImageURL = disksDirectory.appendingPathComponent( disk.id.uuidString).appendingPathExtension("img")
      
      try FileManager.default.createFile(atPath: diskImageURL.path, withSize: Int64(disk.size))
      
      let attachment = try VZDiskImageStorageDeviceAttachment(url: diskImageURL, readOnly: disk.readOnly)
      
      return VZVirtioBlockDeviceConfiguration(attachment: attachment)
    }
    
    // network
    
    let networkDevices = machine.networks.map { network -> VZVirtioNetworkDeviceConfiguration in
      let networkDevice = VZVirtioNetworkDeviceConfiguration()
      
      let networkAttachment : VZNetworkDeviceAttachment?
      
      switch network.type {
      case .NAT:
        networkAttachment = VZNATNetworkDeviceAttachment()
      case .bridgeHostInterfaceWithID(let identifier):
        let interface = VZBridgedNetworkInterface.networkInterfaces.first( where: { $0.identifier == identifier})
        networkAttachment = interface.map(VZBridgedNetworkDeviceAttachment.init(interface: ))
      }
      networkDevice.attachment = networkAttachment
      
      let macAddress : VZMACAddress?
      
      switch network.macAddress {
      case .random:
        macAddress = .randomLocallyAdministered()
      case .string(let value):
        macAddress = .init(string: value)
      }
      
      networkDevice.macAddress = macAddress ?? .randomLocallyAdministered()
      return networkDevice
    }
    
    let directorySharingDevices = machine.shares.map { share -> VZDirectorySharingDeviceConfiguration in
      let configuration = VZVirtioFileSystemDeviceConfiguration(tag: share.tag)
      let configShare = VZSingleDirectoryShare(directory: .init(url: share.url, readOnly: share.readOnly))
      configuration.share = configShare
      return configuration
    }
    
    self.storageDevices = storageDevices
    self.networkDevices = networkDevices
    self.directorySharingDevices = directorySharingDevices
    self.bootLoader = VZMacOSBootLoader()
    self.pointingDevices = [VZUSBScreenCoordinatePointingDeviceConfiguration()]
    self.keyboards = [VZUSBKeyboardConfiguration()]
    self.audioDevices = machine.useHostAudio ? [Self.createAudioDeviceConfiguration()] : []
  }
}
#endif
