PMCalendar
==========

Yet another calendar component for iOS. Compatible with iOS 4.0 (iPhone &amp; iPad) and higher.

UI is inspired by [ocrickard](https://github.com/ocrickard)'s [OCCalendarController](https://github.com/ocrickard/OCCalendar). It's quite good component, but doesn't have some useful features which I wanted to see. Unfortunately [OCCalendarController](https://github.com/ocrickard/OCCalendar) very hard to maintain, so I decided to create my own implementation.

PMCalendar supports selection of multiple dates within one or several months, appears as a popover (if you used UIPopoverController before, you'll find PMCalendar management very similar), supports orientation changes and does not require any third party frameworks.

Screenshots
----------
![Screenshot 1](PMCalendar/raw/master/screenshots/screenshot_1.png)&nbsp;&nbsp;![Screenshot 2](PMCalendar/raw/master/screenshots/screenshot_2.png)
![Screenshot 3](PMCalendar/raw/master/screenshots/screenshot_3.png)

Usage
----------

 - Add PMCalendar directory to your Xcode project.
 - #import "PMCalendar.h"
 - Create instance of PMCalendarController with wanted size:

        PMCalendarController *calendarController = [[PMCalendarController alloc] initWithSize:CGSizeMake(300, 200)];
 - Or use default:

        PMCalendarController *calendarController = [[PMCalendarController alloc] init];
 - Implement PMCalendarControllerDelegate methods to be aware of controller's state change:

        - (BOOL)calendarControllerShouldDismissCalendar:(PMCalendarController *)calendarController;
        - (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController;
        - (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod;
 - Don't forget to assign delegate!

        calendarController.delegate = self;
 - Present calendarController from a view (i.e. UIButton), so calendar could position itself during rotation:

         [calendarController presentCalendarFromView:pressedButton
                            permittedArrowDirections:PMCalendarArrowDirectionUp | PMCalendarArrowDirectionLeft
                                            animated:YES];
 - Or CGRect:
 
         [calendarController presentCalendarFromRect:CGRectMake(100, 100, 10, 10)
                                              inView:self.view
                            permittedArrowDirections:PMCalendarArrowDirectionUp | PMCalendarArrowDirectionLeft
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

**Monday is a first day of week. If set to NO then Sunday is a first day**

    @property (nonatomic, assign, getter = isMondayFirstDayOfWeek) BOOL mondayFirstDayOfWeek;

**If NO, only one date can be selected. Otherwise, user can pan to select period**

    @property (nonatomic, assign) BOOL allowsPeriodSelection;

**If YES, user can long press on arrow to iterate through years (single tap iterates through months)**

    @property (nonatomic, assign) BOOL allowsLongPressYearChange;

**Direction of the arrow (similar to UIPopoverController's arrowDirection)**

    @property (nonatomic, readonly) UIPopoverArrowDirection arrowDirection;

**Size of a calendar controller**

    @property (nonatomic, assign) CGSize size;