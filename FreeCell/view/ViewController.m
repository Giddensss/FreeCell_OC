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
    
    NSMutableArray <NSButton *>*tempCells;
    NSMutableArray <NSButton *>*cells;
    NSMutableArray <NSMutableArray <CardView *> *> *cards;
    AppDelegate *myDelegate;
    Game *myGame;
    
    BOOL isSelected;
    BOOL isSelectMultiple;
    int clickedRow;
    int clickedColumn;
    
}
@end
@implementation ViewController

- (id) initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        myDelegate = [NSApplication sharedApplication].delegate;
        myGame = myDelegate.myGame;
        cards = [NSMutableArray array];
        isSelected = NO;
        isSelectMultiple = NO;
        clickedRow = -1;
        clickedColumn = -1;
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
    
    // setup baord;
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

- (void) topCellBtnClicked:(NSButton *) sender {
    NSString *identifier = sender.accessibilityTitle;
    if ([identifier containsString:@"temp"]) {
        int index = [[identifier substringFromIndex:4] intValue];
#if DEBUG_PRINT
        NSLog(@"Click on temp cell %d",index);
#endif
        if (isSelected) {
            if ([myGame numberOfCardsAtColumn:clickedColumn] != clickedRow + 1) {
                [self showIllegalMoveWarning];
                [myGame deselectCard];
                // deselect all the cards
                [self deselectCardsAtColumn];
                isSelected = NO;
                clickedColumn = -1;
                clickedRow = -1;
                return;
            }
            BOOL flag = [myGame moveCardToTempCellAtColumn:clickedColumn toTempCellIndex:index];
            if (flag) {
                [[cards[clickedColumn] lastObject] removeFromSuperview];
                [cards[clickedColumn] removeLastObject];
                [tempCells[index] setImage:[NSImage imageNamed:[myGame getSelectedCard]]];
                [myGame deselectCard];
                clickedColumn = -1;
                clickedRow = -1;
                isSelected = NO;
            } else {
                [self showIllegalMoveWarning];
                [myGame deselectCard];
                [cards[clickedColumn][clickedRow] deselectCard];
                clickedColumn = -1;
                clickedRow = -1;
                isSelected = NO;
                return;
            }
        } else {
            
        }

    } else if ([identifier containsString:@"cell"]) {
        int index = [[identifier substringFromIndex:4] intValue];
#if DEBUG_PRINT
        NSLog(@"Click on cell %d",index);
#endif
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)indicatorClicked:(id)sender {
#if DEBUG_PRINT
    NSLog(@"Indicator Clicked");
#endif
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
    int column = cardPosition.x;
    int row = cardPosition.y;
    if (isSelected) {
        if (row == clickedRow && column == clickedColumn) {
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
            } else {
                // move single card
                if ([myGame moveSingleCardFromColumn:clickedColumn toColumn:column]) {
                    CardView *view = cards[clickedColumn][clickedRow];
                    CGFloat horizontal_gap = (boardView.frame.size.width - number_of_column * card_width ) / (number_of_column - 1);
                    CGFloat startY = boardView.frame.size.height - (card_height + (row + 1) * card_vertical_overlap_gap);
                    if (startY < 0) {
                        CGFloat verticalGap = (boardView.frame.size.height - card_height) / (row + 1);
                        for (int i = 0; i < cards[column].count; i++) {
                            [cards[column][i] setFrame:CGRectMake((horizontal_gap + card_width) * column,
                                                                  boardView.frame.size.height - (card_height + i  * verticalGap),
                                                                  card_width, card_height)];
                        }
                        [view setFrame:CGRectMake((horizontal_gap + card_width) * column,
                                                  boardView.frame.size.height - (card_height + (row + 1)  * verticalGap),
                                                  card_width, card_height)];
                        
                    } else {
                        [view setFrame:CGRectMake((horizontal_gap + card_width) * column,
                                                  startY,
                                                  card_width,
                                                  card_height)];
                    }
                    [cards[column] addObject:view];
                    [view removeFromSuperview];
                    [boardView addSubview:view positioned:NSWindowAbove relativeTo:cards[column][row]];
                    view.columnInBoard = column;
                    view.rowInBoard = row + 1;
                    isSelected = NO;
                    [myGame deselectCard];
                    [cards[clickedColumn][clickedRow] deselectCard];
                    [cards[clickedColumn] removeLastObject];
                    clickedRow = -1;
                    clickedColumn = -1;
                    return;
                }
                isSelected = NO;
                [myGame deselectCard];
                [cards[clickedColumn][clickedRow] deselectCard];
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
    clickedColumn= cardPosition.x;
    clickedRow = cardPosition.y;
}

- (void) onCardViewMouseRightUp:(CGPoint)cardPosition {
    clickedColumn = cardPosition.x;
    clickedRow = cardPosition.y;
}

- (void) onViewClicked:(int)column {
    
}

- (void) showIllegalMoveWarning {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Illega Move!"];
    [alert setInformativeText:@"You cannot place this card here!"];
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

@end