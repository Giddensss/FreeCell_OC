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
    Card *selectedCard;
    NSMutableArray <Card *> *selectedCards;
    NSMutableArray <Card *> *decks;
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
        decks = [NSMutableArray array];
    }
    return self;
}

- (void) setupGame {
    [deck shuffle];
    for (int i = 0; i < deckLength; i ++) {
        if (i < number_of_column) {
            NSMutableArray <Card *>*column = [NSMutableArray array];
            [gameboard addObject:column];
            [lastRow addObject:[[Card alloc] initEmptyCard]];
        }
        if (i < number_of_free_cells) {
            [freeCells addObject:[[Card alloc] initEmptyCard]];
            [decks addObject:[[Card alloc] initEmptyCard]];
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


- (BOOL) moveCardToTempCellAtColumn:(int)column toTempCellIndex:(int)index{
    if (![freeCells[index] isEmptyCard]) {
        [_myUIListener onIllegalMove];
        return NO;
    }
    Card *card = [gameboard[column] lastObject];
    [gameboard[column] removeLastObject];
    lastRow[column] = [gameboard[column] lastObject] ? [gameboard[column] lastObject] : [[Card alloc] initEmptyCard];
    freeCells[index] = card;
    [_myUIListener onCardMoveFromColumn:column toFreeCell:index card:[self getSelectedCard]];
#if DEBUG_PRINT
    NSLog(@"Here is the cards in last row:\n%@",[self getPrintableCardInLastRow]);
#endif
    [self autoFinish:NO];
    return YES;
}

- (int) moveCardFromTempCellToGameBoardColumn:(int)column {
    if ([selectedCard isEmptyCard]) {
        return 1;
    }
    Card *lastCard = [gameboard[column] lastObject];
    if ([self checkLegalMoveWithLastCardOfTheColumn:lastCard cardToBePlaced:selectedCard]) {
        [gameboard[column] addObject:selectedCard];
        lastRow[column] = selectedCard;
        freeCells[[freeCells indexOfObject:selectedCard]] = [[Card alloc] initEmptyCard];
#if DEBUG_PRINT
        NSLog(@"Here is the cards in last row:\n%@",[self getPrintableCardInLastRow]);
#endif
        [self autoFinish:NO];
        return 0;
    } else {
        return -1;
    }
   
}
- (BOOL) moveSingleCardFromColumn:(int)columnFrom toColumn:(int)columnTo {
    Card *fromC = [gameboard[columnFrom] lastObject];
    if (!selectedCard) selectedCard = fromC;
    Card *toC = [gameboard[columnTo] lastObject];
    if ([self checkLegalMoveWithLastCardOfTheColumn:toC cardToBePlaced:fromC]) {
        [gameboard[columnFrom] removeLastObject];
        lastRow[columnFrom] = [gameboard[columnFrom] lastObject] ? [gameboard[columnFrom] lastObject] : [[Card alloc] initEmptyCard];
        [gameboard[columnTo] addObject:fromC];
        lastRow[columnTo] = [gameboard[columnTo] lastObject] ? [gameboard[columnTo] lastObject] : [[Card alloc] initEmptyCard];
        [_myUIListener onSingleCardMoveFromColumn:columnFrom toColumn:columnTo];
#if DEBUG_PRINT
        NSLog(@"Here is the card column after card moved:\n%@",[self getPrintabeCardColumn:columnTo]);
        NSLog(@"Here is the last row of the board:\n%@",[self getPrintableCardInLastRow]);
#endif
        [self autoFinish:NO];
        return YES;
    } else {
        [_myUIListener onIllegalMove];
        return NO;
    }
}

- (int) moveMultipleCardFromColumn:(int)columnFrom fromRow:(int)row toColumn:(int)columnTo{
    Card *c = [gameboard[columnTo] lastObject];
    if ([selectedCards[0] getValue] + 1  != [c getValue] || [selectedCards[0] getCardColor] == [c getCardColor])
    {
        [_myUIListener onIllegalMove];
        return -1;
    }
    if (![self checkFreeCells:selectedCards]) return -2;
    [gameboard[columnTo] addObjectsFromArray:selectedCards];
    lastRow[columnTo] = [gameboard[columnTo] lastObject] ? [gameboard[columnTo] lastObject] : [[Card alloc] initEmptyCard];
    [gameboard[columnFrom] removeObjectsInArray:selectedCards];
    lastRow[columnFrom] = [gameboard[columnFrom] lastObject] ? [gameboard[columnFrom] lastObject] : [[Card alloc] initEmptyCard];
    [self deselectCards];
    [_myUIListener onMultipleCardsMoveFromColumn: columnFrom fromRow:row toColumn:columnTo];
#if DEBUG_PRINT
    NSLog(@"Cards move from column:\n%@",[self getPrintabeCardColumn:columnFrom]);
    NSLog(@"Cards move to column:\n%@",[self getPrintabeCardColumn:columnTo]);
    NSLog(@"Last row:\n%@",[self getPrintableCardInLastRow]);
#endif
    [self autoFinish:NO];
    return 0;
}

- (BOOL) moveCardToCollectionFromColumn:(int)columnFrom toCollectionIndex:(int)index {
    Card *card = [gameboard[columnFrom] lastObject];
#if DEBUG_PRINT
    NSLog(@"Trying to collect card %@",[card getPrintableCardString]);
#endif
    if ([card getValue] == 1) {
        if ([decks[index] isEmptyCard]) {
            decks[index] = card;
            [gameboard[columnFrom] removeLastObject];
            lastRow[columnFrom] = [gameboard[columnFrom] lastObject] ? [gameboard[columnFrom] lastObject] : [[Card alloc] initEmptyCard];
            [_myUIListener onCardMoveFromColumn:columnFrom toCollectionIndex:index card:[self getCardImageName:card]];
            [self checkGame];
            return YES;
        } else {
            return NO;
        }
    } else {
        Card *temp = decks[index];
#if DEBUG_PRINT
        NSLog(@"Card in the selected cell %@",[temp getPrintableCardString]);
#endif
        if ([temp isEmptyCard]) {
            return NO;
        } else if ([temp getValue] + 1 == [card getValue] && [temp getSuit] == [card getSuit]) {
            decks[index] = card;
            [gameboard[columnFrom] removeLastObject];
            lastRow[columnFrom] = [gameboard[columnFrom] lastObject] ? [gameboard[columnFrom] lastObject] : [[Card alloc] initEmptyCard];
            [_myUIListener onCardMoveFromColumn:columnFrom toCollectionIndex:index card:[self getCardImageName:card]];
            [self checkGame];
            return YES;
        } else {
            return NO;
        }
    }
}

- (BOOL) moveSelectedCardToCollection:(int)index {
    if ([selectedCard getValue] == 1 && [decks[index] isEmptyCard]) {
        decks[index] = selectedCard;
        freeCells[[freeCells indexOfObject:selectedCard]] = [[Card alloc] initEmptyCard];
        [self autoFinish:NO];
        [self checkGame];
        return YES;
    } else {
        Card *temp = decks[index];
#if DEBUG_PRINT
        NSLog(@"Moving selected card to collection %@",[selectedCard getPrintableCardString]);
#endif
        if ([temp getValue] + 1 == [selectedCard getValue] && [temp getSuit] == [selectedCard getSuit]) {
            decks[index] = selectedCard;
            freeCells[[freeCells indexOfObject:selectedCard]] = [[Card alloc] initEmptyCard];
            [self autoFinish:NO];
            [self checkGame];
            return YES;
        } else {
            return NO;
        }
    }
}

- (int) moveSelectedCardsToEmptyColumnFromColumn:(int)columnFrom toColumn:(int) columnTo{
    int freeCellCount = [self calculateFreeCells:selectedCards emptyColumn:columnTo] + 1;
#if DEBUG_PRINT
    NSLog(@"Calculate free cells for moving cards to an empty column %d",freeCellCount);
#endif
    if (freeCellCount >= selectedCards.count) {
        [gameboard[columnTo] addObjectsFromArray:selectedCards];
        lastRow[columnTo] = [gameboard[columnTo] lastObject] ? [gameboard[columnTo] lastObject] : [[Card alloc] initEmptyCard];
        [gameboard[columnFrom] removeObjectsInArray:selectedCards];
        lastRow[columnFrom] = [gameboard[columnFrom] lastObject] ? [gameboard[columnFrom] lastObject] : [[Card alloc] initEmptyCard];
        int cardsToMove = (int)selectedCards.count;
        [self deselectCards];
#if DEBUG_PRINT
        NSLog(@"Cards move from column:\n%@",[self getPrintabeCardColumn:columnFrom]);
        NSLog(@"Cards move to column:\n%@",[self getPrintabeCardColumn:columnTo]);
        NSLog(@"Last row:\n%@",[self getPrintableCardInLastRow]);
#endif
        [self autoFinish:NO];
        return cardsToMove;
    } else {
        NSArray <Card *> *temp = [selectedCards subarrayWithRange:NSMakeRange(selectedCards.count - freeCellCount, freeCellCount)];
        [gameboard[columnTo] addObjectsFromArray:temp];
        lastRow[columnTo] = [gameboard[columnTo] lastObject] ? [gameboard[columnTo] lastObject] : [[Card alloc] initEmptyCard];
        [gameboard[columnFrom] removeObjectsInArray:temp];
        lastRow[columnFrom] = [gameboard[columnFrom] lastObject] ? [gameboard[columnFrom] lastObject] : [[Card alloc] initEmptyCard];
        [self deselectCards];
#if DEBUG_PRINT
        NSLog(@"Cards move from column:\n%@",[self getPrintabeCardColumn:columnFrom]);
        NSLog(@"Cards move to column:\n%@",[self getPrintabeCardColumn:columnTo]);
        NSLog(@"Last row:\n%@",[self getPrintableCardInLastRow]);
#endif
        [self autoFinish:NO];
        return freeCellCount;
    }

}

- (int) numberOfCardsAtColumn:(int)column {
    return (int)gameboard[column].count;
}

- (NSString *) getSelectedCard {
    return [NSString stringWithFormat:@"card_%d_%d",selectedCard.getValue,selectedCard.getSuit];
}

- (Card *) getRealSelectedCard {
    return selectedCard;
}

- (NSArray <Card *>*) getMovedCards {
    return @[];
}

- (void) selectCardAtColumn:(int)column row:(int)row {
    selectedCard = gameboard[column][row];
}

- (void) selectCardsAtColumn:(int)column fromRow:(int)row {
    NSArray *c = gameboard[column];
    selectedCards = [NSMutableArray arrayWithArray:[c subarrayWithRange:NSMakeRange(row, c.count - row)]];
#if DEBUG_PRINT
    NSMutableString *string = [NSMutableString string];
    for (Card *c in selectedCards) {
        [string appendFormat:@"%@\n",[c getPrintableCardString]];
    }
    NSLog(@"Cards selected:\n%@",string);
#endif
}

- (void) selectCardAtTempCell:(int)index {
    selectedCard = freeCells[index];
}

- (BOOL) checkMultiSelectAtColumn:(int)column fromRow:(int)row {
    NSArray *c = gameboard[column];
    for (int i = row; i < c.count-1; i ++) {
        if ([c[i] getValue] - 1 != [c[i+1] getValue] || [c[i] getCardColor] == [c[i+1] getCardColor]) {
            return NO;
        }
    }
    return YES;
}

- (void) deselectCard {
    selectedCard = nil;
}

- (void) deselectCards {
    selectedCards = [NSMutableArray array];
}

- (void) resetGame{
    gameboard = [NSMutableArray array];
    [deck resetDeck];
    lastRow = [NSMutableArray array];
    freeCells = [NSMutableArray array];
    decks = [NSMutableArray array];
    [self setupGame];
    [_myUIListener onGameRest];
}

- (void) checkGame {
    if ([self isGameWin]) {
        [_myUIListener checkGame:gameWin];
    } else if ([self checkDeadEnd]){
        [_myUIListener checkGame:gameDeadEnd];
    } else {
        [_myUIListener checkGame:gamePlaying];
    }
}

- (void) autoFinish {
    [self autoFinish:YES];
}

/********************************* HELP METHOD ***************************************/

- (BOOL) checkLegalMoveWithLastCardOfTheColumn:(Card *) card1 cardToBePlaced:(Card *) card2 {
    if (!card1 || [card1 isEmptyCard]) {
        return YES;
    } else if ([card1 getCardColor] != [card2 getCardColor] && [card2 getValue] - [card1 getValue] == -1) {
        return YES;
    } else {
        return NO;
    }
}

- (int) calculateFreeCells:(NSArray <Card *> *) cardsTemp emptyColumn:(int) ec{
    NSMutableArray <Card *> *cards = [NSMutableArray arrayWithArray:cardsTemp];
    [cards removeObjectAtIndex:0];
    int freeCellCount = 0;
    int tempFreeCellCount = 0;
    for(Card *card in freeCells) {
        if (!card || [card isEmptyCard]) {
            freeCellCount += 1;
            tempFreeCellCount += 1;
        }
    }
#if DEBUG_PRINT
    NSLog(@"Available free cells %d",freeCellCount);
#endif
    NSMutableArray <Card *> *temp = [NSMutableArray arrayWithArray:lastRow];
    [temp removeObjectAtIndex:ec];
    for (int i = (int)cards.count - 1; i >= 0; i--) {
        Card *c = cards[i];
        int index = 0;
        while (index < temp.count) {
            Card *tc = temp[index];
#if DEBUG_VIEW
            NSLog(@"Checking the card in last row: %@",[tc getPrintableCardString]);
#endif
            if (!tc || [tc isEmptyCard]) {
                freeCellCount += 1;
                [temp removeObjectAtIndex:index];
                break;
            } else if ([c getValue] + 1 == [tc getValue] && [c getCardColor] != [tc getCardColor]) {
                freeCellCount += 1;
                [temp removeObjectAtIndex:index];
                break;
            } else if (tempFreeCellCount > 0) {
                tempFreeCellCount -= 1;
                break;
            }
            index ++;
        }
    }
    return freeCellCount;
}

- (BOOL) checkFreeCells:(NSArray <Card *> *) cards{
    int freeCellCount = 0;
    int tempFreeCellCount = 0;
    for(Card *card in freeCells) {
        if (!card || [card isEmptyCard]) {
            freeCellCount += 1;
            tempFreeCellCount += 1;
        }
    }
#if DEBUG_PRINT
    NSLog(@"Available FreeCells %d",freeCellCount);
#endif
    if (cards.count <= freeCellCount) return YES;
    NSMutableArray <Card *> *temp = [NSMutableArray arrayWithArray:lastRow];
    for (int i = (int)cards.count - 1; i >= 0; i--) {
        Card *c = cards[i];
        int index = 0;
        while (index < temp.count) {
            Card *tc = temp[index];
            if (!tc || [tc isEmptyCard]) {
                freeCellCount += 1;
                [temp removeObjectAtIndex:index];
                break;
            } else if ([c getValue] + 1 == [tc getValue] && [c getCardColor] != [tc getCardColor]) {
                freeCellCount += 1;
                [temp removeObjectAtIndex:index];
                break;
            } else if (tempFreeCellCount > 0) {
                tempFreeCellCount -= 1;
                break;
            }
            index ++;
        }
    }
#if DEBUG_PRINT
    NSLog(@"Total available FreeCells %d",freeCellCount);
#endif
    if (cards.count <= freeCellCount) return YES;
    else return NO;
    
}

- (BOOL) isGameWin {
    for (Card *c in decks) {
#if DEBUG_PRINT
        NSLog(@"Check game win: card in collection %@",[c getPrintableCardString]);
#endif
        if ([c getValue] != 13) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) checkDeadEnd {
    return NO;
}

- (NSString *) getCardImageName:(Card *) card {
    return [NSString stringWithFormat:@"card_%d_%d",[card getValue],[card getSuit]];
}

- (void) autoFinish:(BOOL) isForce {
    for (int i = 0; i < number_of_column; i ++) {
#if AUTO_FINISH_PRINT
        NSLog(@"=====================");
        NSLog(@"autoFinish column %d",i);
        NSLog(@"=====================");
#endif
        Card *temp = lastRow[i];
        if ((!isForce && temp.getValue >= auto_finish_card_value_threshold) || temp == nil) continue;
        for (int j = 0; j < 4; j++) {
            BOOL flag = [self moveCardToCollectionFromColumn:i toCollectionIndex:j];
            
            if (flag) {
                [self autoFinish:isForce];
#if AUTO_FINISH_PRINT
                NSLog(@"=====================================");
                NSLog(@"Collect card at column %d to cell %d",i,j);
                NSLog(@"=====================================");
#endif
            }
        }
    }
}

/********************************* PRINT METHODS ***************************************/

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
    for (int i = 0; i < paddingLength; i++) {
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

- (NSString *) getPrintabeCardColumn:(int) column {
    NSMutableString *string = [NSMutableString string];
    NSArray *cl = gameboard[column];
    for (Card *c in cl) {
        [string appendFormat:@"%@\n",[c getPrintableCardString]];
    }
    return string;
}
@end
