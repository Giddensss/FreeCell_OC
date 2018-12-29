//
//  CardView.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "CardView.h"

@interface CardView() {
    NSImageView *background;
    CGFloat viewWidth;
    CGFloat viewHeight;
    NSString *bgImage;
    NSString *hightLightImage;
#if DEBUG_VIEW
    NSTextView *label;
    NSString *title;
#endif
}
@end
@implementation CardView

- (void) viewDidMoveToWindow{
    [super viewDidMoveToWindow];
    viewWidth = self.frame.size.width;
    viewHeight = self.frame.size.height;
    background = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [background setImageScaling:NSImageScaleAxesIndependently];
    [background setImage:[NSImage imageNamed: bgImage]];
    [self addSubview:background];
#if DEBUG_VIEW
    label = [[NSTextView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 10)];
    [label setEditable:NO];
    [label setSelectable:NO];
    [label setBackgroundColor:[NSColor whiteColor]];
    [label setFont:[NSFont systemFontOfSize:12.0f]];
    [label setTextColor:[NSColor blackColor]];
    label.string = title;
    [self addSubview:label];
    NSLog(@"title: %@ row: %d column: %d",title,_rowInBoard,_columnInBoard);
#endif
}

- (void) setCardViewWithValue:(int)value suit:(enum CardSuit)suit title:(NSString *)title{
    bgImage = [NSString stringWithFormat:@"card_%d_%d",value,suit];
    hightLightImage = [NSString stringWithFormat:@"card_%d_%d_highlight",value,suit];
    
#if DEBUG_VIEW
    self->title = title;
#endif
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
#if DEBUG_VIEW
    [[NSColor lightGrayColor] set];
#else
    [[NSColor clearColor] set];
#endif
    NSRectFill(dirtyRect);
    
    // Drawing code here.
}

- (void) selectCard {
    [background setImage:[NSImage imageNamed:hightLightImage]];
}

- (void) deselectCard {
    [background setImage:[NSImage imageNamed:bgImage]];
}

- (void) mouseUp:(NSEvent *)event {
    [_cardListener onCardViewClicked:CGPointMake(_columnInBoard, _rowInBoard)];
}

- (void) rightMouseDown:(NSEvent *)event {
    [_cardListener onCardViewMouseRightUp:CGPointMake(_columnInBoard, _rowInBoard)];
}

- (void) rightMouseUp:(NSEvent *)event {
    [_cardListener onCardViewMouseRightDown:CGPointMake(_columnInBoard, _rowInBoard)];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)(from + arc4random() % (to-from+1));
}
@end

