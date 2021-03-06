//
//  Game.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "../listener+callback/UIListener.h"

NS_ASSUME_NONNULL_BEGIN
@interface Game : NSObject

@property id<UIListener> myUIListener;

- (void) setupGame;

- (NSArray <NSArray <Card *> *>*) getBoard;

/*
 * Move the card from the game board to the temp cell
 * @return if move is success
 *
 * @param column: the column where the card is at in the board
 * @param index: the temp cell index where the card iss going to place
 *
 */
- (BOOL) moveCardToTempCellAtColumn:(int) column toTempCellIndex:(int) index;

/*
 * Move the card from the temp cell to the game board
 * @return if move is success: 0. Success
 *                             1. Nothing to move
 *                            -1. Invalid move
 *
 * @param column: the column where the card is going to place
 *
 */
- (int) moveCardFromTempCellToGameBoardColumn:(int) column;

- (BOOL) moveSingleCardFromColumn:(int) columnFrom toColumn:(int) columnTo;

/*
 * Move selected cards and place them at the end of the target column
 * @return if move is success: 0. Success
 *                             1. Nothing to move
 *                            -1. Invalid move
 *                            -2. No enough free cells
 * @param columnFrom: the column from which the selected cards currently are
 * @param rowFrom: the row from which the selected cards are
 * @param columnTo: the target column
 *
 */
- (int) moveMultipleCardFromColumn:(int) columnFrom fromRow:(int) row toColumn:(int) columnTo;

- (BOOL) moveCardToCollectionFromColumn:(int) columnFrom toCollectionIndex:(int) index;

- (BOOL) moveSelectedCardToCollection:(int) index;

- (void) moveSelectedCardsToEmptyColumnFromColumn:(int) columnFrom toColumn:(int) columnTo;

- (int) numberOfCardsAtColumn:(int) column;

- (void) moveCardFromTempCell:(int) indexFrom toTempCell:(int) indexTo;

- (NSString *) getSelectedCard;

- (Card *) getRealSelectedCard;

- (NSArray <NSString *> *) getMovedCards;

- (void) selectCardAtTempCell:(int) index;

- (void) selectCardAtColumn:(int) column row:(int) row;

- (void) selectCardsAtColumn:(int) column fromRow:(int) row;

- (BOOL) checkMultiSelectAtColumn:(int) column fromRow:(int) row;

- (void) deselectCard;

- (void) deselectCards;

- (void) resetGame;

- (void) autoFinish;

- (BOOL) isEmptyCell:(int) index;
@end

NS_ASSUME_NONNULL_END
