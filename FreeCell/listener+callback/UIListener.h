//
//  MoveCardUIListener.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2019/1/5.
//  Copyright © 2019 Alan L  Hamilton. All rights reserved.
//

#import "../supports/const.h"
#ifndef MoveCardUIListener_h
#define MoveCardUIListener_h

@protocol UIListener <NSObject>

- (void) onSingleCardMoveFromColumn:(int) columnFrom toColumn:(int) columnTo;

- (void) onMultipleCardsMoveFromColumn:(int) columnFrom fromRow:(int) rowFrom toColumn:(int) columnTo;

- (void) onCardMoveFromColumn:(int) columnFrom toFreeCell:(int) index card:(NSString *) card;

- (void) onCardMoveFromColumn:(int) columnFrom toCollectionIndex:(int) index card:(NSString *) card;

- (void) onCardMoveFromTempCell:(int) indexFrom toTempCell:(int) indexTo success:(BOOL) flag card:(NSString *) card;

- (void) onIllegalMove;

- (void) onGameRest;

- (void) checkGame:(enum gameStatus) status;

@end
#endif /* MoveCardUIListener_h */
