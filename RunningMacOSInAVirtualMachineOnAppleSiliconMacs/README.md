# Running macOS in a Virtual Machine on Apple Silicon Macs

Install and run macOS in a virtual machine using the Virtualization framework.

## Overview

This sample code project demonstrates how to install and run macOS virtual machines on Apple Silicon using the Virtualization framework. 
There are two separate applications included in the Xcode project: 

- InstallationTool, a command line tool that installs macOS onto a virtual machine from a restore image. You can use the installation tool to download the restore image of the most current macOS release from the network, or, if you already have previously saved a restore image, directly install macOS with your own restore image. The installation tool creates a VM Bundle in your home directory and stores the resulting virtual machine images there.

- macOSVirtualMachineSampleApp, a macOS app that launches and controls the macOS virtual guest that loads and runs macOS from the VM Bundle. 

You run the installation tool from inside Xcode or the command line to install the macOS image. After it successfully installs the image, you run the macOSVirtualMachineSampleApp to run the macOS guest operating system. The macOSVirtualMachineSampleApp starts the virtual machine and configures a graphical view that you interact with. The virtual Mac continues running until you shut it down from inside the guest OS, or you quit the macOSVirtualMachineSampleApp.

[class_VZVirtualMachineConfiguration]:https://developer.apple.com/documentation/virtualization/vzvirtualmachineconfiguration
[class_VZMacOSBootLoader]:https://developer.apple.com/documentation/virtualization/vzmacosbootloader
[class_VZVirtualMachine]:https://developer.apple.com/documentation/virtualization/vzvirtualmachine
[class_VZMacPlatformConfiguration]:https://developer.apple.com/documentation/virtualization/vzmacplatformconfiguration
[class_VZMacGraphicsDeviceConfiguration]:https://developer.apple.com/documentation/virtualization/vzmacgraphicsdeviceconfiguration
[class_VZVirtualMachineView]:[class_VZMacGraphicsDeviceConfiguration]:https://developer.apple.com/documentation/virtualization/vzvirtualmachineview
[property_bootLoader]:https://developer.apple.com/documentation/virtualization/vzvirtualmachineconfiguration/3656716-bootloader
[property_hardwareModel]:https://developer.apple.com/documentation/virtualization/vzmacosconfigurationrequirements/3816066-hardwaremodel
[property_machineIdentifier]:https://developer.apple.com/documentation/virtualization/vzmacplatformconfiguration/3816084-machineidentifier
[method_start]:https://developer.apple.com/documentation/virtualization/vzvirtualmachine/3656826-start
[method_guestDidStop]:https://developer.apple.com/documentation/virtualization/vzvirtualmachinedelegate/3656730-guestdidstop

## Configure the Sample Code Project

There are four build targets in this project that represent the InstallationTool and the macOSVirtualMachineSampleApp, one set of targets each for Swift and Objective-C versions of the apps. You can use either version, they're functionally identical.

InstallationTool is a command-line tool that installs a macOS VM Bundle from a restore image. Running this tool without any arguments, it tries to download the latest available restore image from the network and then install macOS from that restore image. In the example below, the InstallationTool reads the values in the downloaded image and creates a macOS VM image on disk:

``` swift
let virtualMachineConfiguration = VZVirtualMachineConfiguration()

virtualMachineConfiguration.platform = createMacPlatformConfiguration(macOSConfiguration: macOSConfiguration)
virtualMachineConfiguration.cpuCount = MacOSVirtualMachineConfigurationHelper.computeCPUCount()
if virtualMachineConfiguration.cpuCount < macOSConfiguration.minimumSupportedCPUCount {
    fatalError("CPUCount is not supported by the macOS configuration.")
}

virtualMachineConfiguration.memorySize = MacOSVirtualMachineConfigurationHelper.computeMemorySize()
if virtualMachineConfiguration.memorySize < macOSConfiguration.minimumSupportedMemorySize {
    fatalError("memorySize is not supported by the macOS configuration.")
}

// Create a 64 GB disk image.
createDiskImage()

virtualMachineConfiguration.bootLoader = MacOSVirtualMachineConfigurationHelper.createBootLoader()
virtualMachineConfiguration.graphicsDevices = [MacOSVirtualMachineConfigurationHelper.createGraphicsDeviceConfiguration()]
virtualMachineConfiguration.storageDevices = [MacOSVirtualMachineConfigurationHelper.createBlockDeviceConfiguration()]
virtualMachineConfiguration.networkDevices = [MacOSVirtualMachineConfigurationHelper.createNetworkDeviceConfiguration()]
virtualMachineConfiguration.pointingDevices = [MacOSVirtualMachineConfigurationHelper.createPointingDeviceConfiguration()]
virtualMachineConfiguration.keyboards = [MacOSVirtualMachineConfigurationHelper.createKeyboardConfiguration()]
virtualMachineConfiguration.audioDevices = [MacOSVirtualMachineConfigurationHelper.createAudioDeviceConfiguration()]

try! virtualMachineConfiguration.validate()

virtualMachine = VZVirtualMachine(configuration: virtualMachineConfiguration)
virtualMachineResponder = MacOSVirtualMachineDelegate()
virtualMachine.delegate = virtualMachineResponder
```

The equivalent Objective-C version is:

``` objective-c
VZVirtualMachineConfiguration *configuration = [VZVirtualMachineConfiguration new];

configuration.platform = [self createMacPlatformConfiguration:macOSConfiguration];
assert(configuration.platform);

configuration.CPUCount = [MacOSVirtualMachineConfigurationHelper computeCPUCount];
if (configuration.CPUCount < macOSConfiguration.minimumSupportedCPUCount) {
    abortWithErrorMessage(@"CPUCount is not supported by the macOS configuration.");
}

configuration.memorySize = [MacOSVirtualMachineConfigurationHelper computeMemorySize];
if (configuration.memorySize < macOSConfiguration.minimumSupportedMemorySize) {
    abortWithErrorMessage(@"memorySize is not supported by the macOS configuration.");
}

// Create a 64 GB disk image.
createDiskImage();

configuration.bootLoader = [MacOSVirtualMachineConfigurationHelper createBootLoader];
configuration.graphicsDevices = @[ [MacOSVirtualMachineConfigurationHelper createGraphicsDeviceConfiguration] ];
configuration.storageDevices = @[ [MacOSVirtualMachineConfigurationHelper createBlockDeviceConfiguration] ];
configuration.networkDevices = @[ [MacOSVirtualMachineConfigurationHelper createNetworkDeviceConfiguration] ];
configuration.pointingDevices = @[ [MacOSVirtualMachineConfigurationHelper createPointingDeviceConfiguration] ];
configuration.keyboards = @[ [MacOSVirtualMachineConfigurationHelper createKeyboardConfiguration] ];
configuration.audioDevices = @[ [MacOSVirtualMachineConfigurationHelper createAudioDeviceConfiguration] ];
assert([configuration validateWithError:nil]);

self->_virtualMachine = [[VZVirtualMachine alloc] initWithConfiguration:configuration];
self->_delegate = [MacOSVirtualMachineDelegate new];
self->_virtualMachine.delegate = self->_delegate;
```

Running this tool with the path to an `ipsw` file, it tries to directly install macOS from the `ipsw` file on disk: 

``` swift
DispatchQueue.main.async { [self] in
    let installer = VZMacOSInstaller(virtualMachine: virtualMachine, restoringFromImageAt: restoreImageURL)

    NSLog("Starting installation.")
    installer.install(completionHandler: { (result: Result<Void, Error>) in
        if case let .failure(error) = result {
            fatalError(error.localizedDescription)
        } else {
            NSLog("Installation succeeded.")
        }
    })

    // Observe installation progress
    installationObserver = installer.progress.observe(\.fractionCompleted, options: [.initial, .new]) { (progress, change) in
        NSLog("Installation progress: \(change.newValue! * 100).")
    }
}
```

The equivalent Objective-C version is:

``` objective-c
dispatch_async(dispatch_get_main_queue(), ^{
    VZMacOSInstaller *installer = [[VZMacOSInstaller alloc] initWithVirtualMachine:self->_virtualMachine restoreImageURL:restoreImageFileURL];

    NSLog(@"Starting installation.");
    [installer installWithCompletionHandler:^(NSError *error) {
        if (error) {
            abortWithErrorMessage([NSString stringWithFormat:@"%@", error.localizedDescription]);
        } else {
            NSLog(@"Installation succeeded.");
        }
    }];

    [installer.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
});
```

InstallationTool creates a `VM.bundle` package in the user’s home directory upon a successful installation, it contains:

* `Disk.img` - The main disk image of the installed OS.
* `AuxiliaryStorage` - The auxiliary storage for macOS.
* `MachineIdentifier` - The data representation of the `VZMacMachineIdentifier` object.
* `HardwareModel` - The data representation of the `VZMacHardwareModel` object.
* `RestoreImage.ipsw` - The restore image downloaded from the network (this file exists only if the tool runs without arguments).

To reinstall the virtual machine, delete the `VM.bundle` package and run InstallationTool again.

macOSVirtualMachineSampleApp is a GUI application that runs the macOS VM installed by the InstallationTool. The virtual machine must be already installed and `VM.bundle` must exist before launching this app. 


## Configuration of the macOSVirtualMachineSampleApp Virtual Machine

macOSVirtualMachineSampleApp uses a [`VZVirtualMachineConfiguration`][class_VZVirtualMachineConfiguration] object to configure the basic characteristics of the guest, such as the CPU count, memory size, various device configurations, and a [`VZMacOSBootLoader`][class_VZMacOSBootLoader] object to load operating system from the disk image as shown in the following example: 

``` swift
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
```

The Objective-C equivalent is: 

``` objective-c
VZVirtualMachineConfiguration *configuration = [VZVirtualMachineConfiguration new];

configuration.platform = [self createMacPlatformConfiguration];
configuration.CPUCount = [MacOSVirtualMachineConfigurationHelper computeCPUCount];
configuration.memorySize = [MacOSVirtualMachineConfigurationHelper computeMemorySize];
configuration.bootLoader = [MacOSVirtualMachineConfigurationHelper createBootLoader];
configuration.graphicsDevices = @[ [MacOSVirtualMachineConfigurationHelper createGraphicsDeviceConfiguration] ];
configuration.storageDevices = @[ [MacOSVirtualMachineConfigurationHelper createBlockDeviceConfiguration] ];
configuration.networkDevices = @[ [MacOSVirtualMachineConfigurationHelper createNetworkDeviceConfiguration] ];
configuration.pointingDevices = @[ [MacOSVirtualMachineConfigurationHelper createPointingDeviceConfiguration] ];
configuration.keyboards = @[ [MacOSVirtualMachineConfigurationHelper createKeyboardConfiguration] ];
configuration.audioDevices = @[ [MacOSVirtualMachineConfigurationHelper createAudioDeviceConfiguration] ];
assert([configuration validateWithError:nil]);

_virtualMachine = [[VZVirtualMachine alloc] initWithConfiguration:configuration];
```

Inside the general `VMconfiguration` method, the app also creates a platform configuration for the virtual machine: [`VZMacPlatformConfiguration`][class_VZMacPlatformConfiguration] configures important macOS specific data the macOS guest needs to run, including the specific [`hardwareModel`][property_hardwareModel] that the image supports, as well as a [`machineIdentifier`][property_machineIdentifier] that uniquely identifies the current virtual machine instance and differentiates it from any others the user creates:

``` swift
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
```

The equivalent functionality in Objective-C is: 

``` objective-c
VZMacPlatformConfiguration *macPlatformConfiguration = [[VZMacPlatformConfiguration alloc] init];
VZMacAuxiliaryStorage *auxiliaryStorage = [[VZMacAuxiliaryStorage alloc] initWithContentsOfURL:getAuxiliaryStorageURL()];
macPlatformConfiguration.auxiliaryStorage = auxiliaryStorage;

if (![[NSFileManager defaultManager] fileExistsAtPath:getVMBundlePath()]) {
    abortWithErrorMessage([NSString stringWithFormat:@"Missing Virtual Machine Bundle at %@. Run InstallationTool first to create it.", getVMBundlePath()]);
}

// Retrieve the hardware model; you should save this value to disk during installation.
NSData *hardwareModelData = [[NSData alloc] initWithContentsOfURL:getHardwareModelURL()];
if (!hardwareModelData) {
    abortWithErrorMessage(@"Failed to retrieve hardware model data.");
}

VZMacHardwareModel *hardwareModel = [[VZMacHardwareModel alloc] initWithDataRepresentation:hardwareModelData];
if (!hardwareModel) {
    abortWithErrorMessage(@"Failed to create hardware model.");
}

if (!hardwareModel.supported) {
    abortWithErrorMessage(@"The hardware model is not supported on the current host");
}
macPlatformConfiguration.hardwareModel = hardwareModel;

// Retrieve the machine identifier; you should save this value to disk during installation.
NSData *machineIdentifierData = [[NSData alloc] initWithContentsOfURL:getMachineIdentifierURL()];
if (!machineIdentifierData) {
    abortWithErrorMessage(@"Failed to retrieve machine identifier data.");
}

VZMacMachineIdentifier *machineIdentifier = [[VZMacMachineIdentifier alloc] initWithDataRepresentation:machineIdentifierData];
if (!machineIdentifier) {
    abortWithErrorMessage(@"Failed to create machine identifier.");
}
macPlatformConfiguration.machineIdentifier = machineIdentifier;
```

## Instantiate and Start the Virtual Machine

After building the configuration data for the virtual machine, macOSVirtualMachineSampleApp uses the [`VZVirtualMachine`][class_VZVirtualMachine] object to start the execution of the macOS guest operating system.

Before calling the virtual machine's [`start`][method_start] method, the macOSVirtualMachineSampleApp configures a delegate object to receive messages about the state of the virtual machine. When the macOS guest operating system shuts down, the virtual machine calls the delegate's [`guestDidStop`][method_guestDidStop] method. In response, the delegate method prints a message and exits the app. If the macOS guest stops for any reason other than a normal shutdown, the delegate prints an error message and the app exits:

``` swift
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
```

The equivalent functionality in Objective-C is: 

``` objective-c
[self createVirtualMachine];

_delegate = [MacOSVirtualMachineDelegate new];
_virtualMachine.delegate = _delegate;
_virtualMachineView.virtualMachine = _virtualMachine;

dispatch_async(dispatch_get_main_queue(), ^{
    [self->_virtualMachine startWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            abortWithErrorMessage(error.localizedDescription);
        }
    }];
});
```

The [`start`][method_start] method starts the virtual machine asynchronously in the background. The virtual machine loads system image and boots macOS. After macOS finishes booting, the user interacts with a [`VZVirtualMachineView`][class_VZVirtualMachineView] window that displays the macOS UI and handles keyboard and mouse input through a [`VZMacGraphicsDeviceConfiguration`][class_VZMacGraphicsDeviceConfiguration] as though the user is interacting directly with the hardware on a stand-alone machine.
