//
//  EmptyCardView.h
//  FreeCell
//
//  Created by Alan L  Hamilton on 2018/12/23.
//  Copyright © 2018 Alan L  Hamilton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol EmptyCardCellClickListener <NSObject>

- (void) onViewClicked:(int) column;

@end
@interface EmptyCardView : NSView
@property int column;
@property id<EmptyCardCellClickListener> clickListener;
@end

NS_ASSUME_NONNULL_END
