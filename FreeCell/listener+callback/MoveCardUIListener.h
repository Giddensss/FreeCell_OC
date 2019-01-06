//
//  MoveCardUIListener.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2019/1/5.
//  Copyright © 2019 Alan L  Hamilton. All rights reserved.
//

#ifndef MoveCardUIListener_h
#define MoveCardUIListener_h

@protocol MoveCardUIListener <NSObject>

- (void) onSingleCardMoveFromColumn:(int) columnFrom toColumn:(int) columnTo;

- (void) onMultipleCardsMoveFromColumn:(int) columnFrom fromRow:(int) rowFrom toColumn:(int) columnTo;

- (void) onCardMoveFromColumn:(int) columnFrom toFreeCell:(int) index card:(NSString *) card;

- (void) onCardMoveFromColumn:(int) columnFrom toCollectionIndex:(int) index card:(NSString *) card;

- (void) onIllegalMove;

@end
#endif /* MoveCardUIListener_h */
