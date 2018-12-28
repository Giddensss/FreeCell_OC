//
//  ViewController.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/10/16.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WindowBackgroundView.h"
#import "CardView.h"
#import "EmptyCardView.h"
#import "ChoicePickerViewController.h"
@interface ViewController : NSViewController <MouseDirectionListener,CardViewClickListener,EmptyCardCellClickListener,ChoiceViewControllerBtnListener>


@end

