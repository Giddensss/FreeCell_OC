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
#import "CardView.h"

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
    
    NSMutableArray *tempCells;
    NSMutableArray *cells;
    NSMutableArray <NSMutableArray <CardView *> *> *cards;
    AppDelegate *myDelegate;
    Game *myGame;
    
}
@end
@implementation ViewController

- (id) initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        myDelegate = [NSApplication sharedApplication].delegate;
        myGame = myDelegate.myGame;
        cards = [NSMutableArray array];
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
            CardView *card = [[CardView alloc] initWithFrame:CGRectMake((horizontal_gap + card_width) * column,
                                                                        boardView.frame.size.height - (card_height + row * card_vertical_overlap_gap),
                                                                        card_width,
                                                                        card_height)];
            [card setCardViewWithValue:[cardColumn[row] getValue] suit:[cardColumn[row] getSuit] title:[cardColumn[row] getPrintableCardString]];
            card.rowInBoard = row;
            card.columnInBoard = column;
            [temp addObject:card];
            [boardView addSubview:card];
        }
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



@end
