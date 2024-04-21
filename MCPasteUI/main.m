//
//  main.m
//  MCPasteUI
//
//  Created by Nathan Davidson on 4/21/24.
//

#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>

void addToLoginItems() {
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];

    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems) {
        LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
        if (item) {
            CFRelease(item);
        }
        CFRelease(loginItems);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        addToLoginItems();
    }
    return NSApplicationMain(argc, argv);
}
