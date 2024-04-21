//
//  MCPaste.h
//  MCPaste
//
//  Created by Nathan Davidson on 4/21/24.
//

#ifndef MCPaste_h
#define MCPaste_h

#define MIDDLE_MOUSE 2
#define TIME_DELAY_SEC 3

static CFMachPortRef eventTap = NULL;
static CFRunLoopSourceRef runLoopSource = NULL;

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if (type == kCGEventOtherMouseDown) {
        int64_t buttonNumber = CGEventGetIntegerValueField(event, kCGMouseEventButtonNumber);
        if (buttonNumber == MIDDLE_MOUSE) { // Middle mouse button
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
    eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, eventMask, myCGEventCallback, NULL);
    if (eventTap)
    {
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
        CGEventTapEnable(eventTap, true);
        return YES;
    }
    return NO;
}

void disableEventListener(void) {
    if (eventTap) {
        CGEventTapEnable(eventTap, false);
        // Optionally remove the run loop source if you do not plan to re-enable the tap
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    }
}

#endif /* MCPaste_h */
