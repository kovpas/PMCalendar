//
//  PMCalendarController.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCalendarView.h"

@protocol PMCalendarControllerDelegate;
@class PMPeriod;

@interface PMCalendarController : NSObject <PMCalendarViewDelegate>

@property (nonatomic, assign) id<PMCalendarControllerDelegate> delegate;

@property (nonatomic, strong) PMPeriod *period;
@property (nonatomic, strong) PMPeriod *allowedPeriod;
@property (nonatomic, assign, getter = isMondayFirstDayOfWeek) BOOL mondayFirstDayOfWeek;

@property (nonatomic, assign) BOOL allowsPeriodSelection;
@property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;

- (void)presentCalendarFromRect:(CGRect) rect 
                         inView:(UIView *) view
       permittedArrowDirections:(UIPopoverArrowDirection) arrowDirections
                       animated:(BOOL) animated;

@end

@protocol PMCalendarControllerDelegate <NSObject>
@optional

- (BOOL)calendarControllerShouldDismissCalendar:(PMCalendarController *)calendarController;
- (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController;

@end
