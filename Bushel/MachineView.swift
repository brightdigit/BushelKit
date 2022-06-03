//
//  MachineView.swift
//  Bushel
//
//  Created by Leo Dion on 6/1/22.
//

#if arch(arm64)
import SwiftUI
import Virtualization


struct FileCreationError : Error {
  let code : Int
  let type : ErrorType
  
  enum ErrorType {
  case `open`
  case ftruncate
  case close
  }
}
extension FileManager {
  func createFile (atPath path: String, withSize size: Int64) throws {
    self.createFile(atPath: path, contents: nil)
    let diskFd = open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR)
    guard diskFd > 0 else {
      throw FileCreationError(code: Int(errno), type: .open)
    }

    // 64GB disk space.
    var result = ftruncate(diskFd, size)
    
    guard result == 0 else {
      throw FileCreationError(code: Int(result), type: .ftruncate)
    }


    result = close(diskFd)
    guard result == 0 else {
      throw FileCreationError(code: Int(result), type: .close)
    }
  }
}

struct MachineNetwork {
  enum InterfaceType {
    case bridgeHostInterfaceWithID(String)
    case NAT
  }
  
  enum MacAddress {
    case string(String)
    case random
  }
  let type : InterfaceType
  let macAddress : MacAddress
}

struct MachineSharedDirectory {
  let url : URL
  let tag : String
  let readOnly : Bool = false
}
struct Machine {
  internal init(id : UUID = .init(), name : String, cpuCount: Int, memorySize: UInt64, displays: [MachineDisplay], disks: [MachineDisk], networks: [MachineNetwork], shares: [MachineSharedDirectory], useHostAudio : Bool, sourceImage: LocalImage) {
    self.id = id
    self.name = name
    self.cpuCount = cpuCount
    self.memorySize = memorySize
    self.displays = displays
    self.disks = disks
    self.networks = networks
    self.shares = shares
    self.sourceImage = sourceImage
    self.useHostAudio = useHostAudio
  }
  
  let name : String
  let id : UUID
  let cpuCount : Int
  let memorySize : UInt64
  let displays : [MachineDisplay]
  let disks : [MachineDisk]
  let networks : [MachineNetwork]
  let shares : [MachineSharedDirectory]
  let sourceImage : LocalImage
  let useHostAudio : Bool
  
  
  init(builder: MachineBuilder, validateWith validate: @escaping (Machine) throws -> Void) throws {
    self.init(name: builder.name, cpuCount: builder.cpuCount, memorySize: builder.memorySize, displays: builder.displays, disks: builder.disks, networks: builder.networks,  shares: builder.shares, useHostAudio: builder.useHostAudio, sourceImage: builder.sourceImage)
    
    try validate(self)
  }
}

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

extension VZMacPlatformConfiguration {
  convenience init (machine: Machine, in machineDirectory: URL) throws {
    self.init()
    
    guard let configuration = machine.sourceImage.mostFeaturefulSupportedConfiguration else {
      throw NSError()
    }
    let auxiliaryStorageURL = machineDirectory.appendingPathComponent("auxiliary.storage")
    let hardwareModelURL = machineDirectory.appendingPathComponent("hardware.model.bin")
    let machineIdentifierURL = machineDirectory.appendingPathComponent("machine.identifier.bin")
    
    let auxiliaryStorage = try VZMacAuxiliaryStorage(creatingStorageAt: auxiliaryStorageURL,
                                                      hardwareModel: configuration.hardwareModel,
                                                            options: [])
    
    self.auxiliaryStorage = auxiliaryStorage
    self.hardwareModel = configuration.hardwareModel
    self.machineIdentifier = .init()
    
    try self.hardwareModel.dataRepresentation.write(to: hardwareModelURL)
    try self.machineIdentifier.dataRepresentation.write(to: machineIdentifierURL)
  }
}
extension Machine {
  
  init(builder: MachineBuilder) throws {
    try self.init(builder: builder, validateWith: VZVirtualMachineConfiguration.validateMachine)
  }
}



struct MachineDisplay {
  let width : Int
  let height: Int
  let pixelsPerInch : Int
}

struct MachineDisk {
  let id : UUID
  let size: UInt64
  let readOnly : Bool
}

struct MachineBuilderRange {
  let cpuCountRange : ClosedRange<Int>
  let memoryRange : ClosedRange<UInt64>
  
  private init () {
    self.memoryRange =
    VZVirtualMachineConfiguration.minimumAllowedMemorySize ... VZVirtualMachineConfiguration.maximumAllowedMemorySize
    
    let totalAvailableCPUs = ProcessInfo.processInfo.processorCount
    let virtualCPUCount = totalAvailableCPUs <= 1 ? 1 : totalAvailableCPUs - 1
    let minCpuCount = max(1, VZVirtualMachineConfiguration.minimumAllowedCPUCount)
    let maxCpuCount = min(virtualCPUCount, VZVirtualMachineConfiguration.maximumAllowedCPUCount)
    self.cpuCountRange = .init(uncheckedBounds: (minCpuCount, maxCpuCount))
  }
  
  static let shared : Self = .init()
}

struct MachineBuilder {
  internal init(name: String? = nil, cpuCount: Int = 1, memorySize: UInt64 = (4 * 1024 * 1024 * 1024), displays: [MachineDisplay] = [MachineDisplay](), disks: [MachineDisk] = [MachineDisk](), shares: [MachineSharedDirectory] = [MachineSharedDirectory](), sourceImage: LocalImage,useHostAudio : Bool = true) {
    
    self.cpuCount = cpuCount
    self.memorySize = memorySize
    self.displays = displays
    self.disks = disks
    self.sourceImage = sourceImage
    self.name = name ?? sourceImage.name
    self.useHostAudio = useHostAudio
  }
  
  var name : String
  var cpuCount : Int = 1
  var memorySize : UInt64 = (4 * 1024 * 1024 * 1024)
  var displays = [MachineDisplay]()
  var disks = [MachineDisk]()
  var networks = [MachineNetwork]()
  var shares = [MachineSharedDirectory]()
  let sourceImage : LocalImage
  let useHostAudio : Bool
  
}
extension ClosedRange {
    init<Other: Comparable>(_ other: ClosedRange<Other>, _ transform: (Other) -> Bound) {
        self = transform(other.lowerBound)...transform(other.upperBound)
    }
}
struct MachineView: View {
  @State var machineBuilder : MachineBuilder
  let ranges = MachineBuilderRange.shared
  let onCompleted : (Machine?) -> Void
  init (from image: LocalImage, _ completed: @escaping (Machine?) -> Void) {
    self._machineBuilder = .init(initialValue: .init(sourceImage: image))
    self.onCompleted = completed
  }
  
  var memoryFloat: Binding<Double>{
          Binding<Double>(get: {
              //returns the score as a Double
            return Double(self.machineBuilder.memorySize)
          }, set: {
              //rounds the double to an Int
              
            self.machineBuilder.memorySize = UInt64($0)
          })
      }
  
  var memoryRange : ClosedRange<Double> {
    .init(self.ranges.memoryRange) { value in
      let doubleValue = Double(value)
      print(doubleValue)
      return doubleValue
    }
  }
  var cpuCountFloat: Binding<Double>{
          Binding<Double>(get: {
              //returns the score as a Double
            return Double(self.machineBuilder.cpuCount)
          }, set: {
              //rounds the double to an Int
              
            self.machineBuilder.cpuCount = Int($0)
          })
      }
  
  var cpuCountRange : ClosedRange<Double> {
    .init(self.ranges.cpuCountRange, Double.init)
  }
  
  
  
    var body: some View {
      Form{
        Section{
        TextField("Name", text: self.$machineBuilder.name)
        }
        
          Section{
            Slider(value: self.cpuCountFloat, in: self.cpuCountRange, step: 1.0) {
              Text("CPU Count")
            }
          }
        Section{
        Slider(value: self.memoryFloat, in: self.memoryRange, step: 1.0) {
          Text("Memory")
        }
        }
        
        Section(header: Text("Disks"), content: {
          List{
            Text("Disk")
          }
        })
        
        
        Section(header: Text("Network Adapters"), content: {
          List{
            Text("Disk")
          }
        })
        
        
        Section{
        HStack{
          Button("Build") {
            let machine : Machine
            do {
            machine = try Machine(builder: self.machineBuilder)
            } catch {
              return
            }
            self.onCompleted(machine)
           
          }
          Button("Cancel") {
            self.onCompleted(nil)
          }
        }
        }
      }.padding()
    }
}

struct MachineView_Previews: PreviewProvider {
    static var previews: some View {
      MachineView(from: .previewModel) { _ in
      }
    }
}
#endif
