


struct MachineBuilder {
  internal init(name: String? = nil, cpuCount: Int = 1, memorySize: UInt64 = (4 * 1024 * 1024 * 1024), displays: [MachineDisplay] = [MachineDisplay](), disks: [MachineDisk] = [MachineDisk](), shares: [MachineSharedDirectory] = [MachineSharedDirectory](), sourceImage: LocalImage,useHostAudio : Bool = true) {
    
//    self.cpuCount = cpuCount
//    self.memorySize = memorySize
//    self.displays = displays
//    self.disks = disks
    self.sourceImage = sourceImage
    self.name = name ?? sourceImage.name
    self.useHostAudio = useHostAudio
  }
  
  var name : String
  var cpuCount : Int = 1
  var memorySize : UInt64 = (4 * 1024 * 1024 * 1024)
  var displays = [MachineDisplay(width: 1920, height: 1080, pixelsPerInch: 76)]
  var disks = [MachineDisk(size: 64 * 1024 * 1024 * 1024)]
  var networks = [MachineNetwork(type: .NAT, macAddress: .random)]
  var shares = [MachineSharedDirectory]()
  let sourceImage : LocalImage
  let useHostAudio : Bool
  
}
