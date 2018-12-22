//
//  Card.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "Card.h"

@interface Card() {
    enum CardColor color;
    enum CardSuit suit;
    int value;
}
@end
@implementation Card

- (id) initCardWithValue:(int)value suit:(enum CardSuit)suit {
    self = [super init];
    if (self) {
        self->value = value;
        self->suit = suit;
        if (self->suit == suitHeart || self->suit == suitDiomand) {
            self->color = cardColorRed;
        } else {
            self->color = cardColorBlack;
        }
    }
    return self;
}

- (int) getValue {
    return value;
}

- (enum CardColor) getCardColor {
    return color;
}

- (enum CardSuit) getSuit {
    return suit;
}

- (NSString *) getPrintableCardString {
    
    if (value > 1 && value < 11) {
        return [NSString stringWithFormat:@"%d of %@",value,[self getPrintableSuit]];
    } else {
        if (value == 1) {
             return [NSString stringWithFormat:@"Ace of %@",[self getPrintableSuit]];
        } else if (value == 11) {
             return [NSString stringWithFormat:@"Jack of %@",[self getPrintableSuit]];
        } else if (value == 12) {
             return [NSString stringWithFormat:@"Queen of %@",[self getPrintableSuit]];
        } else if (value == 13) {
            return [NSString stringWithFormat:@"King of %@",[self getPrintableSuit]];
        }
    }
    return nil;
}

- (NSString *) getPrintableSuit {
    switch (suit) {
        case suitDiomand :
            return @"Diamonds";
        case suitHeart:
            return @"Hearts";
        case suitClub:
            return @"Clues";
        case suitSpade:
            return @"Spades";
    }
}
@end
