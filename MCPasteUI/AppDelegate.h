//
//  AppDelegate.h
//  MCPasteUI
//
//  Created by Nathan Davidson on 4/21/24.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
    @property (strong, nonatomic) NSStatusItem *statusItem;
    @property (strong, nonatomic) NSMenu *menu;
    @property (strong, nonatomic) NSTimer *pollingTimer;
@end

