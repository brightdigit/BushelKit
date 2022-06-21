

#if arch(arm64)
import Foundation
import Virtualization

extension VZMacPlatformConfiguration {
  convenience init (machine: Machine<VZMacOSRestoreImage>, in machineDirectory: URL) throws {
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
#endif
