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

@end

NS_ASSUME_NONNULL_END
