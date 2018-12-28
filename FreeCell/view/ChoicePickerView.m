//
//  ChoicePickerView.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/28.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "ChoicePickerView.h"

@implementation ChoicePickerView

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect = [self bounds];
    NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:15 yRadius:15];
    [path addClip];
    
    [[NSColor darkGrayColor] set];
    NSRectFill(dirtyRect);

    [super drawRect:dirtyRect];
   
    
    // Drawing code here.
}

@end
