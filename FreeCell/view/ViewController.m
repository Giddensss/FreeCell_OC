//
//  ViewController.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/10/16.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "ViewController.h"
#import "../supports/const.h"
#import "../supports/AppDelegate.h"
#import "../model/Game.h"

@interface ViewController() {
    IBOutlet NSButton *indicator;
    
    IBOutlet NSButton *tempCell0;
    IBOutlet NSButton *tempCell1;
    IBOutlet NSButton *tempCell2;
    IBOutlet NSButton *tempCell3;
    IBOutlet NSButton *cell0;
    IBOutlet NSButton *cell1;
    IBOutlet NSButton *cell2;
    IBOutlet NSButton *cell3;
    IBOutlet NSView *boardView;
    IBOutlet NSView *ChoicePickerView;
    
    NSMutableArray <NSButton *>*tempCells;
    NSMutableArray <NSButton *>*cells;
    NSMutableArray <NSMutableArray <CardView *> *> *cards;
    NSMutableArray <EmptyCardView *> *emptyCards;
    AppDelegate *myDelegate;
    Game *myGame;
    
    int realignCardThreshold;
    
    BOOL isSelected;
    BOOL isSelectMultiple;
    int clickedRow;
    int clickedColumn;
    int clickedFreeCellIndex;
    int clickedEmptyColumn;
    
}
@end
@implementation ViewController

- (id) initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        myDelegate = [NSApplication sharedApplication].delegate;
        myGame = myDelegate.myGame;
        myGame.myUIListener = self;
        [self initParameters];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ((WindowBackgroundView *) self.view).listener = self;
    
    // setup top btns
    tempCells = [NSMutableArray arrayWithObjects:tempCell0,tempCell1,tempCell2,tempCell3, nil];
    cells = [NSMutableArray arrayWithObjects:cell0,cell1,cell2,cell3, nil];
    for (int i = 0; i < tempCells.count; i ++) {
        NSButton *button = tempCells[i];
        button.accessibilityTitle = [NSString stringWithFormat:@"temp%d",i];
        [button setTarget:self];
        [button setAction:@selector(topCellBtnClicked:)];
        [button setHighlighted:NO];
        [(NSButtonCell *)button.cell setHighlightsBy:NSNoCellMask];
        NSButton *cellBtn = cells[i];
        cellBtn.accessibilityTitle = [NSString stringWithFormat:@"cell%d",i];
        [cellBtn setTarget:self];
        [cellBtn setAction:@selector(topCellBtnClicked:)];
        [cellBtn setHighlighted:NO];
        [(NSButtonCell *)cellBtn.cell setHighlightsBy:NSNoCellMask];
    }
    
    realignCardThreshold = (int) (((CGFloat)boardView.frame.size.height - (CGFloat)card_height) / (CGFloat)card_vertical_overlap_gap) + 1;
#if DEBUG_PRINT
    NSLog(@"CardView realign threshold %d",realignCardThreshold);
#endif
    
    // setup baord;
    [self initBoardUI];
    [ChoicePickerView removeFromSuperview];
    [ChoicePickerView setFrame:CGRectMake((self.view.frame.size.width - choicePickerViewWidth) / 2,
                                          (self.view.frame.size.height - choicePickerViewHeight) / 2,
                                          choicePickerViewWidth, choicePickerViewHeight)];
    [self.view addSubview:ChoicePickerView];
    [ChoicePickerView setHidden:YES];
    
}

- (void) topCellBtnClicked:(NSButton *) sender {
    NSString *identifier = sender.accessibilityTitle;
    int index = [[identifier substringFromIndex:4] intValue];
    if ([identifier containsString:@"temp"]) {
#if DEBUG_PRINT
        NSLog(@"Click on temp cell %d",index);
#endif
        if (isSelected) {
            if (isSelectMultiple) {
                [self showIllegalMoveWarning];
                [myGame deselectCards];
                // deselect all the cards
                [self deselectCardsAtColumn];
                isSelected = NO;
                clickedColumn = -1;
                clickedRow = -1;
                return;
            } else if (clickedFreeCellIndex != -1) {
                if (index == clickedFreeCellIndex) {
                    // deselect
                    [tempCells[clickedFreeCellIndex] setImage:[NSImage imageNamed:[myGame getSelectedCard]]];
                    [myGame deselectCard];
                    clickedFreeCellIndex = -1;
                    isSelected = NO;
                } else {
                    [tempCells[clickedFreeCellIndex] setImage:[NSImage imageNamed:[myGame getSelectedCard]]];
                    clickedFreeCellIndex = index;
                    [myGame selectCardAtTempCell:clickedFreeCellIndex];
                    [sender setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%@_highlight",[myGame getSelectedCard]]]];
                }
                return;
            }
            BOOL flag = [myGame moveCardToTempCellAtColumn:clickedColumn toTempCellIndex:index];
            [myGame deselectCard];
            if (!flag) {
                [cards[clickedColumn][clickedRow] deselectCard];
            }
            clickedColumn = -1;
            clickedRow = -1;
            isSelected = NO;
        } else {
#if DEBUG_PRINT
            NSLog(@"Select card at free cell index: %d",index);
            NSLog(@"ClickedColumn %d, ClickedRow %d",clickedColumn,clickedRow);
#endif
            isSelected = YES;
            [myGame selectCardAtTempCell:index];
            [sender setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%@_highlight",[myGame getSelectedCard]]]];
            clickedFreeCellIndex = index;
        }

    } else if ([identifier containsString:@"cell"]) {
#if DEBUG_PRINT
        NSLog(@"Click on cell %d",index);
#endif
        if (isSelected && !isSelectMultiple) {
            if (clickedColumn == -1 && clickedRow == -1) {
                if ([myGame moveSelectedCardToCollection:index]) {
                    [cells[index] setImage:[NSImage imageNamed:[myGame getSelectedCard]]];
                    [myGame deselectCard];
                    [self checkGame:[myGame checkGame]];
                }
                [tempCells[clickedFreeCellIndex] setImage:nil];
                clickedFreeCellIndex = -1;
                isSelected = NO;
            } else if ([myGame moveCardToCollectionFromColumn:clickedColumn toCollectionIndex:index]) {
                clickedColumn = -1;
                clickedRow = -1;
                isSelected = NO;
                [self checkGame:[myGame checkGame]];
            } else {
                if (isSelectMultiple) {
                    [myGame deselectCards];
                    [self deselectCardsAtColumn];
                } else {
                    [myGame deselectCard];
                    [cards[clickedColumn][clickedRow] deselectCard];
                }
                clickedColumn = -1;
                clickedRow = -1;
                isSelected = NO;
                
            }
        }
    }
}

- (IBAction)indicatorClicked:(id)sender {
#if DEBUG_PRINT
    NSLog(@"Indicator Clicked");
#endif
    [myGame resetGame];
    for (int i = 0; i < tempCells.count; i ++ ) {
        [tempCells[i] setImage:nil];
        [cells[i] setImage:nil];
    }
    
    for (NSArray <CardView *> *c in cards) {
        for (CardView *view in c) {
            [view removeFromSuperview];
        }
    }
    
    [self initParameters];
    [self initBoardUI];
    
    [ChoicePickerView removeFromSuperview];
    [ChoicePickerView setFrame:CGRectMake((self.view.frame.size.width - choicePickerViewWidth) / 2,
                                          (self.view.frame.size.height - choicePickerViewHeight) / 2,
                                          choicePickerViewWidth, choicePickerViewHeight)];
    [self.view addSubview:ChoicePickerView];
    [ChoicePickerView setHidden:YES];
}

- (void) onMouseInWindowPositionChanged:(enum mouseInWindow)position {
    switch (position) {
        case mouseOnLeft:
            [indicator setImage:[NSImage imageNamed:@"indicator_left"]];
            break;
        case mouseOnRight:
             [indicator setImage:[NSImage imageNamed:@"indicator_right"]];
            break;
    }
}

- (void) onCardViewClicked:(CGPoint)cardPosition {
#if DEBUG_PRINT
    NSLog(@"Card view clicked");
#endif
    int column = cardPosition.x;
    int row = cardPosition.y;
    if (isSelected) {
        if (clickedColumn == -1 && clickedRow == -1) {
            int ret = [myGame moveCardFromTempCellToGameBoardColumn:column];
            if (ret == 0) {
                // successful
                CGFloat horizontal_gap = (boardView.frame.size.width - number_of_column * card_width ) / (number_of_column - 1);
                CardView *view = [[CardView alloc] initWithFrame:CGRectMake((horizontal_gap + card_width) * column,
                                                                            boardView.frame.size.height - (card_height + (row + 1 ) * card_vertical_overlap_gap), card_width, card_height)];
                view.rowInBoard = row + 1;
                view.columnInBoard = column;
                [view setCardViewWithValue:[[myGame getRealSelectedCard] getValue] suit:[[myGame getRealSelectedCard] getSuit] title:[[myGame getRealSelectedCard] getPrintableCardString]];
                [cards[column] addObject:view];
                if (cards[column].count > realignCardThreshold) {
                    [self alignCardBasedOnRow:cards[column] atColumn:column];
                }
                [view setCardListener:self];
                [boardView addSubview:view positioned:NSWindowAbove relativeTo:cards[column][row]];
                [tempCells[clickedFreeCellIndex] setImage:nil];
            } else if (ret == 1) {
                // nothing to move
            } else if (ret == -1) {
                [self showIllegalMoveWarning];
                [tempCells[clickedFreeCellIndex] setImage:[NSImage imageNamed:[myGame getSelectedCard]]];
            }
            
            clickedFreeCellIndex = -1;
            isSelected = NO;
            [myGame deselectCard];
        } else if (row == clickedRow && column == clickedColumn) {
            // deselect
            isSelected = NO;
            [myGame deselectCard];
            if (isSelectMultiple) {
                [self deselectCardsAtColumn];
                isSelectMultiple = NO;
            } else {
                [cards[clickedColumn][clickedRow] deselectCard];
            }
            clickedRow = -1;
            clickedColumn = -1;
#if DEBUG_PRINT
            NSLog(@"Card deselected.");
#endif
        } else {
            // move card(s)
            if (isSelectMultiple) {
                // move a list of cards
                int ret = [myGame moveMultipleCardFromColumn:clickedColumn fromRow:clickedRow toColumn:column];
                if (ret != 0) {
                    // nothing to move
                    [self deselectCardsAtColumn];
                } 
                clickedColumn = -1;
                clickedRow = -1;
                isSelected = NO;
                isSelectMultiple = NO;
            } else {
                // move single card
                BOOL flag = [myGame moveSingleCardFromColumn:clickedColumn toColumn:column];
                isSelected = NO;
                [myGame deselectCard];
                if (!flag) {
                    [cards[clickedColumn][clickedRow] deselectCard];
                }
                clickedRow = -1;
                clickedColumn = -1;
                
            }
            
        }
    } else {
       
        if (row == [myGame numberOfCardsAtColumn:column] - 1) {
            // select a single card
            isSelected = YES;
            clickedColumn = column;
            clickedRow = row;
            [myGame selectCardAtColumn:clickedColumn row:clickedRow];
            [cards[clickedColumn][clickedRow] selectCard];
#if DEBUG_PRINT
            NSLog(@"Card selected at row %d column %d",clickedRow,clickedColumn);
#endif
        } else {
            // select a list of cards
            if ([myGame checkMultiSelectAtColumn:column fromRow:row]) {
                isSelected = YES;
                clickedColumn = column;
                clickedRow = row;
                [self selectCardsAtColumn:clickedColumn fromRow:clickedRow];
#if DEBUG_PRINT
                NSLog(@"Card selected from row %d column %d",clickedRow,clickedColumn);
#endif
            }
            

        }
    }
}

- (void) onCardViewMouseRightDown:(CGPoint)cardPosition {
    int column= cardPosition.x;
    int row = cardPosition.y;
    if (row < cards[column].count - 1) {
        CardView *view = cards[column][row];
        [boardView addSubview:view];
        [view becomeFirstResponder];
    }
    
}

- (void) onCardViewMouseRightUp:(CGPoint)cardPosition {
    int column= cardPosition.x;
    int row = cardPosition.y;
    if (row < cards[column].count - 1) {
        CardView *view = cards[column][row];
        [view removeFromSuperview];
        [boardView addSubview:view positioned:NSWindowBelow relativeTo:cards[column][row + 1]];
        
    }
}

- (void) onViewClicked:(int)column sender:(EmptyCardView *)v{
#if DEBUG_PRINT
    NSLog(@"Empty view is click");
#endif
    if (isSelected) {
        if (isSelectMultiple) {
            clickedEmptyColumn = column;
            [ChoicePickerView setHidden:NO];
        } else {
            if (clickedFreeCellIndex != -1) {
                [myGame moveCardFromTempCellToGameBoardColumn:column];
                [self addCardViewToEmptyColumn:column view:v];
                [tempCells[clickedFreeCellIndex] setImage:nil];
                clickedFreeCellIndex = -1;
                isSelected = NO;
            } else {
                [myGame moveSingleCardFromColumn:clickedColumn toColumn:column];
                int previousCount = (int)cards[clickedColumn].count;
                if (previousCount > realignCardThreshold) {
                    if (cards[clickedColumn].count == realignCardThreshold) {
                        [self alignCardNormal:cards[clickedColumn] atColumn:clickedColumn];
                    } else {
                        [self alignCardBasedOnRow:cards[clickedColumn] atColumn:clickedColumn];
                    }
                }
                clickedColumn = -1;
                clickedRow = -1;
                isSelected = NO;
            }
        }
    }
}

- (void) onMoveWholeListBtnClicked {
#if DEBUG_PRINT
    NSLog(@"Move Whole list to the empty column");
#endif
    [ChoicePickerView setHidden:YES];
    int cardsMoved = [myGame moveSelectedCardsToEmptyColumnFromColumn:clickedColumn toColumn:clickedEmptyColumn];
#if DEBUG_PRINT
    NSLog(@"Moving number of card %d",cardsMoved);
#endif
    [self deselectCardsAtColumn];
    NSMutableArray <CardView *> *temp = [NSMutableArray array];
    CGFloat verticalGap = card_vertical_overlap_gap;
    CGFloat horizontal_gap = (boardView.frame.size.width - number_of_column * card_width ) / (number_of_column - 1);
    if (cardsMoved > realignCardThreshold) verticalGap = (boardView.frame.size.height - card_height) / cardsMoved;
    for (int i = 0; i < cardsMoved; i++) {
        [temp addObject:cards[clickedColumn][cards[clickedColumn].count - i - 1]];
        temp[i].columnInBoard = clickedEmptyColumn;
        temp[i].rowInBoard = cardsMoved - i - 1; // temp array contains CardViews in a reversed order.
#if DEBUG_PRINT
        NSLog(@"laying CardView to %d,%d",clickedEmptyColumn,cardsMoved - i - 1);
#endif
        [temp[i] setFrame:CGRectMake((horizontal_gap + card_width) * clickedEmptyColumn,
                                     boardView.frame.size.height - (card_height + temp[i].rowInBoard * verticalGap),
                                     card_width,
                                     card_height)];
    }
    for (int i = cardsMoved - 1; i >= 0; i --) {
        [temp[i] removeFromSuperview];
        if (i == cardsMoved - 1) {
            [boardView addSubview:temp[i] positioned:NSWindowAbove relativeTo:emptyCards[clickedEmptyColumn]];
        } else {
            [boardView addSubview:temp[i] positioned:NSWindowAbove relativeTo:temp[i + 1]];
        }
        [cards[clickedEmptyColumn] addObject:temp[i]];
    }
    int previousCount = (int)cards[clickedColumn].count;
    [cards[clickedColumn] removeObjectsInArray:temp];
    if (previousCount > realignCardThreshold) {
        if (cards[clickedColumn].count <= realignCardThreshold) {
            [self alignCardNormal:cards[clickedColumn] atColumn:clickedColumn];
        } else {
            [self alignCardBasedOnRow:cards[clickedColumn] atColumn:clickedColumn];
        }
    }
    
    [myGame deselectCards];
    clickedColumn = -1;
    clickedRow = -1;
    clickedEmptyColumn = -1;
    isSelected = NO;

    
}

- (void) onMoveSingleCardBtnClicked {
#if DEBUG_PRINT
    NSLog(@"Move single card to the empty column");
#endif
    [ChoicePickerView setHidden:YES];
    [self deselectCardsAtColumn];
    [myGame moveSingleCardFromColumn:clickedColumn toColumn:clickedEmptyColumn];
    [myGame deselectCards];
    int previousCount = (int)cards[clickedColumn].count;
    if (previousCount > realignCardThreshold) {
        if (cards[clickedColumn].count == realignCardThreshold) {
            [self alignCardNormal:cards[clickedColumn] atColumn:clickedColumn];
        } else {
            [self alignCardBasedOnRow:cards[clickedColumn] atColumn:clickedColumn];
        }
    }
    clickedColumn = -1;
    clickedRow = -1;
    clickedEmptyColumn = -1;
    isSelected = NO;
}

- (void) onMouseClickedOnView {
#if DEBUG_PRINT
    NSLog(@"Hide ChoicePickerView");
    [ChoicePickerView setHidden:YES];
#endif
}

- (void) showIllegalMoveWarning {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Illega Move!"];
    [alert setInformativeText:@"You cannot place card(s) here!"];
    [alert addButtonWithTitle:@"Got you"];
    [alert setIcon:[NSImage imageNamed:@"icon"]];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
}

- (void) showNoEnoughFreeCellsWarning {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Out of space!"];
    [alert setInformativeText:@"You don't have enough space to acheive your movement!"];
    [alert addButtonWithTitle:@"Got you"];
    [alert setIcon:[NSImage imageNamed:@"icon"]];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
}

- (void) showGameWin {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Congratulations!"];
    [alert setInformativeText:@"You win the game!"];
    [alert addButtonWithTitle:@"Cheers!"];
    [alert setIcon:[NSImage imageNamed:@"icon"]];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
}

- (void) showDeadEndWarning {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Dead End!"];
    [alert setInformativeText:@"You are in a dead end! Re-start a game."];
    [alert addButtonWithTitle:@"Got you"];
    [alert setIcon:[NSImage imageNamed:@"icon"]];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
}

- (void) deselectCardsAtColumn{
    NSArray *c = cards[clickedColumn];
    for (int i = clickedRow; i < c.count; i++) {
        [c[i] deselectCard];
    }
    [myGame deselectCards];
    isSelectMultiple = NO;
}

- (void) selectCardsAtColumn:(int) column fromRow:(int) row {
    NSArray *c = cards[column];
    for (int i = row; i < c.count; i++) {
        [c[i] selectCard];
    }
    [myGame selectCardsAtColumn:column fromRow:row];
    isSelectMultiple = YES;
}

- (void) alignCardNormal:(NSArray <CardView *> *) c atColumn:(int) column {
    CGFloat horizontal_gap = (boardView.frame.size.width - number_of_column * card_width ) / (number_of_column - 1);
    for (int i = 0; i < c.count; i++) {
        [c[i] setFrame:NSMakeRect((horizontal_gap + card_width) * column,
                                                     boardView.frame.size.height - (card_height + i * card_vertical_overlap_gap),
                                                     card_width,
                                                     card_height)];
        if (i > 0) {
            [c[i] removeFromSuperview];
            [boardView addSubview:c[i] positioned:NSWindowAbove relativeTo:c[i-1]];
        } else if (i == 0) {
            [c[i] removeFromSuperview];
            [boardView addSubview:c[i] positioned:NSWindowAbove relativeTo:emptyCards[column]];
        }
    }
}

- (void) alignCardBasedOnRow:(NSArray <CardView *> *) c atColumn:(int) column {
    CGFloat verticalGap = (boardView.frame.size.height - card_height) / c.count;
    CGFloat horizontal_gap = (boardView.frame.size.width - number_of_column * card_width ) / (number_of_column - 1);
    for (int i = 0; i < cards[column].count; i++) {
        [c[i] setFrame:CGRectMake((horizontal_gap + card_width) * column,
                                              boardView.frame.size.height - (card_height + i  * verticalGap),
                                              card_width, card_height)];
        if (i > 0) {
            [c[i] removeFromSuperview];
            [boardView addSubview:c[i] positioned:NSWindowAbove relativeTo:c[i-1]];
        } else if (i == 0) {
            [c[i] removeFromSuperview];
            [boardView addSubview:c[i] positioned:NSWindowAbove relativeTo:emptyCards[column]];
        }
    }
}

- (void) addCardViewToEmptyColumn:(int) column view:(EmptyCardView *) v{
#if DEBUG_PRINT
    NSLog(@"Add new CardView to EmptyCardView at column %d",v.column);
    NSLog(@"Frame: (%f,%f) %f x %f",v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
#endif
    CardView *view = [[CardView alloc] initWithFrame:v.frame];
    view.columnInBoard = column;
    view.rowInBoard = 0;
    [view setCardViewWithValue:[[myGame getRealSelectedCard] getValue] suit:[[myGame getRealSelectedCard] getSuit] title:[[myGame getRealSelectedCard] getPrintableCardString]];
    [view setCardListener: self];
    [cards[column] addObject:view];
    [boardView addSubview:view positioned:NSWindowAbove relativeTo:v];
    [myGame deselectCard];
}

- (void) checkGame:(enum gameStatus) status {
    switch (status) {
        case gameWin:
            [self showGameWin];
            break;
        case gamePlaying:
            break;
        case gameDeadEnd:
            break;
    }
}

- (void) initBoardUI {
    NSArray *board = [myGame getBoard];
    CGFloat horizontal_gap = (boardView.frame.size.width - number_of_column * card_width ) / (number_of_column - 1);
    
    int column = 0;
    for (NSArray *cardColumn in board) {
        NSMutableArray<CardView *> *temp = [NSMutableArray array];
        for (int row = 0; row < cardColumn.count; row ++) {
            if (row == 0) {
                EmptyCardView *emptyCard = [[EmptyCardView alloc] initWithFrame:CGRectMake((horizontal_gap + card_width) * column,
                                                                                           boardView.frame.size.height - (card_height + row * card_vertical_overlap_gap),
                                                                                           card_width,
                                                                                           card_height)];
                emptyCard.column = column;
                emptyCard.clickListener = self;
                [boardView addSubview:emptyCard];
                [emptyCards addObject:emptyCard];
            }
            CardView *card = [[CardView alloc] initWithFrame:CGRectMake((horizontal_gap + card_width) * column,
                                                                        boardView.frame.size.height - (card_height + row * card_vertical_overlap_gap),
                                                                        card_width,
                                                                        card_height)];
            [card setCardViewWithValue:[cardColumn[row] getValue] suit:[cardColumn[row] getSuit] title:[cardColumn[row] getPrintableCardString]];
            card.rowInBoard = row;
            card.columnInBoard = column;
            card.cardListener = self;
            [temp addObject:card];
            [boardView addSubview:card];
            
        }
        [cards addObject:temp];
        column ++;
    }
}

- (void) initParameters {
    cards = [NSMutableArray array];
    emptyCards = [NSMutableArray array];
    isSelected = NO;
    isSelectMultiple = NO;
    clickedRow = -1;
    clickedColumn = -1;
    clickedFreeCellIndex = -1;
    clickedEmptyColumn = -1;
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"choicePicker"]) {
        ChoicePickerViewController *controller = [segue destinationController];
        controller.listener = self;
    }
}

- (void) onSingleCardMoveFromColumn:(int)columnFrom toColumn:(int)columnTo {
    CardView *movingCard = [cards[columnFrom] lastObject];
    [movingCard deselectCard];
    movingCard.columnInBoard = columnTo;
    movingCard.rowInBoard = (int) cards[columnTo].count;
    [cards[columnTo] addObject:movingCard];
    if (cards[columnTo].count > realignCardThreshold) {
        [self alignCardBasedOnRow:cards[columnTo] atColumn:columnTo];
    } else {
        [self alignCardNormal:cards[columnTo] atColumn:columnTo];
    }
    int previousCount = (int)cards[columnFrom].count;
    [cards[columnFrom] removeLastObject];
    if (previousCount > realignCardThreshold) {
        if (cards[columnFrom].count == realignCardThreshold) {
            [self alignCardNormal:cards[columnFrom] atColumn:columnFrom];
        } else {
            [self alignCardBasedOnRow:cards[columnTo] atColumn:columnTo];
        }
    }
}

- (void) onMultipleCardsMoveFromColumn:(int)columnFrom fromRow:(int)rowFrom toColumn:(int)columnTo {
    NSArray *temp = [cards[columnFrom] subarrayWithRange:NSMakeRange(rowFrom, cards[columnFrom].count - rowFrom)];
#if DEBUG_PRINT
    NSLog(@"length of card to move: %ld",temp.count);
#endif
    int previousCount = (int)cards[columnFrom].count;
    // move the card view first, then adjust the gap between cards
    for (int i = 0; i < temp.count; i ++) {
        CardView *view = temp[i];
        [view deselectCard];
        view.columnInBoard = columnTo;
        view.rowInBoard = (int)cards[columnTo].count;
        [view removeFromSuperview];
        [cards[columnTo] addObject:view];
        [cards[columnFrom] removeLastObject];
        
    }
    if (cards[columnTo].count > realignCardThreshold) {
        [self alignCardBasedOnRow:cards[columnTo] atColumn:columnTo];
    } else {
        [self alignCardNormal:cards[columnTo] atColumn:columnTo];
    }
    
    if (previousCount > realignCardThreshold) {
        if (cards[columnFrom].count <= realignCardThreshold) {
            [self alignCardNormal:cards[columnFrom] atColumn:columnFrom];
        } else {
            [self alignCardBasedOnRow:cards[columnFrom] atColumn:columnFrom];
        }
    }
}


- (void) onCardMoveFromColumn:(int)column toFreeCell:(int)index card:(NSString *)card{
    [tempCells[index] setImage:[NSImage imageNamed:card]];
    int previousCount = (int)cards[column].count;
    [[cards[column] lastObject] removeFromSuperview];
    [cards[column] removeLastObject];
    if (previousCount > realignCardThreshold) {
        if (cards[column].count == realignCardThreshold) {
            [self alignCardNormal:cards[column] atColumn:column];
        } else {
            [self alignCardBasedOnRow:cards[column] atColumn:column];
        }
    }
}

- (void) onCardMoveFromColumn:(int)columnFrom toCollectionIndex:(int)index card:(NSString *) card{
    [cells[index] setImage:[NSImage imageNamed:card]];
    [[cards[columnFrom] lastObject] removeFromSuperview];
    [cards[columnFrom] removeLastObject];
    if (cards[columnFrom].count > realignCardThreshold) {
        [self alignCardBasedOnRow:cards[columnFrom] atColumn:columnFrom];
    } else if (cards[columnFrom].count == realignCardThreshold){
        [self alignCardNormal:cards[columnFrom] atColumn:columnFrom];
    }
    [myGame deselectCard];
    
}

- (void) onIllegalMove {
    [self showIllegalMoveWarning];
}
@end
