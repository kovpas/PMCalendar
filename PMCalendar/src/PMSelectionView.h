//
//  PMSelectionView.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * PMSelectionView is an internal class.
 *
 * PMSelectionView is a view which renders selection. 
 * start and end indexes are non-negative numbers. 0 is a left-top corner of a calendar. 
 */
@interface PMSelectionView : UIView

/**
 * Selection start index.
 */
@property (nonatomic, assign) NSUInteger startIndex;

/**
 * Selection end index.
 */
@property (nonatomic, assign) NSUInteger endIndex;

@end
