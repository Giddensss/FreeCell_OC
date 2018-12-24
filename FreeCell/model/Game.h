//
//  Game.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Game : NSObject

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
 * @param index: the temp cell index where the card is at
 *
 */
- (int) moveCardFromTempCell:(int) index toGameBoardColumn:(int) column;

- (BOOL) moveSingleCardFromColumn:(int) columnFrom toColumn:(int) columnTo;

- (int) numberOfCardsAtColumn:(int) column;

- (NSString *) getSelectedCard;

- (NSArray <NSString *> *) getMovedCards;

- (void) selectCardAtColumn:(int) column row:(int) row;

- (void) selectCardsAtColumn:(int) column fromRow:(int) row;

- (BOOL) checkMultiSelectAtColumn:(int) column fromRow:(int) row;

- (void) deselectCard;

- (void) deselectCards;
@end

NS_ASSUME_NONNULL_END
