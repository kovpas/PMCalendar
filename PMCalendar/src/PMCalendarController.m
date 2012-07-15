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

static CGSize defaultSize = (CGSize){240, 200};
CGFloat outerPadding = 0.0f;
NSString *kPMCalendarRedrawNotification = @"kPMCalendarRedrawNotification";

@interface PMCalendarController ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) PMCalendarBackgroundView *backgroundView;
@property (nonatomic, strong) PMCalendarView *calendarView;
@property (nonatomic, assign) CGPoint position;

@end

@implementation PMCalendarController

@synthesize position = _position;
@synthesize delegate = _delegate;

@dynamic period;
@dynamic allowedPeriod;
@dynamic mondayFirstDayOfWeek;

@synthesize allowsPeriodSelection = _allowsPeriodSelection;
@synthesize arrowDirection = _arrowDirection;

@synthesize view = _view;
@synthesize backgroundView = _backgroundView;
@synthesize calendarView = _calendarView;
@synthesize size = _size;

#pragma mark - object initializers -

- (void) initializeWithSize:(CGSize) size
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    self.backgroundView = [[PMCalendarBackgroundView alloc] initWithFrame:CGRectInset(self.view.frame, outerPadding, outerPadding)];
    self.backgroundView.clipsToBounds = NO;
    [self.view addSubview:self.backgroundView];
    
    self.calendarView = [[PMCalendarView alloc] initWithFrame:self.view.frame];
    self.calendarView.delegate = self;
    self.calendarView.period = [PMPeriod oneDayPeriodWithDate:[NSDate date]];
    [self.view addSubview:self.calendarView];
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
        permittedArrowDirections:(UIPopoverArrowDirection) arrowDirections
                        animated:(BOOL) animated
{
    [view addSubview:self.view];
}

- (void) fullRedraw
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMCalendarRedrawNotification 
                                                        object:nil];
}

#pragma mark - date/period management -

- (BOOL)mondayFirstDayOfWeek
{
    return self.calendarView.mondayFirstDayOfWeek;
}

- (void)setMondayFirstDayOfWeek:(BOOL)mondayFirstDayOfWeek
{
    self.calendarView.mondayFirstDayOfWeek = mondayFirstDayOfWeek;
}

- (PMPeriod *) period
{
    return self.calendarView.period;
}

- (void) setPeriod:(PMPeriod *) period
{
    self.calendarView.period = period;
}

- (PMPeriod *) allowedPeriod
{
    return self.calendarView.allowedPeriod;
}

- (void) setAllowedPeriod:(PMPeriod *)allowedPeriod
{
    self.calendarView.allowedPeriod = allowedPeriod;
}

#pragma mark - PMCalendarViewDelegate methods -

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
    numDaysInMonth         += (monthStartDay + (self.calendarView.mondayFirstDayOfWeek?5:6)) % 7;
    CGFloat height          = self.view.frame.size.height - outerPadding * 2;
    CGFloat vDiff           = (height - headerHeight - innerPadding.height * 2) / 7;
    CGRect frm              = CGRectInset(self.view.frame, outerPadding, outerPadding);
    int numberOfRows        = ceil((CGFloat)numDaysInMonth / 7.0f);
    frm.size.height         = (numberOfRows + 1) * vDiff + headerHeight + innerPadding.height * 2;
    
    self.backgroundView.frame = frm;
}

- (void)setSize:(CGSize)size
{
    CGRect frm = self.view.frame;
    frm.size = size;
    self.view.frame = frm;
    [self fullRedraw];
}

- (CGSize)size
{
    return self.view.frame.size;
}

@end
