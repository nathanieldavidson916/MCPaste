//
//  AppDelegate.m
//  MCPasteUI
//
//  Created by Nathan Davidson on 4/21/24.
//

#import "AppDelegate.h"
#import "MCPaste.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.button.title = @"🛠️";
    
    // default to starting the event listener
    [self startMiddleMouseEventListener];

    self.menu = [[NSMenu alloc] init];
    [self.menu addItemWithTitle:@"Start" action:@selector(startMiddleMouseEventListener) keyEquivalent:@""];
    [self.menu addItemWithTitle:@"Stop" action:@selector(stopMiddleMouseEventListener) keyEquivalent:@""];
    [self.menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];

    self.statusItem.menu = self.menu;
}

- (void) checkStatus {
    if (setupEventListener())
    {
        [self.pollingTimer invalidate];
        self.pollingTimer = nil;
        return;
    }
    NSLog(@"application does not have appropriate access levels, checking again in %d second(s)", TIME_DELAY_SEC);
}

-(void) startMiddleMouseEventListener {
    // check for accessibility access and prompt if access is not granted yet
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
    
    self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_DELAY_SEC
                                                         target:self
                                                       selector:@selector(checkStatus)
                                                       userInfo:nil
                                                        repeats:YES];
}

-(void) stopMiddleMouseEventListener {
    disableEventListener();
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
