
import Virtualization
import Combine


extension VZMacPlatformConfiguration {
    convenience init(fromDirectory machineDirectory: URL) throws {
        self.init()
        let auxiliaryStorageURL = machineDirectory.appendingPathComponent("auxiliary.storage")
        let hardwareModelURL = machineDirectory.appendingPathComponent("hardware.model.bin")
        let machineIdentifierURL = machineDirectory.appendingPathComponent("machine.identifier.bin")
        if #available(macOS 13.0, *) {
            self.auxiliaryStorage = VZMacAuxiliaryStorage(url: auxiliaryStorageURL)
        } else {
            self.auxiliaryStorage = VZMacAuxiliaryStorage(contentsOf: auxiliaryStorageURL)
            // Fallback on earlier versions
        }
        
        guard let hardwareModel = VZMacHardwareModel(dataRepresentation: try Data(contentsOf: hardwareModelURL) ) else {
            throw NSError()
        }
        self.hardwareModel = hardwareModel
        guard let machineIdentifier = VZMacMachineIdentifier(dataRepresentation: try .init(contentsOf: machineIdentifierURL)) else {
            throw NSError()
        }
        self.machineIdentifier = machineIdentifier
    }
    convenience init(restoreImage : VZMacOSRestoreImage, in machineDirectory: URL) throws
    {
        self.init()
        
        
        guard let configuration = restoreImage.mostFeaturefulSupportedConfiguration else {
          throw NSError()
        }
        
        try FileManager.default.createDirectory(at: machineDirectory, withIntermediateDirectories: true)
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
