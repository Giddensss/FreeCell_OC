//
//  EmptyCardView.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/23.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "EmptyCardView.h"
#import "../supports/const.h"
@interface EmptyCardView () {
    CGFloat viewWidth;
    CGFloat viewHeight;
    NSImageView *bg;
}
@end
@implementation EmptyCardView
- (void) viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    viewWidth = self.frame.size.width;
    viewHeight = self.frame.size.height;
    bg = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [bg setImageScaling:NSImageScaleAxesIndependently];
    [bg setImage:[NSImage imageNamed:@"cardCell"]];
    [self addSubview:bg];
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
}

- (void) mouseUp:(NSEvent *)event {
    [_clickListener onViewClicked:_column sender:self];
}

@end
