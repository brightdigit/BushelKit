/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helper that creates various configuration objects exposed in the `VZVirtualMachineConfiguration`.
*/

#ifndef MacOSVirtualMachineConfigurationHelper_h
#define MacOSVirtualMachineConfigurationHelper_h

#import <Virtualization/Virtualization.h>

#ifdef __arm64__

@interface MacOSVirtualMachineConfigurationHelper : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (NSUInteger)computeCPUCount;

+ (uint64_t)computeMemorySize;

+ (VZMacOSBootLoader *)createBootLoader;

+ (VZMacGraphicsDeviceConfiguration *)createGraphicsDeviceConfiguration;

+ (VZVirtioBlockDeviceConfiguration *)createBlockDeviceConfiguration;

+ (VZVirtioNetworkDeviceConfiguration *)createNetworkDeviceConfiguration;

+ (VZUSBScreenCoordinatePointingDeviceConfiguration *)createPointingDeviceConfiguration;

+ (VZUSBKeyboardConfiguration *)createKeyboardConfiguration;

+ (VZVirtioSoundDeviceConfiguration *)createAudioDeviceConfiguration;

@end

#endif /* __arm64__ */
#endif /* MacOSVirtualMachineConfigurationHelper_h */
