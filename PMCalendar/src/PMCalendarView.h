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

@interface PMCalendarView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) PMPeriod *period;
@property (nonatomic, strong) PMPeriod *allowedPeriod;
@property (nonatomic, assign) BOOL mondayFirstDayOfWeek;
@property (nonatomic, assign) id<PMCalendarViewDelegate> delegate;

@end

@protocol PMCalendarViewDelegate <NSObject>

- (void) currentDateChanged: (NSDate *)currentDate;

@end
