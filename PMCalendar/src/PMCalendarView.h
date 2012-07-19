//
//  PMCalendarView.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMPeriod;
@protocol PMCalendarViewDelegate;

/**
 * PMCalendarView is an internal class.
 *
 * PMCalendarView is a view which manages user's interactions - tap, pan and long press.
 * It also renders text (month, weekdays titles, days).
 */
@interface PMCalendarView : UIView <UIGestureRecognizerDelegate>

/**
 * Selected period. See PMCalendarController for more information.
 */
@property (nonatomic, strong) PMPeriod *period;

/**
 * Period allowed for selection. See PMCalendarController for more information.
 */
@property (nonatomic, strong) PMPeriod *allowedPeriod;

/**
 * Is monday a first day of week. See PMCalendarController for more information.
 */
@property (nonatomic, assign) BOOL mondayFirstDayOfWeek;

/**
 * Is period selection allowed. See PMCalendarController for more information.
 */
@property (nonatomic, assign) BOOL allowsPeriodSelection;

/**
 * Is long press allowed. See PMCalendarController for more information.
 */
@property (nonatomic, assign) BOOL allowsLongPressYearChange;
@property (nonatomic, assign) id<PMCalendarViewDelegate> delegate;

@end

@protocol PMCalendarViewDelegate <NSObject>

/**
 * Called on the delegate when user changes showed month.
 */
- (void) currentDateChanged: (NSDate *)currentDate;

/**
 * Called on the delegate when user changes selected period.
 */
- (void) periodChanged: (PMPeriod *)newPeriod;

@end
