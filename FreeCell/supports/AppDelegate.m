//
//  AppDelegate.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/10/16.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    
}
@end

@implementation AppDelegate
-(id) init {
    self = [super init];
    if (self) {
        _myGame = [[Game alloc] init];
        [_myGame setupGame];
    }
    return self;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


@end
