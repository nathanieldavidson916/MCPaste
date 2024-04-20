//
//  main.m
//  MCPaste
//
//  Created by Nathan Davidson on 4/20/24.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#define MIDDLE_MOUSE 2
#define TIME_DELAY_SEC 3

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if (type == kCGEventOtherMouseDown) {
        int64_t clickCount = CGEventGetIntegerValueField(event, kCGMouseEventClickState);
        int64_t buttonNumber = CGEventGetIntegerValueField(event, kCGMouseEventButtonNumber);
        if (buttonNumber == MIDDLE_MOUSE) { // Middle mouse button
            NSLog(@"Middle mouse button clicked %lld times.", clickCount);
            NSString *appleScriptCommand = @"tell application \"System Events\" to keystroke \"v\" using command down";
            NSAppleScript *script = [[NSAppleScript alloc] initWithSource:appleScriptCommand];
            NSDictionary *errorDict;
            [script executeAndReturnError:&errorDict];
            if (errorDict) {
                NSLog(@"Error: %@", errorDict);
                NSLog(@"Please enable automation permissions for this app in System Preferences > Security & Privacy > Privacy > Automation.");
            }
        }
    }
    return event;
}

BOOL setupEventListener(void) {
    CGEventMask eventMask = CGEventMaskBit(kCGEventOtherMouseDown);
    CFMachPortRef eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, eventMask, myCGEventCallback, NULL);
    if (eventTap)
    {
        CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
        CGEventTapEnable(eventTap, true);
        return YES;
    }
    return NO;
}

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
        
        NSLog(@"application has access");

        CFRunLoopRun();
    }
    return 0;
}
