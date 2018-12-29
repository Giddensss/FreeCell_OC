//
//  GameListener.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/29.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#ifndef GameListener_h
#define GameListener_h

@protocol GameListener <NSObject>

- (void) onGameWin;

- (void) onDeadEnd;

@end
#endif /* GameListener_h */
