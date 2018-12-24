//
//  Card.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../supports/const.h"
NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject

- (id) initEmptyCard;

- (id) initCardWithValue:(int) value suit:(enum CardSuit) suit;

- (int) getValue;

- (enum CardSuit) getSuit;

- (enum CardColor) getCardColor;

- (NSString *) getPrintableCardString;

- (BOOL) isEmptyCard;

@end

NS_ASSUME_NONNULL_END
