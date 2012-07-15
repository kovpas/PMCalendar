//
//  PMSelectionView.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMSelectionView : UIView

// -1 for startCell means that period starts on a previous screen
// NSIntegerMax for endCell means that period ends on a next screen
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger endIndex;

@end
