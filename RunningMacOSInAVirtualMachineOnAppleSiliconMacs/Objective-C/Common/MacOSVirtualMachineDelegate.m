/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A class that conforms to `VZVirtualMachineDelegate` and to track the virtual machine's state.
*/

#import "MacOSVirtualMachineDelegate.h"

#import <AppKit/AppKit.h>

@implementation MacOSVirtualMachineDelegate

- (void)virtualMachine:(VZVirtualMachine *)virtualMachine didStopWithError:(NSError *)error
{
    NSLog(@"Virtual Machine did stop with error. %@", error.localizedDescription);
    exit(-1);
}

- (void)guestDidStopVirtualMachine:(VZVirtualMachine *)virtualMachine
{
    NSLog(@"Guest did stop virtual machine.");
    exit(0);
}

@end
