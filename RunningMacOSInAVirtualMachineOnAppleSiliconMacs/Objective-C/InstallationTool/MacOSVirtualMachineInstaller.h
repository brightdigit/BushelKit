/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helper class to install a macOS virtual machine.
*/

#ifndef MacOSVirtualMachineInstaller_h
#define MacOSVirtualMachineInstaller_h

#import <Foundation/Foundation.h>

#ifdef __arm64__

@interface MacOSVirtualMachineInstaller : NSObject

- (void)setUpVirtualMachineArtifacts;

- (void)installMacOS:(NSURL *)ipswURL;

@end

#endif /* __arm64__ */
#endif /* MacOSVirtualMachineInstaller_h */
