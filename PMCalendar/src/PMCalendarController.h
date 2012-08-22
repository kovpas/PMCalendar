//
//  PMCalendarController.h
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCalendarView.h"
#import "PMCalendarConstants.h"

@protocol PMCalendarControllerDelegate;
@class PMPeriod;

/**
 * !v0.1 is ARC only!
 * Yet another calendar component for iOS. Compatible with iOS 4.0 (iPhone & iPad) and higher.
 * 
 * PMCalendarController appears as a popover (if you used UIPopoverController before,
 * you'll find PMCalendar management very similar), supports orientation changes 
 * and does not require any third party frameworks.
 *
 * PMCalendar supports selection of multiple dates within one or several months. To select date
 * on a next or previous month, just press on a desired start date and move finger to the edge 
 * of the calendar. In 0.5 of a second the calendar will start to iterate through months automatically.
 */
@interface PMCalendarController : UIViewController <PMCalendarViewDelegate>

/**
 * Creates calendar controller with given size. Arrow is NOT includeed in this size.
 * You can also create PMCalendarController with -init method, it invokes -initWithSize: with default size.
 */
- (id) initWithSize:(CGSize) size;

/**
 * Creates calendar controller with given theme name.
 * This method gets default calendar size from theme and invokes -initWithSize:.
 */
- (id) initWithThemeName:(NSString *) themeName;

/**
 * Creates calendar controller with given theme name and specified size.
 */
- (id) initWithThemeName:(NSString *) themeName andSize:(CGSize) size;

/**
 * Allows you to present a calendar from a rect in a particular view.
 * "arrowDirections" is a bitfield which specifies what arrow directions are allowed
 * when laying out the calendar.
 * If "isPopover" is set to YES, calendar will be presented with dimming view below it,
 * which invokes delegate's "shouldDismiss" and "didDismiss" by tapping on it.
 * "isPopover" is particulary handy for calendars like apple's calendar from Calendar.app
 * which couldn't be dismissed and alows interaction below it.
 */
- (void)presentCalendarFromRect:(CGRect) rect
                         inView:(UIView *) view
       permittedArrowDirections:(PMCalendarArrowDirection) arrowDirections
                      isPopover:(BOOL) isPopover
                       animated:(BOOL) animated;

/**
 * Like the above, but is a convenience for presentation from a "UIView" instance.
 * This allows to calculate position of the calendar during rotation, so it positions itself properly.
 */
- (void)presentCalendarFromView:(UIView *) anchorView
       permittedArrowDirections:(PMCalendarArrowDirection) arrowDirections
                      isPopover:(BOOL) isPopover
                       animated:(BOOL) animated;

/**
 * Called to dismiss the calendar programmatically.
 * The delegate method for "shouldDismiss" is not called when the calendar is dismissed in this way.
 * But the delegate method for "didDismiss" is called.
 *
 * The calendar can also be dismissed by tapping on a dimming view, surrounding it.
 * In that case first "shouldDismiss" method of a delegate is called to check if dismissing is allowed.
 */
- (void) dismissCalendarAnimated:(BOOL) animated;

@property (nonatomic, assign) id<PMCalendarControllerDelegate> delegate;

/**
 * Currently selected period. Could be a real period or a "one-day" (-[PMPeriod oneDayPeriodWithDate:])
 * period which effectively selects one day.
 */
@property (nonatomic, strong) PMPeriod *period;

/**
 * Reflects PMPeriod allowed to select from.
 * This also limits user's iteration.
 *
 * I.e. if allowed period is set to 23.02.2001 - 19.08.2020, user will not be able to see
 * dates before 01.02.2001 and after 31.08.2020.
 */
@property (nonatomic, strong) PMPeriod *allowedPeriod;

/**
 * If set to YES, monday is used as a starting day of week. If NO, Sunday.
 */
@property (nonatomic, assign, getter = isMondayFirstDayOfWeek) BOOL mondayFirstDayOfWeek;

/**
 * If set to YES, the calendar allows to pan to select period.
 * If set to NO, only one day can be selected.
 */
@property (nonatomic, assign) BOOL allowsPeriodSelection;

/**
 * If set to YES, the calendar allows to long press on a month change arrow
 * in order to fast iterate through months.
 * If set to NO, long press does nothing.
 */
@property (nonatomic, assign) BOOL allowsLongPressMonthChange;

/**
 * Returns the direction the arrow is pointing on a presented calendar. 
 * Before presentation, this returns PMCalendarArrowDirectionUnknown.
 */
@property (nonatomic, readonly) PMCalendarArrowDirection calendarArrowDirection;

/** 
 * This property allows direction manipulation of the content size of the calendar.
 * TBI: method for animated change of size, limitation on minimal controller size.
 */
@property (nonatomic, assign) CGSize size;

/**
 * Returns whether the popover is visible (presented) or not.
 */
@property (nonatomic, assign, readonly, getter = isCalendarVisible) BOOL calendarVisible;

@end

@protocol PMCalendarControllerDelegate <NSObject>

@optional

/**
 * Called on the delegate when the celendar controller will dismiss the popover.
 * Return NO to prevent the dismissal.
 *
 * This method is not called when -dismissCalendarAnimated: is called directly.
 */
- (BOOL)calendarControllerShouldDismissCalendar:(PMCalendarController *)calendarController;

/**
 * Called on the delegate right after calendar controller removes itself from a superview.
 */
- (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController;

/**
 * Called on the delegate when the calendar's selected period changed.
 */
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod;

@end

@interface PMCalendarController (PMCalendarControllerDeprecated)

/**
 * Allows you to present a calendar from a rect in a particular view.
 * "arrowDirections" is a bitfield which specifies what arrow directions are allowed
 * when laying out the calendar.
 */
- (void)presentCalendarFromRect:(CGRect) rect
                         inView:(UIView *) view
       permittedArrowDirections:(PMCalendarArrowDirection) arrowDirections
                       animated:(BOOL) animated;

/**
 * Like the above, but is a convenience for presentation from a "UIView" instance.
 * This allows to calculate position of the calendar during rotation, so it positions itself properly.
 */
- (void)presentCalendarFromView:(UIView *) anchorView
       permittedArrowDirections:(PMCalendarArrowDirection) arrowDirections
                       animated:(BOOL) animated;

@end
