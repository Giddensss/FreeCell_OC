//
//  const.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/22.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#ifndef const_h
#define const_h
#define DEBUG_PRINT 1

enum CardSuit{
    suitSpade,
    suitHeart,
    suitClub,
    suitDiomand
};

enum CardColor{
    cardColorBlack,
    cardColorRed
};

const static int deckLength = 52; // Theres no Jokers in the deck.
#endif /* const_h */
