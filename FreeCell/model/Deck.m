//
//  Deck.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "Deck.h"
@interface Deck() {
    NSMutableArray <Card *> *deck;
    BOOL isShuffle;
}
@end
@implementation Deck

- (id) initDeck {
    self = [super init];
    if (self) {
        deck = [NSMutableArray array];
        for (int i = 0; i < 4; i ++ ) {
            for (int j = 0; j < 13; j ++) {
                [deck addObject:[[Card alloc] initCardWithValue:j+1 suit:i]];
            }
        }
        isShuffle = NO;
    }
    return self;
}

- (void) shuffle {
    isShuffle = YES;
}

- (Card *) dealCard {
    int index = 0;
    if (isShuffle) {
        index = [self getRandomNumberBetween:0 to:(int)deck.count - 1];
    }
    Card *deltCard = deck[index];
    [deck removeObjectAtIndex:index];
    return deltCard;
}

- (void) resetDeck {
    deck = [NSMutableArray array];
    for (int i = 0; i < 4; i ++ ) {
        for (int j = 0; j < 13; j ++) {
            [deck addObject:[[Card alloc] initCardWithValue:j+1 suit:i]];
        }
    }
    isShuffle = NO;
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)(from + arc4random() % (to-from+1));
}

@end
