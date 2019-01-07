//
//  MainMenu.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2019/1/7.
//  Copyright © 2019 Alan L  Hamilton. All rights reserved.
//

#import "MainMenu.h"
#import "../supports/AppDelegate.h"
#import "../supports/const.h"
@interface MainMenu() {
    AppDelegate *myDelegate;
}
@end
@implementation MainMenu
- (id) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder: decoder];
    if (self) {
        myDelegate = [NSApplication sharedApplication].delegate;
    }
    return self;
}
- (IBAction)newGameMenuClicked:(NSMenuItem *)sender {
#if DEBUG_PRINT
    NSLog(@"New game menu clicked!");
#endif
    [myDelegate.myGame resetGame];    
}
- (IBAction)autoFinishMenuClicked:(NSMenuItem *)sender {
#if DEBUG_PRINT
    NSLog(@"Auto Finish menu clicked!");
#endif
    [myDelegate.myGame autoFinish];
}

@end
