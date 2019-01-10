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
#define AUTO_FINISH_PRINT 0
#define CHECK_DEAD_END_PRINT 1
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

enum gameStatus{
    gameWin,
    gamePlaying,
    gameDeadEnd,
};

// const for the game
const static int deckLength = 52; // Theres no Jokers in the deck.
const static int number_of_temp_cells = 4;
const static int number_of_column = 8;
const static int longest_card_name = 17;
const static int number_of_free_cells = number_of_temp_cells;

// cosnt for UI
/*
 * The size of window is fixed. Don't change the values of these constants.
 * Or resize the window first, then update the values.
 *
 */
const static CGFloat window_width = 1200.0f;
const static CGFloat window_height = 700.0f;

/*
 *
 * The value of this constant is fixed as well. Don't change it.
 * Or modify the storyboard first, and then update the value
 *
 */
const static CGFloat top_cell_area_height = 218;

const static CGFloat gap_between_top_cell = 4.0f;
const static CGFloat top_cell_bound_diff = 4.0f;

const static CGFloat indicatitor_size = 48.0f;
const static CGFloat card_horizontal_margin = 20.0f;
const static CGFloat card_vertical_overlap_gap = 35;
const static CGFloat card_size_ratio = 0.7f;
const static CGFloat card_image_width = 165.0f;
const static CGFloat card_image_height = 250.0f;
const static CGFloat card_width = card_image_width * card_size_ratio;
const static CGFloat card_height = card_image_height * card_size_ratio;
const static CGFloat choicePickerViewWidth = 330.0f;
const static CGFloat choicePickerViewHeight = 150.0f;


// other constants
const static int auto_finish_card_value_threshold = 4;
#endif /* const_h */
