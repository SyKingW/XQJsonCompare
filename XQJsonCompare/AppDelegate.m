//
//  AppDelegate.m
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/19.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    NSLog(@"%s", __func__);
    // 表示当前是没有window的
    if (!flag) {
        // 获取其中的window, 设到最前
        [sender.windows.firstObject makeKeyAndOrderFront:nil];
    }
    return YES;
}

@end
