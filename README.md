PMCalendar v0.3
==========

Yet another calendar component for iOS. Compatible with iOS 4.0 (iPhone &amp; iPad) and higher.

UI is inspired by [ocrickard](https://github.com/ocrickard)'s [OCCalendarController](https://github.com/ocrickard/OCCalendar). It's quite good component, but doesn't have some useful features which I wanted to see. Unfortunately [OCCalendarController](https://github.com/ocrickard/OCCalendar) very hard to maintain, so I decided to create my own implementation.

PMCalendar supports selection of multiple dates within one or several months, appears as a popover (if you used UIPopoverController before, you'll find PMCalendar management very similar), supports orientation changes out of the box and does not require any third party frameworks.

PMCalendar uses iOS' CoreGraphics and CoreText frameworks.

It's definitely not bug-free, so if you're going to use PMCalendar in production, please test it hard ;)

Feel free to concact me in case of any questions or suggestions. If you feel you know how to improve PMCalendar don't hesitate to contact me or send a pull request.

Legal
----------
PMCalendar is released under the MIT License.

Screenshots
----------
![Screenshot 1](http://github.com/kovpas/PMCalendar/raw/master/screenshots/screenshot_1.png)&nbsp;&nbsp;![Screenshot 2](http://github.com/kovpas/PMCalendar/raw/master/screenshots/screenshot_2.png)

![Screenshot 3](http://github.com/kovpas/PMCalendar/raw/master/screenshots/screenshot_3.png)

Usage
----------

 - Add PMCalendar directory to your Xcode project
 - Add CoreGraphics and CoreText frameworks to your project
 - #import "PMCalendar.h"
 - Create instance of PMCalendarController with specific theme name (see below) and size:

``` objective-c
        PMCalendarController *calendarController = [[PMCalendarController alloc] initWithThemeName:@"my super theme name" andSize:CGSizeMake(300, 200)];
```

 - Or use defaults:

``` objective-c
        // default theme name (default.plist) and size (see default.plist for details)
        PMCalendarController *calendarController = [[PMCalendarController alloc] init];
```

``` objective-c
        // default theme name (default.plist) and specific size
        PMCalendarController *calendarController = [[PMCalendarController alloc] initWithSize:CGSizeMake(300, 200)];
```

``` objective-c
        // specific theme name and default calendar size for this theme
        PMCalendarController *calendarController = [[PMCalendarController alloc] initWithThemeName:@"my super theme name"];
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
                                           isPopover:YES
                                            animated:YES];
```

 - Or CGRect:
 
``` objective-c
         [calendarController presentCalendarFromRect:CGRectMake(100, 100, 10, 10)
                                              inView:self.view
                            permittedArrowDirections:PMCalendarArrowDirectionUp | PMCalendarArrowDirectionLeft
                                           isPopover:YES
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

**Period allowed for selection**

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

**If YES, user can long press on arrow to fast iterate through months**

``` objective-c
    @property (nonatomic, assign) BOOL allowsLongPressMonthChange;
```

**Direction of the arrow (similar to UIPopoverController's arrowDirection)**

``` objective-c
    @property (nonatomic, readonly) PMCalendarArrowDirection arrowDirection;
```

**Size of a calendar controller**

``` objective-c
    @property (nonatomic, assign) CGSize size;
```

**Returns whether the popover is visible (presented) or not**

``` objective-c
    @property (nonatomic, assign, readonly, getter = isCalendarVisible) BOOL calendarVisible;
```

Themes (beta!)
----------

Themes allows you to create your own calendar component look without touching PMCalendar code. In theory... On practice current implementation is a compromise between flexibility and speed of drawing of the component. Therefore, some theme properties which you expect to be working does not work :).

However, current implementation is powerful enough to create for example something like this:

![Apple calendar theme 1](http://github.com/kovpas/PMCalendar/raw/master/screenshots/apple_theme_1.png)&nbsp;![Apple calendar theme 2](http://github.com/kovpas/PMCalendar/raw/master/screenshots/apple_theme_2.png)

Themes documentation is in progress, so for now please use two examples ("default.plist" and "apple calendar.plist") as a refernce.

If you wish to share theme you created for PMCalendar, please contact me, I'll add it together with a link to your project :).
