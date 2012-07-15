PMCalendar
==========

Yet another calendar component for iOS. Compatible with iOS 4.0 (iPhone &amp; iPad) and higher.

UI is inspired by [ocrickard](https://github.com/ocrickard)'s [OCCalendarController](https://github.com/ocrickard/OCCalendar). It's quite good component, but doesn't have some useful features which I wanted to see. Unfortunately [OCCalendarController](https://github.com/ocrickard/OCCalendar) very hard to maintain, so I decided to make my own implementation.

What you see here is an alpha version, quite basic implementation of a calendar component.

Screenshots
----------
![Screenshot 1](PMCalendar/raw/master/screenshots/screenshot_1.png) ![Screenshot 2](PMCalendar/raw/master/screenshots/screenshot_2.png)

Usage
----------

 - Add PMCalendar directory to your Xcode project.
 - #import "PMCalendar.h"
 - Create instance of PMCalendarController:

        PMCalendarController *calendarController = [[PMCalendarController alloc] init];
 - Implement PMCalendarControllerDelegate methods to be aware of controller's state change:

        /*TBI*/ - (BOOL)calendarControllerShouldDismissCalendar:(PMCalendarController *)calendarController;
        /*TBI*/ - (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController;
        - (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod;
 - Don't forget to assign delegate!

        calendarController.delegate = self;

 - Present calendarController:

         [calendarController presentCalendarFromRect:CGRectZero // TBI
                                              inView:self.view
                            permittedArrowDirections:0          // TBI
                                            animated:YES];

 - Dismiss it:

         [calendarController dismissAnimated:YES];

PMPeriod
----------

    @interface PMPeriod : NSObject

    @property (nonatomic, strong) NSDate *startDate;
    @property (nonatomic, strong) NSDate *endDate;

    /**
     * Creates new period with same startDate and endDate
     */
    + (id) oneDayPeriodWithDate:(NSDate *) date;

    + (id) periodWithStartDate:(NSDate *) startDate endDate:(NSDate *) endDate;

    - (NSInteger) lengthInDays;

    /**
     * Creates new period from self with proper order of startDate and endDate.
     */
    - (PMPeriod *) normalizedPeriod;

    @end

Implemented properties
----------
    @property (nonatomic, assign) id<PMCalendarControllerDelegate> delegate;

**Selected period**

    @property (nonatomic, strong) PMPeriod *period;

*TBI!* **Period allowed for selection**

    @property (nonatomic, strong) PMPeriod *allowedPeriod;

**Monday is a first day of week. If NO then Sunday is a first day**

    @property (nonatomic, assign, getter = isMondayFirstDayOfWeek) BOOL mondayFirstDayOfWeek;

 **If NO, only one date can be selected. Otherwise, user can pan to select period**

    @property (nonatomic, assign) BOOL allowsPeriodSelection;

 **If YES, user can long press on arrow to iterate through years (single tap iterates through months)**

    @property (nonatomic, assign) BOOL allowsLongPressYearChange;

*TBI!* **Direction of the arrow (similar to UIPopoverController's arrowDirection)**

    @property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;

 **Size of a calendar controller**

    @property (nonatomic, assign) CGSize size;