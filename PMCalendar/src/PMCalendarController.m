//
//  PMCalendarController.m
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMCalendarController.h"
#import "PMCalendarBackgroundView.h"
#import "PMCalendarView.h"
#import "PMPeriod.h"
#import "NSDate+Helpers.h"
#import "PMCalendarConstants.h"

static CGSize defaultSize = (CGSize){240, 180};
CGSize arrowSize = (CGSize){30, 15};
CGSize outerPadding = (CGSize){0, 0};
NSString *kPMCalendarRedrawNotification = @"kPMCalendarRedrawNotification";

@interface PMCalendarController ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *calendarView;
@property (nonatomic, strong) PMCalendarBackgroundView *backgroundView;
@property (nonatomic, strong) PMCalendarView *digitsView;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) PMCalendarArrowDirection calendarArrowDirection;

@end

@implementation PMCalendarController

@synthesize position = _position;
@synthesize delegate = _delegate;

@dynamic period;
@dynamic allowedPeriod;
@dynamic mondayFirstDayOfWeek;
@dynamic allowsPeriodSelection;
@dynamic allowsLongPressYearChange;

@synthesize calendarArrowDirection = _calendarArrowDirection;

@synthesize view = _view;
@synthesize calendarView = _calendarView;
@synthesize backgroundView = _backgroundView;
@synthesize digitsView = _digitsView;
@synthesize size = _size;

#pragma mark - object initializers -

- (void) initializeWithSize:(CGSize) size
{
    self.calendarArrowDirection = PMCalendarArrowDirectionUnknown;
    
    CGRect calendarRect = CGRectMake(0, 0, size.width, size.height);
    self.calendarView = [[UIView alloc] initWithFrame:calendarRect];
//    self.calendarView.backgroundColor = [UIColor blueColor];

    //Make insets from two sides of a calendar to have place for arrows
    CGRect calendarRectWithArrowInsets = CGRectMake(0, 0
                                                    , size.width + arrowSize.height
                                                    , size.height + arrowSize.height);
    self.view = [[UIView alloc] initWithFrame:calendarRectWithArrowInsets];
    
    self.backgroundView = [[PMCalendarBackgroundView alloc] initWithFrame:CGRectInset(calendarRectWithArrowInsets
                                                                                      , outerPadding.width
                                                                                      , outerPadding.height)];
    self.backgroundView.clipsToBounds = NO;
    [self.view addSubview:self.backgroundView];
    
    self.digitsView = [[PMCalendarView alloc] initWithFrame:CGRectInset(calendarRect
                                                                        , innerPadding.width
                                                                        , innerPadding.height)];
    self.digitsView.delegate = self;
    self.digitsView.period = [PMPeriod oneDayPeriodWithDate:[NSDate date]];    
//    self.digitsView.backgroundColor = [UIColor redColor];
    [self.calendarView addSubview:self.digitsView];
    self.calendarView.autoresizesSubviews = YES;
    [self.view addSubview:self.calendarView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.allowsPeriodSelection = YES;
    self.allowsLongPressYearChange = YES;
}

- (id) initWithSize:(CGSize) size
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    [self initializeWithSize: size];
    
    return self;
}

- (id) init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    [self initializeWithSize: defaultSize];
    
    return self;
}

#pragma mark - controller presenting methods -

- (void) presentCalendarFromRect:(CGRect) rect 
                          inView:(UIView *) view
        permittedArrowDirections:(PMCalendarArrowDirection) arrowDirections
                        animated:(BOOL) animated
{
    
    if (arrowDirections & PMCalendarArrowDirectionUp)
    {
        if (CGRectGetMidY(rect) + self.size.height + arrowSize.height <= view.bounds.size.height)
        {
            self.calendarArrowDirection = PMCalendarArrowDirectionUp;
        }
    }
    
    if ((_calendarArrowDirection == PMCalendarArrowDirectionUnknown) 
        && (arrowDirections & PMCalendarArrowDirectionLeft))
    {
        if (CGRectGetMidX(rect) + self.size.width + arrowSize.height <= view.bounds.size.width)
        {
            self.calendarArrowDirection = PMCalendarArrowDirectionLeft;
        }
    }

    if ((_calendarArrowDirection == PMCalendarArrowDirectionUnknown) 
        && (arrowDirections & PMCalendarArrowDirectionDown))
    {
        if (CGRectGetMidY(rect) - self.size.width - arrowSize.height >= 0)
        {
            self.calendarArrowDirection = PMCalendarArrowDirectionDown;
        }
    }

    if ((_calendarArrowDirection == PMCalendarArrowDirectionUnknown) 
        && (arrowDirections & PMCalendarArrowDirectionRight))
    {
        if (CGRectGetMidY(rect) - self.size.width - arrowSize.height >= 0)
        {
            self.calendarArrowDirection = PMCalendarArrowDirectionDown;
        }
    }
    
    if (_calendarArrowDirection == PMCalendarArrowDirectionUnknown) 
    {
        // TODO: check rect's quad and pick corresponding direction
        self.calendarArrowDirection = PMCalendarArrowDirectionDown;
    }
    
    CGRect frm = self.view.frame;
    CGPoint arrowPosition = CGPointZero;
    
    switch (_calendarArrowDirection)
    {
        case PMCalendarArrowDirectionUp:
            frm.origin = CGPointMake(0, arrowSize.height);
            arrowPosition.x = 150;//CGRectGetMidX(rect) - arrowSize.width / 2 - shadowPadding - cornerRadius;
            break;
        case PMCalendarArrowDirectionLeft:
            frm.origin = CGPointMake(arrowSize.height, 0);
            arrowPosition.y = 150;//CGRectGetMidX(rect) - arrowSize.width / 2 - shadowPadding - cornerRadius;
            break;
        case PMCalendarArrowDirectionDown:
        case PMCalendarArrowDirectionRight:
            frm.origin = CGPointMake(0, 0);
            arrowPosition.x = 150;//CGRectGetMidX(rect) - arrowSize.width / 2 - shadowPadding - cornerRadius;
            break;
        default:
            NSAssert(NO, @"arrow direction is not set! CAN'T BE! :)");
            break;
    }
    self.calendarView.frame = frm;
    
    if ((_calendarArrowDirection == PMCalendarArrowDirectionUp)
        || (_calendarArrowDirection == PMCalendarArrowDirectionDown))
    {
        arrowPosition.x = MIN(arrowPosition.x, frm.size.width - arrowSize.width - cornerRadius - shadowPadding);
        arrowPosition.x = MAX(arrowPosition.x, arrowSize.width / 2 + cornerRadius);
    }
    
    self.backgroundView.arrowPosition = arrowPosition;
    
    [view addSubview:self.view];
    
    if (animated)
    {
        self.view.alpha = 0;
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.view.alpha = 1;
                         }];
    }
}

- (void) dismissCalendarAnimated:(BOOL) animated
{
    if (!animated)
    {
        [self.view removeFromSuperview];
    }
    else {
        self.view.alpha = 1;
        
        [UIView animateWithDuration:0.2 
                         animations:^{
                             self.view.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self.view removeFromSuperview];
                         }];
    }
}

- (void) fullRedraw
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMCalendarRedrawNotification 
                                                        object:nil];
}

- (void)setCalendarArrowDirection:(PMCalendarArrowDirection)calendarArrowDirection
{
    self.backgroundView.arrowDirection = calendarArrowDirection;
    _calendarArrowDirection = calendarArrowDirection;
}

#pragma mark - date/period management -

- (BOOL)mondayFirstDayOfWeek
{
    return self.digitsView.mondayFirstDayOfWeek;
}

- (void)setMondayFirstDayOfWeek:(BOOL)mondayFirstDayOfWeek
{
    self.digitsView.mondayFirstDayOfWeek = mondayFirstDayOfWeek;
}

- (BOOL)allowsPeriodSelection
{
    return self.digitsView.allowsPeriodSelection;
}

- (void)setAllowsPeriodSelection:(BOOL)allowsPeriodSelection
{
    self.digitsView.allowsPeriodSelection = allowsPeriodSelection;
}

- (BOOL)allowsLongPressYearChange
{
    return self.digitsView.allowsLongPressYearChange;
}

- (void)setAllowsLongPressYearChange:(BOOL)allowsLongPressYearChange
{
    self.digitsView.allowsLongPressYearChange = allowsLongPressYearChange;
}

- (PMPeriod *) period
{
    return self.digitsView.period;
}

- (void) setPeriod:(PMPeriod *) period
{
    self.digitsView.period = period;
}

- (PMPeriod *) allowedPeriod
{
    return self.digitsView.allowedPeriod;
}

- (void) setAllowedPeriod:(PMPeriod *)allowedPeriod
{
    self.digitsView.allowedPeriod = allowedPeriod;
}

#pragma mark - PMdigitsViewDelegate methods -

- (void) periodChanged: (PMPeriod *)newPeriod
{
    if ([self.delegate respondsToSelector:@selector(calendarController:didChangePeriod:)])
    {
        [self.delegate calendarController:self didChangePeriod:[newPeriod normalizedPeriod]];
    }
}

- (void) currentDateChanged: (NSDate *)currentDate
{
	int numDaysInMonth      = [currentDate numberOfDaysInMonth];
    NSInteger monthStartDay = [[currentDate monthStartDate] weekday];
    numDaysInMonth         += (monthStartDay + (self.digitsView.mondayFirstDayOfWeek?5:6)) % 7;
    CGFloat height          = self.view.frame.size.height - outerPadding.height * 2 - arrowSize.height;
    CGFloat vDiff           = (height - headerHeight - innerPadding.height * 2) / 7;
    CGRect frm              = CGRectInset(self.view.frame, outerPadding.width, outerPadding.height);
    int numberOfRows        = ceil((CGFloat)numDaysInMonth / 7.0f);
    frm.size.height         = (int)((numberOfRows + 1) * vDiff + headerHeight + innerPadding.height * 2 + arrowSize.height);
    
    self.backgroundView.frame = frm;
    [self fullRedraw];
}

- (void)setSize:(CGSize)size
{
    CGRect frm = self.calendarView.frame;
    frm.size = size;
    self.calendarView.frame = frm;
    [self fullRedraw];
}

- (CGSize)size
{
    return self.calendarView.frame.size;
}

@end
