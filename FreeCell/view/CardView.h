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
@protocol CardViewClickListener <NSObject>

/*
 * The left click listener
 * @param cardPosition: The (column,row) coordinate of the card
 */
- (void) onCardViewClicked:(CGPoint) cardPosition;

/*
 * The mouse right key down listener
 * @param cardPosition: The (column,row) coordinate of the card
 */
- (void) onCardViewMouseRightDown:(CGPoint) cardPosition;

/*
 * The mouse right key up listener
 * @param cardPosition: The (column,row) coordinate of the card
 */
- (void) onCardViewMouseRightUp:(CGPoint) cardPosition;

@end
@interface CardView : NSView
@property int columnInBoard;
@property int rowInBoard;
@property id<CardViewClickListener> cardListener;
- (void) setCardViewWithValue:(int) value suit:(enum CardSuit) suit title:(NSString *) title;

@end

NS_ASSUME_NONNULL_END
