

#if arch(arm64)
import Virtualization
struct Machine {
  internal init(id : UUID = .init(), name : String, cpuCount: Int, memorySize: UInt64, displays: [MachineDisplay], disks: [MachineDisk], networks: [MachineNetwork], shares: [MachineSharedDirectory], useHostAudio : Bool, sourceImage: RestoreImage) {
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
  let sourceImage : RestoreImage
  let useHostAudio : Bool
  
  
  init(builder: MachineBuilder, validateWith validate: @escaping (Machine) throws -> Void) throws {
    self.init(name: builder.name, cpuCount: builder.cpuCount, memorySize: builder.memorySize, displays: builder.displays, disks: builder.disks, networks: builder.networks,  shares: builder.shares, useHostAudio: builder.useHostAudio, sourceImage: builder.sourceImage)
    
    try validate(self)
  }
}

extension Machine {
  
  init(builder: MachineBuilder) throws {
    try self.init(builder: builder, validateWith: VZVirtualMachineConfiguration.validateMachine)
  }
}
#endif
