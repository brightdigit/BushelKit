import Virtualization

private let readPipe = Pipe()
private let writePipe = Pipe()

let kernelURL = URL(fileURLWithPath: "/Users/leo/Downloads/vmlinuz-5.4.0-26-generic.efi.signed")
let bootableImageURL = URL(fileURLWithPath: "/Users/leo/Downloads", isDirectory: true).appendingPathComponent(UUID().uuidString) // FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
FileManager.default.createFile(atPath: bootableImageURL.path, contents: nil, attributes: nil)
// let result = truncate(bootableImageURL.absoluteString, 1024 * 1024 * 1024);
let harddrive = try! FileHandle(forWritingTo: bootableImageURL)
try! harddrive.truncate(atOffset: 1024 * 1024 * 1024)
try! harddrive.close()
let initialRamdiskURL = URL(fileURLWithPath: "/Users/leo/Downloads/initrd")

let bootloader = VZLinuxBootLoader(kernelURL: kernelURL)
bootloader.initialRamdiskURL = initialRamdiskURL
bootloader.commandLine = "console=hvc0"

let serial = VZVirtioConsoleDeviceSerialPortConfiguration()

serial.attachment = VZFileHandleSerialPortAttachment(
  fileHandleForReading: writePipe.fileHandleForReading,
  fileHandleForWriting: readPipe.fileHandleForWriting
)

let entropy = VZVirtioEntropyDeviceConfiguration()

let memoryBalloon = VZVirtioTraditionalMemoryBalloonDeviceConfiguration()

let blockAttachment: VZDiskImageStorageDeviceAttachment

blockAttachment = try VZDiskImageStorageDeviceAttachment(
  url: bootableImageURL,
  readOnly: true
)

let blockDevice = VZVirtioBlockDeviceConfiguration(attachment: blockAttachment)

let networkDevice = VZVirtioNetworkDeviceConfiguration()
networkDevice.attachment = VZNATNetworkDeviceAttachment()

let config = VZVirtualMachineConfiguration()
config.bootLoader = bootloader
config.cpuCount = 4
config.memorySize = 2 * 1024 * 1024 * 1024
config.entropyDevices = [entropy]
config.memoryBalloonDevices = [memoryBalloon]
config.serialPorts = [serial]
config.storageDevices = [blockDevice]
config.networkDevices = [networkDevice]

try config.validate()

let vm = VZVirtualMachine(configuration: config)
