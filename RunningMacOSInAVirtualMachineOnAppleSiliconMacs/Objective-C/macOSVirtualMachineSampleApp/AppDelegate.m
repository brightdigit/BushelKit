/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application delegate that sets up and starts the virtual machine.
*/

#import "AppDelegate.h"

#import "Error.h"
#import "MacOSVirtualMachineConfigurationHelper.h"
#import "MacOSVirtualMachineDelegate.h"
#import "Path.h"

#import <Virtualization/Virtualization.h>

@interface AppDelegate ()

@property (weak) IBOutlet VZVirtualMachineView *virtualMachineView;

@property (strong) IBOutlet NSWindow *window;

@end

@implementation AppDelegate {
    VZVirtualMachine *_virtualMachine;
    MacOSVirtualMachineDelegate *_delegate;
}

#ifdef __arm64__

// MARK: Create the Mac Platform Configuration

- (VZMacPlatformConfiguration *)createMacPlatformConfiguration
{
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

    return macPlatformConfiguration;
}

// MARK: Create the Virtual Machine Configuration and instantiate the Virtual Machine

- (void)createVirtualMachine
{
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
}

#endif

// MARK: Start the Virtual Machine

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
#ifdef __arm64__
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
#endif
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
