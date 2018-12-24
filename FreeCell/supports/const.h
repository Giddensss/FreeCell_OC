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
#define DEBUG_VIEW 0

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

// const for the game
const static int deckLength = 52; // Theres no Jokers in the deck.
const static int number_of_temp_cells = 4;
const static int number_of_column = 8;
const static int longest_card_name = 17;
const static int number_of_free_cells = number_of_temp_cells + number_of_column;

// cosnt for UI
const static CGFloat card_horizontal_margin = 20.0f;
const static CGFloat card_vertical_overlap_gap = 35;
const static CGFloat card_width = 111.0f;
const static CGFloat card_height = 166.0f;
#endif /* const_h */
