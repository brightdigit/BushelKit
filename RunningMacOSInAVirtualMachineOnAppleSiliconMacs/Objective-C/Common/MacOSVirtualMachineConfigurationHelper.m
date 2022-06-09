/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helper that creates various configuration objects exposed in the `VZVirtualMachineConfiguration`.
*/

#import "MacOSVirtualMachineConfigurationHelper.h"

#import "Error.h"
#import "Path.h"

#ifdef __arm64__

@implementation MacOSVirtualMachineConfigurationHelper

+ (NSUInteger)computeCPUCount
{
    NSUInteger totalAvailableCPUs = [[NSProcessInfo processInfo] processorCount];
    NSUInteger virtualCPUCount = totalAvailableCPUs <= 1 ? 1 : totalAvailableCPUs - 1;
    virtualCPUCount = MAX(virtualCPUCount, VZVirtualMachineConfiguration.minimumAllowedCPUCount);
    virtualCPUCount = MIN(virtualCPUCount, VZVirtualMachineConfiguration.maximumAllowedCPUCount);

    return virtualCPUCount;
}

+ (uint64_t)computeMemorySize
{
    // We arbitrarily choose 4GB.
    uint64_t memorySize = 4ull * 1024ull * 1024ull * 1024ull;
    memorySize = MAX(memorySize, VZVirtualMachineConfiguration.minimumAllowedMemorySize);
    memorySize = MIN(memorySize, VZVirtualMachineConfiguration.maximumAllowedMemorySize);

    return memorySize;
}

+ (VZMacOSBootLoader *)createBootLoader
{
    return [[VZMacOSBootLoader alloc] init];
}

+ (VZMacGraphicsDeviceConfiguration *)createGraphicsDeviceConfiguration
{
    VZMacGraphicsDeviceConfiguration *graphicsConfiguration = [[VZMacGraphicsDeviceConfiguration alloc] init];
    graphicsConfiguration.displays = @[
        // We abitrarily choose the resolution of the display to be 1920 x 1200.
        [[VZMacGraphicsDisplayConfiguration alloc] initWithWidthInPixels:1920 heightInPixels:1200 pixelsPerInch:80],
    ];

    return graphicsConfiguration;
}

+ (VZVirtioBlockDeviceConfiguration *)createBlockDeviceConfiguration
{
    NSError *error;
    VZDiskImageStorageDeviceAttachment *diskAttachment = [[VZDiskImageStorageDeviceAttachment alloc] initWithURL:getDiskImageURL() readOnly:NO error:&error];
    if (!diskAttachment) {
        abortWithErrorMessage([NSString stringWithFormat:@"Failed to create VZDiskImageStorageDeviceAttachment. %@", error.localizedDescription]);
    }
    VZVirtioBlockDeviceConfiguration *disk = [[VZVirtioBlockDeviceConfiguration alloc] initWithAttachment:diskAttachment];

    return disk;
}

+ (VZVirtioNetworkDeviceConfiguration *)createNetworkDeviceConfiguration
{
    VZNATNetworkDeviceAttachment *natAttachment = [[VZNATNetworkDeviceAttachment alloc] init];
    VZVirtioNetworkDeviceConfiguration *networkConfiguration = [[VZVirtioNetworkDeviceConfiguration alloc] init];
    networkConfiguration.attachment = natAttachment;

    return networkConfiguration;
}

+ (VZUSBScreenCoordinatePointingDeviceConfiguration *)createPointingDeviceConfiguration
{
    return [[VZUSBScreenCoordinatePointingDeviceConfiguration alloc] init];
}

+ (VZUSBKeyboardConfiguration *)createKeyboardConfiguration
{
    return [[VZUSBKeyboardConfiguration alloc] init];
}

+ (VZVirtioSoundDeviceConfiguration *)createAudioDeviceConfiguration
{
    VZVirtioSoundDeviceConfiguration *audioDeviceConfiguration = [[VZVirtioSoundDeviceConfiguration alloc] init];

    VZVirtioSoundDeviceInputStreamConfiguration *inputStream = [[VZVirtioSoundDeviceInputStreamConfiguration alloc] init];
    inputStream.source = [[VZHostAudioInputStreamSource alloc] init];

    VZVirtioSoundDeviceOutputStreamConfiguration *outputStream = [[VZVirtioSoundDeviceOutputStreamConfiguration alloc] init];
    outputStream.sink = [[VZHostAudioOutputStreamSink alloc] init];

    audioDeviceConfiguration.streams = @[ inputStream, outputStream ];

    return audioDeviceConfiguration;
}

@end

#endif
