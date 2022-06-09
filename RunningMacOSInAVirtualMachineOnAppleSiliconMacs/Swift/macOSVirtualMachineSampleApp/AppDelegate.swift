/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application delegate that sets up and starts the virtual machine.
*/

import Cocoa
import Foundation
import Virtualization

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!

    @IBOutlet weak var virtualMachineView: VZVirtualMachineView!

    private var virtualMachineResponder: MacOSVirtualMachineDelegate?

#if arch(arm64)
    private var virtualMachine: VZVirtualMachine!

    // MARK: Create the Mac Platform Configuration

    private func createMacPlaform() -> VZMacPlatformConfiguration {
        let macPlatform = VZMacPlatformConfiguration()

        let auxiliaryStorage = VZMacAuxiliaryStorage(contentsOf: auxiliaryStorageURL)
        macPlatform.auxiliaryStorage = auxiliaryStorage

        if !FileManager.default.fileExists(atPath: vmBundlePath) {
            fatalError("Missing Virtual Machine Bundle at \(vmBundlePath). Run InstallationTool first to create it.")
        }

        // Retrieve the hardware model; you should save this value to disk during installation.
        guard let hardwareModelData = try? Data(contentsOf: hardwareModelURL) else {
            fatalError("Failed to retrieve hardware model data.")
        }

        guard let hardwareModel = VZMacHardwareModel(dataRepresentation: hardwareModelData) else {
            fatalError("Failed to create hardware model.")
        }

        if !hardwareModel.isSupported {
            fatalError("The hardware model is not supported on the current host")
        }
        macPlatform.hardwareModel = hardwareModel

        // Retrieve the machine identifier; you should save this value to disk during installation.
        guard let machineIdentifierData = try? Data(contentsOf: machineIdentifierURL) else {
            fatalError("Failed to retrieve machine identifier data.")
        }

        guard let machineIdentifier = VZMacMachineIdentifier(dataRepresentation: machineIdentifierData) else {
            fatalError("Failed to create machine identifier.")
        }
        macPlatform.machineIdentifier = machineIdentifier

        return macPlatform
    }

    // MARK: Create the Virtual Machine Configuration and instantiate the Virtual Machine

    private func createVirtualMachine() {
        let virtualMachineConfiguration = VZVirtualMachineConfiguration()

        virtualMachineConfiguration.platform = createMacPlaform()
        virtualMachineConfiguration.bootLoader = MacOSVirtualMachineConfigurationHelper.createBootLoader()
        virtualMachineConfiguration.cpuCount = MacOSVirtualMachineConfigurationHelper.computeCPUCount()
        virtualMachineConfiguration.memorySize = MacOSVirtualMachineConfigurationHelper.computeMemorySize()
        virtualMachineConfiguration.graphicsDevices = [MacOSVirtualMachineConfigurationHelper.createGraphicsDeviceConfiguration()]
        virtualMachineConfiguration.storageDevices = [MacOSVirtualMachineConfigurationHelper.createBlockDeviceConfiguration()]
        virtualMachineConfiguration.networkDevices = [MacOSVirtualMachineConfigurationHelper.createNetworkDeviceConfiguration()]
        virtualMachineConfiguration.pointingDevices = [MacOSVirtualMachineConfigurationHelper.createPointingDeviceConfiguration()]
        virtualMachineConfiguration.keyboards = [MacOSVirtualMachineConfigurationHelper.createKeyboardConfiguration()]
        virtualMachineConfiguration.audioDevices = [MacOSVirtualMachineConfigurationHelper.createAudioDeviceConfiguration()]

        try! virtualMachineConfiguration.validate()

        virtualMachine = VZVirtualMachine(configuration: virtualMachineConfiguration)
    }
#endif

    // MARK: Start the Virtual Machine

    func applicationDidFinishLaunching(_ aNotification: Notification) {
#if arch(arm64)
        createVirtualMachine()
        virtualMachineResponder = MacOSVirtualMachineDelegate()
        virtualMachine.delegate = virtualMachineResponder
        virtualMachineView.virtualMachine = virtualMachine
        virtualMachine.start(completionHandler: { (result) in
            switch result {
                case let .failure(error):
                    fatalError("Virtual machine failed to start \(error)")

                default:
                    NSLog("Virtual machine successfully started.")
            }
        })
#endif
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
