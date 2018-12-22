//
//  Game.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "Game.h"
#import "Deck.h"
#import "Card.h"
@interface Game (){
    NSMutableArray <NSMutableArray <Card *>*> *gameboard;
    Deck *deck;
    
    
}
@end
@implementation Game
- (id) init {
    self = [super init];
    if (self) {
        gameboard = [NSMutableArray array];
        deck = [[Deck alloc] initDeck];
    }
    return self;
}

- (void) setupGame {
    
}

@end
