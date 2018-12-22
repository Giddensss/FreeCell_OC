//
//  WindowBackgroundView.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
NS_ASSUME_NONNULL_BEGIN
enum mouseInWindow{
    mouseOnLeft,
    mouseOnRight
};
@protocol MouseDirectionListener <NSObject>

- (void) onMouseInWindowPositionChanged:(enum mouseInWindow) position;

@end
@interface WindowBackgroundView : NSView
@property id<MouseDirectionListener> listener;

@end

NS_ASSUME_NONNULL_END
