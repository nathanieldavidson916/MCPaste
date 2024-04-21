//
//  main.m
//  MCPaste
//
//  Created by Nathan Davidson on 4/20/24.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "MCPaste.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // check for accessibility access and prompt if access is not granted yet
        NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
        AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
        
        // poll setup for event permissions until access is granted
        while(!setupEventListener())
        {
            NSLog(@"application does not have access to event taps, checking for permissions in %d second(s)", TIME_DELAY_SEC);
            sleep(TIME_DELAY_SEC);
        }
        
        NSLog(@"application is running");

        CFRunLoopRun();
    }
    return 0;
}
