//
//  ChoicePickerViewController.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/28.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ChoiceViewControllerBtnListener <NSObject>

- (void) onMoveSingleCardBtnClicked;

- (void) onMoveWholeListBtnClicked;

- (void) onMouseClickedOnView;

@end
@interface ChoicePickerViewController : NSViewController
@property id<ChoiceViewControllerBtnListener> listener;

@end

NS_ASSUME_NONNULL_END
