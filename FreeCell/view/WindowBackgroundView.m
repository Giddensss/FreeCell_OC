//
//  WindowBackgroundView.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "WindowBackgroundView.h"
#import "../supports/const.h"
@interface WindowBackgroundView () {
    NSTrackingArea *trackingArea;
    CGFloat viewWidth;
    CGFloat viewHeight;
    enum mouseInWindow mousePositionInWindow;
}
@end
@implementation WindowBackgroundView

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        trackingArea = [[NSTrackingArea alloc] initWithRect:[self frame]
                                                   options:(NSTrackingMouseMoved|NSTrackingActiveInKeyWindow)
                                                     owner:self
                                                   userInfo:nil];
        [self addTrackingArea:trackingArea];
        [self becomeFirstResponder];
    }
    return self;
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    viewWidth = self.frame.size.width;
    viewHeight = self.frame.size.height;
    mousePositionInWindow = mouseOnLeft;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
   
    //
    // Drawing code here.
}


- (void)mouseMoved:(NSEvent *)event {
    CGPoint mousePoint = [event locationInWindow];
    if (mousePoint.x < viewWidth / 2) {
        if (mousePositionInWindow != mouseOnLeft) {
            mousePositionInWindow = mouseOnLeft;
            [_listener onMouseInWindowPositionChanged:mousePositionInWindow];
#if DEBUG_VIEW
            NSLog(@"Mouse moving to LEFT");
#endif
        }
    } else {
        if (mousePositionInWindow != mouseOnRight) {
            mousePositionInWindow = mouseOnRight;
            [_listener onMouseInWindowPositionChanged:mousePositionInWindow];
#if DEBUG_VIEW
            NSLog(@"Mouse moving to RIGHT");
#endif
        }
    }
}

@end
