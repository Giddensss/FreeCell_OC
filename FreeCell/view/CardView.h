//
//  CardView.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../supports/const.h"
NS_ASSUME_NONNULL_BEGIN

@interface CardView : NSView
@property int columnInBoard;
@property int rowInBoard;
- (void) setCardViewWithValue:(int) value suit:(enum CardSuit) suit title:(NSString *) title;

@end

NS_ASSUME_NONNULL_END
