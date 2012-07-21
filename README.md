PMCalendar v0.1
==========

Yet another calendar component for iOS. Compatible with iOS 4.0 (iPhone &amp; iPad) and higher.

UI is inspired by [ocrickard](https://github.com/ocrickard)'s [OCCalendarController](https://github.com/ocrickard/OCCalendar). It's quite good component, but doesn't have some useful features which I wanted to see. Unfortunately [OCCalendarController](https://github.com/ocrickard/OCCalendar) very hard to maintain, so I decided to create my own implementation.

PMCalendar supports selection of multiple dates within one or several months, appears as a popover (if you used UIPopoverController before, you'll find PMCalendar management very similar), supports orientation changes and does not require any third party frameworks.

It's definitely not bug-free, so if you're going to use PMCalendar in production, please test it hard ;)

Screenshots
----------
![Screenshot 1](PMCalendar/raw/master/screenshots/screenshot_1.png)&nbsp;&nbsp;![Screenshot 2](PMCalendar/raw/master/screenshots/screenshot_2.png)

![Screenshot 3](PMCalendar/raw/master/screenshots/screenshot_3.png)

Usage
----------

 - Add PMCalendar directory to your Xcode project.
 - #import "PMCalendar.h"
 - Create instance of PMCalendarController with wanted size:

``` objective-c
        PMCalendarController *calendarController = [[PMCalendarController alloc] initWithSize:CGSizeMake(300, 200)];
```

 - Or use default:

``` objective-c
        PMCalendarController *calendarController = [[PMCalendarController alloc] init];
```

- Implement PMCalendarControllerDelegate methods to be aware of controller's state change:

``` objective-c
        - (BOOL)calendarControllerShouldDismissCalendar:(PMCalendarController *)calendarController;
        - (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController;
        - (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod;
```

 - Don't forget to assign delegate!

``` objective-c
        calendarController.delegate = self;
```

 - Present calendarController from a view (i.e. UIButton), so calendar could position itself during rotation:

``` objective-c
         [calendarController presentCalendarFromView:pressedButton
                            permittedArrowDirections:PMCalendarArrowDirectionUp | PMCalendarArrowDirectionLeft
                                            animated:YES];
```

 - Or CGRect:
 
``` objective-c
         [calendarController presentCalendarFromRect:CGRectMake(100, 100, 10, 10)
                                              inView:self.view
                            permittedArrowDirections:PMCalendarArrowDirectionUp | PMCalendarArrowDirectionLeft
                                            animated:YES];
```

 - Dismiss it:

``` objective-c
         [calendarController dismissAnimated:YES];
```

PMPeriod
----------

``` objective-c
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
```

Implemented properties
----------

``` objective-c
    @property (nonatomic, assign) id<PMCalendarControllerDelegate> delegate;
```

**Selected period**

``` objective-c
    @property (nonatomic, strong) PMPeriod *period;
```

*TBI!* **Period allowed for selection**

``` objective-c
    @property (nonatomic, strong) PMPeriod *allowedPeriod;
```

**Monday is a first day of week. If set to NO then Sunday is a first day**

``` objective-c
    @property (nonatomic, assign, getter = isMondayFirstDayOfWeek) BOOL mondayFirstDayOfWeek;
```

**If NO, only one date can be selected. Otherwise, user can pan to select period**

``` objective-c
    @property (nonatomic, assign) BOOL allowsPeriodSelection;
```

**If YES, user can long press on arrow to iterate through years (single tap iterates through months)**

``` objective-c
    @property (nonatomic, assign) BOOL allowsLongPressYearChange;
```

**Direction of the arrow (similar to UIPopoverController's arrowDirection)**

``` objective-c
    @property (nonatomic, readonly) UIPopoverArrowDirection arrowDirection;
```

**Size of a calendar controller**

``` objective-c
    @property (nonatomic, assign) CGSize size;
```

Themes (pre-alpha! :))
----------
You can play around with themes by enabling MIMIC_APPLE_THEME define in PMCalendarDemo-Prefix.pch.

I'll add documentation as soon as the feature is ready.

By setting up custom theme you can get something like this:

![Apple calendar theme 1](PMCalendar/raw/master/screenshots/apple_theme_1.png)&nbsp;![Apple calendar theme 2](PMCalendar/raw/master/screenshots/apple_theme_2.png)
