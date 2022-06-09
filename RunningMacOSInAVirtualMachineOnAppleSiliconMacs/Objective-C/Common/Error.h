/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helper function that displays error and aborts the program.
*/

#import <Foundation/Foundation.h>

static inline void abortWithErrorMessage(NSString *errorMessage)
{
    NSLog(@"%@", errorMessage);
    abort();
}
