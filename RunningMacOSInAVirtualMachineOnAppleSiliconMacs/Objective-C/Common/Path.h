/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helper functions that retrieves the various file URLs that are used by this sample code.
*/

#ifndef Path_h
#define Path_h

#import <Foundation/Foundation.h>

static inline NSString *getVMBundlePath()
{
    return [NSString stringWithFormat:@"%@%@", NSHomeDirectory(), @"/VM.bundle/"];
}

static inline NSURL *getVMBundleURL()
{
    return [[NSURL alloc] initFileURLWithPath:getVMBundlePath()];
}

static inline NSURL *getAuxiliaryStorageURL()
{
    return [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@%@", getVMBundlePath(), @"AuxiliaryStorage"]];
}

static inline NSURL *getDiskImageURL()
{
    return [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@%@", getVMBundlePath(), @"Disk.img"]];
}

static inline NSURL *getHardwareModelURL()
{
    return [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@%@", getVMBundlePath(), @"HardwareModel"]];
}

static inline NSURL *getMachineIdentifierURL()
{
    return [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@%@", getVMBundlePath(), @"MachineIdentifier"]];
}

static inline NSURL *getRestoreImageURL()
{
    return [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@%@", getVMBundlePath(), @"RestoreImage.ipsw"]];
}

#endif /* Path_h */
