//
//  ChoicePickerViewController.m
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/28.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import "ChoicePickerViewController.h"

@interface ChoicePickerViewController ()

@end

@implementation ChoicePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)onMoveSingleCardBtnClicked:(NSButton *)sender {
    [_listener onMoveSingleCardBtnClicked];
}
- (IBAction)onMoveCardsBtnClicked:(NSButton *)sender {
    [_listener onMoveWholeListBtnClicked];
}

- (void) mouseUp:(NSEvent *)event {
    [_listener onMouseClickedOnView];
}

@end
