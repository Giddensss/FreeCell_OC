//
//  Game.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "Game.h"
#import "Deck.h"

@interface Game (){
    NSMutableArray <NSMutableArray <Card *>*> *gameboard;
    Deck *deck;
    NSMutableArray *lastRow;
    NSMutableArray <Card *>*freeCells;
}
@end
@implementation Game
- (id) init {
    self = [super init];
    if (self) {
        gameboard = [NSMutableArray array];
        deck = [[Deck alloc] initDeck];
        lastRow = [NSMutableArray array];
        freeCells = [NSMutableArray array];
    }
    return self;
}

- (void) setupGame {
    [deck shuffle];
    for (int i = 0; i < deckLength; i ++) {
        if (i < number_of_column) {
            NSMutableArray <Card *>*column = [NSMutableArray array];
            [gameboard addObject:column];
            [lastRow addObject:[Card alloc]];
        }
        if (i < number_of_free_cells) {
            [freeCells addObject:[Card alloc]];
        }
        Card *card = [deck dealCard];
        if (i > deckLength - number_of_column - 1) {
            lastRow[i % number_of_column] = card;
        }
        [gameboard[i % number_of_column] addObject:card];
    }
#if DEBUG_PRINT
    NSLog(@"Here is the game board:\n%@",[self getPrintableGameBoard]);
    NSLog(@"Here is the cards in last row:\n%@",[self getPrintableCardInLastRow]);
#endif
    
}

- (NSArray <NSArray <Card *> *>*) getBoard {
    return gameboard;
}

- (NSString *) getPrintableGameBoard {
    NSMutableString *toReturn = [NSMutableString string];
    int row = 0;
    for (int i = 0; i < deckLength; i ++) {
        NSString *card = [gameboard[i % number_of_column][row] getPrintableCardString];
        int padding = longest_card_name - (int)card.length;
        [toReturn appendFormat:@"%@%@ |",card,[self getRightPadding:padding]];
        if (i % number_of_column == number_of_column - 1) {
            row ++;
            [toReturn appendString:@"\n"];
        }
    }
    return toReturn;
}

- (NSString *) getRightPadding:(int) paddingLength {
    NSMutableString *string = [NSMutableString string];
    for (int i =0 ; i < paddingLength; i++) {
        [string appendString:@" "];
    }
    return string;
}

- (NSString *) getPrintableCardInLastRow {
    NSMutableString *string = [NSMutableString string];
    for (Card * c in lastRow) {
        NSString *card = [c getPrintableCardString];
        int padding = longest_card_name - (int) card.length;
        [string appendFormat:@"%@%@ |",card,[self getRightPadding:padding]];
    }
    return string;
}

@end
