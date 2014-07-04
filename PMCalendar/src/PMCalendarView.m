//
//  PMCalendarView.m
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMCalendarView.h"
#import "PMPeriod.h"
#import "PMCalendarConstants.h"
#import "NSDate+Helpers.h"
#import "PMSelectionView.h"
#import "PMTheme.h"
#import "PMThemeEngine.h"

@interface PMDaysView : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSDate *currentDate; // month to show
@property (nonatomic, strong) PMPeriod *selectedPeriod;
@property (nonatomic, strong) NSArray *rects;
@property (nonatomic, assign) BOOL mondayFirstDayOfWeek;
@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, assign) BOOL showOnlyCurrentMonth;
@property (nonatomic, unsafe_unretained) PMCalendarView *calendarView;

- (void) redrawComponent;

@end

@interface PMCalendarView ()

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) NSTimer *longPressTimer;
@property (nonatomic, strong) NSTimer *panTimer;
@property (nonatomic, assign) CGPoint panPoint;
@property (nonatomic, strong) PMDaysView *daysView;
@property (nonatomic, strong) PMSelectionView *selectionView;
@property (nonatomic, assign) CGRect initialFrame;

- (NSInteger) indexForDate: (NSDate *)date;
- (NSDate *) dateForPoint: (CGPoint)point;

@end

@implementation PMCalendarView
{
    NSInteger currentMonth;
    NSInteger currentYear;
    CGRect leftArrowRect;
    CGRect rightArrowRect;
    NSInteger fontSize;
}

@synthesize period = _period;
@synthesize allowedPeriod = _allowedPeriod;
@synthesize mondayFirstDayOfWeek = _mondayFirstDayOfWeek;
@synthesize currentDate = _currentDate;
@synthesize delegate = _delegate;
@synthesize font = _font;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize longPressGestureRecognizer = _longPressGestureRecognizer;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize longPressTimer = _longPressTimer;
@synthesize panTimer = _panTimer;
@synthesize panPoint = _panPoint;
@synthesize daysView = _daysView;
@synthesize selectionView = _selectionView;
@synthesize allowsPeriodSelection = _allowsPeriodSelection;
@synthesize allowsLongPressMonthChange = _allowsLongPressMonthChange;
@synthesize initialFrame = _initialFrame;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }
    self.initialFrame = frame;

    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mondayFirstDayOfWeek = NO;
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandling:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    self.tapGestureRecognizer.numberOfTouchesRequired = 1;
    self.tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.tapGestureRecognizer];

    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandling:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.allowsLongPressMonthChange = YES;

    self.selectionView = [[PMSelectionView alloc] initWithFrame:CGRectInset(self.bounds, -kPMThemeInnerPadding.width, -kPMThemeInnerPadding.height)];
    [self addSubview:self.selectionView];

    self.daysView = [[PMDaysView alloc] initWithFrame:self.bounds];
   
    self.daysView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.daysView.calendarView = self;
    [self addSubview:self.daysView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redrawComponent)
                                                 name:kPMCalendarRedrawNotification
                                               object:nil];
    
    return self;
}

- (void)setDisplayCurrentMonthOnly {
    self.daysView.showOnlyCurrentMonth = self.showOnlyCurrentMonth;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)redrawComponent
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *dayTitles = [dateFormatter shortStandaloneWeekdaySymbols];
    NSArray *monthTitles = [dateFormatter standaloneMonthSymbols];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat headerHeight = kPMThemeHeaderHeight;
    UIEdgeInsets shadowPadding = kPMThemeShadowPadding;

    CGFloat width = _initialFrame.size.width + shadowPadding.left + shadowPadding.right;
    CGFloat height = _initialFrame.size.height;
    CGFloat hDiff  = width / 7;
    CGFloat vDiff  = (height - headerHeight) / (kPMThemeDayTitlesInHeaderIntOffset + 5);
    
    UIFont *dayFont = [[[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeFontGenericType
                                                                      subtype:PMThemeMainSubtype
                                                                         type:PMThemeDayTitlesElementType] pmThemeGenerateFont];
    UIFont *monthFont = [[[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeFontGenericType
                                                                      subtype:PMThemeMainSubtype
                                                                         type:PMThemeMonthTitleElementType] pmThemeGenerateFont];

    for (int i = 0; i < dayTitles.count; i++) 
    {
        NSInteger index = i + (_mondayFirstDayOfWeek?1:0);
        index = index % 7;
        NSString *dayTitle = [dayTitles objectAtIndex:index];
        //// dayHeader Drawing

        NSAssert(dayFont != nil, @"Please provide proper font either in theme file or in a code.");
        
        CGSize sz = CGSizeZero;
        if(dayFont)
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                
                sz = [dayTitle sizeWithAttributes:@{NSFontAttributeName:dayFont}];
            }
            else {
                sz = [dayTitle sizeWithFont:dayFont constrainedToSize:(CGSize){width, CGFLOAT_MAX}];
            }
        }
        
        CGRect dayHeaderFrame = CGRectMake(floor(i * hDiff) - 1
                                           , headerHeight + (kPMThemeDayTitlesInHeaderIntOffset * vDiff - sz.height) / 2
                                           , hDiff
                                           , sz.height);

        [[PMThemeEngine sharedInstance] drawString:dayTitle
                                          withFont:dayFont
                                            inRect:dayHeaderFrame
                                    forElementType:PMThemeDayTitlesElementType
                                           subType:PMThemeMainSubtype
                                         inContext:context];
    }
    
    int month = currentMonth;
    int year = currentYear;

    
	NSString *monthTitle = [NSString stringWithFormat:@"%@ %d", [monthTitles objectAtIndex:(month - 1)], year];
    //// Month Header Drawing
    //[monthTitle sizeWithFont:monthFont]
    
    CGSize monthTitleSize;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        monthTitleSize = [monthTitle sizeWithAttributes:@{NSFontAttributeName:monthFont}];
        
    } else {
        
        monthTitleSize = [monthTitle sizeWithFont:monthFont];
    }
    
    CGRect textFrame = CGRectMake(0
                                  , (headerHeight - monthTitleSize.height) / 2
                                  , width
                                  , monthFont.pointSize);
    
    [[PMThemeEngine sharedInstance] drawString:monthTitle
                                      withFont:monthFont
                                        inRect:textFrame
                                forElementType:PMThemeMonthTitleElementType
                                       subType:PMThemeMainSubtype
                                     inContext:context];
    
    
    NSDictionary *arrowSizeDict = [[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeSizeGenericType
                                                                               subtype:PMThemeMainSubtype
                                                                                  type:PMThemeMonthArrowsElementType];

    NSDictionary *arrowOffsetDict = [[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeOffsetGenericType
                                                                                 subtype:PMThemeMainSubtype
                                                                                    type:PMThemeMonthArrowsElementType];
    
    CGSize arrowSize = [arrowSizeDict pmThemeGenerateSize];
    CGSize arrowOffset = [arrowOffsetDict pmThemeGenerateSize];
    BOOL showsLeftArrow = YES;
    BOOL showsRightArrow = YES;
    
    if(self.showOnlyCurrentMonth)
    {
        showsLeftArrow = NO;
        showsRightArrow = NO;
        [self setAllowsLongPressMonthChange:NO];
    }
    else if (self.allowedPeriod)
    {
        if ([[_currentDate dateByAddingMonths:-1] isBefore:[self.allowedPeriod.startDate monthStartDate]])
        {
            showsLeftArrow = NO;
        }
        else if ([[_currentDate dateByAddingMonths:1] isAfter:self.allowedPeriod.endDate])
        {
            showsRightArrow = NO;
        }
    }

    if (showsLeftArrow)
    {
        //// backArrow Drawing
        UIBezierPath* backArrowPath = [UIBezierPath bezierPath];
        [backArrowPath moveToPoint: CGPointMake(hDiff / 2
                                                , headerHeight / 2)]; // left-center corner
        [backArrowPath addLineToPoint: CGPointMake(arrowSize.width + hDiff / 2
                                                   , headerHeight / 2 + arrowSize.height / 2)]; // right-bottom corner
        [backArrowPath addLineToPoint: CGPointMake( arrowSize.width + hDiff / 2
                                                   ,  headerHeight / 2 - arrowSize.height / 2)]; // right-top corner
        [backArrowPath addLineToPoint: CGPointMake( hDiff / 2
                                                   ,  headerHeight / 2)];  // back to left-center corner
        [backArrowPath closePath];
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(arrowOffset.width - shadowPadding.left
                                                                       , arrowOffset.height);
        [backArrowPath applyTransform:transform];

        [[PMThemeEngine sharedInstance] drawPath:backArrowPath
                                  forElementType:PMThemeMonthArrowsElementType
                                         subType:PMThemeMainSubtype
                                       inContext:context];
        leftArrowRect = CGRectInset(backArrowPath.bounds, -20, -20);
    }

    if (showsRightArrow)
    {
        //// forwardArrow Drawing
        UIBezierPath* forwardArrowPath = [UIBezierPath bezierPath];
        [forwardArrowPath moveToPoint: CGPointMake( width - hDiff / 2
                                                   ,  headerHeight / 2)]; // right-center corner
        [forwardArrowPath addLineToPoint: CGPointMake( -arrowSize.width + width - hDiff / 2
                                                      , headerHeight / 2 + arrowSize.height / 2)];  // left-bottom corner
        [forwardArrowPath addLineToPoint: CGPointMake(-arrowSize.width + width - hDiff / 2
                                                       , headerHeight / 2 - arrowSize.height / 2)]; // left-top corner
        [forwardArrowPath addLineToPoint: CGPointMake( width - hDiff / 2
                                                      , headerHeight / 2)]; // back to right-center corner
        [forwardArrowPath closePath];
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-arrowOffset.width - shadowPadding.left, arrowOffset.height);
        [forwardArrowPath applyTransform:transform];

        [[PMThemeEngine sharedInstance] drawPath:forwardArrowPath
                                  forElementType:PMThemeMonthArrowsElementType
                                         subType:PMThemeMainSubtype
                                       inContext:context];
        rightArrowRect = CGRectInset(forwardArrowPath.bounds, -20, -20);
    }
}

- (void) setCurrentDate:(NSDate *)currentDate
{
    if (self.allowedPeriod)
    {
        if (([currentDate isBefore:[self.allowedPeriod.startDate monthStartDate]])
            || ([currentDate isAfter:self.allowedPeriod.endDate]))
        {
            return;
        }
    }
    
    _currentDate = [currentDate monthStartDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *eComponents = [gregorian components:NSDayCalendarUnit
                                                             | NSMonthCalendarUnit
                                                             | NSYearCalendarUnit
                                                 fromDate:_currentDate];
    
    BOOL needsRedraw = NO;
    
    if([eComponents month] != currentMonth) 
    {
        currentMonth = [eComponents month];
        needsRedraw = YES;
    }
    if([eComponents year] != currentYear) 
    {
        currentYear = [eComponents year];
        needsRedraw = YES;
    }
    
    if (needsRedraw)
    {
        self.daysView.currentDate = currentDate;
        [self setNeedsDisplay];
        [self periodUpdated];
        if ([_delegate respondsToSelector:@selector(currentDateChanged:)])
        {
            [_delegate currentDateChanged:currentDate];
        }
    }
}

- (void)setMondayFirstDayOfWeek:(BOOL)mondayFirstDayOfWeek
{
    if (_mondayFirstDayOfWeek != mondayFirstDayOfWeek)
    {
        _mondayFirstDayOfWeek = mondayFirstDayOfWeek;
        self.daysView.mondayFirstDayOfWeek = mondayFirstDayOfWeek;
        [self setNeedsDisplay];
        [self periodUpdated];
        
        // Ugh... TODO: make other components redraw in more acceptable way
        if ([_delegate respondsToSelector:@selector(currentDateChanged:)])
        {
            [_delegate currentDateChanged:_currentDate];
        }
    }
}

- (UIFont *) font
{
    NSInteger newFontSize = _initialFrame.size.width / 20;
    if (!_font || fontSize == 0 || fontSize != newFontSize)
    {
        _font = [UIFont fontWithName: @"Helvetica" size: newFontSize];
        self.daysView.font = _font;
        fontSize = newFontSize;
    }
    return _font;
}

- (void) periodUpdated
{
    NSInteger index = [self indexForDate:_period.startDate];
    NSInteger length = [_period lengthInDays];
    
    int numDaysInMonth      = [_currentDate numberOfDaysInMonth];
    NSDate *monthStartDate  = [_currentDate monthStartDate];
    NSInteger monthStartDay = [monthStartDate weekday];
    monthStartDay           = (monthStartDay + (self.mondayFirstDayOfWeek?5:6)) % 7;
    numDaysInMonth         += monthStartDay;
    int maxNumberOfCells    = ceil((CGFloat)numDaysInMonth / 7) * 7 - 1;

    NSInteger endIndex = -1;
    NSInteger startIndex = -1;
    if (index <= maxNumberOfCells || index + length <= maxNumberOfCells)
    {
        endIndex = MIN( maxNumberOfCells, index + length );
        startIndex = MIN( maxNumberOfCells, index );
    }

    [self.selectionView setStartIndex:startIndex];
    [self.selectionView setEndIndex:endIndex];
    self.daysView.selectedPeriod = _period;
    [self.daysView redrawComponent];
}

- (void)setAllowedPeriod:(PMPeriod *)allowedPeriod
{
    if (allowedPeriod != _allowedPeriod)
    {
        _allowedPeriod = allowedPeriod;
        _allowedPeriod.startDate = [_allowedPeriod.startDate midnightDate];
        _allowedPeriod.endDate = [_allowedPeriod.endDate midnightDate];
    }
}

- (void)setPeriod:(PMPeriod *)period
{
    PMPeriod *localPeriod = [period copy];
    if (self.allowedPeriod)
    {
        if ([localPeriod.startDate isBefore:self.allowedPeriod.startDate])
        {
            localPeriod.startDate = self.allowedPeriod.startDate;
        }
        else if ([localPeriod.startDate isAfter:self.allowedPeriod.endDate])
        {
            localPeriod.startDate = self.allowedPeriod.endDate;
        }

        if ([localPeriod.endDate isBefore:self.allowedPeriod.startDate])
        {
            localPeriod.endDate = self.allowedPeriod.startDate;
        }
        else if ([localPeriod.endDate isAfter:self.allowedPeriod.endDate])
        {
            localPeriod.endDate = self.allowedPeriod.endDate;
        }
    }

    if (![_period isEqual:localPeriod])
    {
        _period = localPeriod;
        
        if (!_currentDate)
        {
            self.currentDate = period.startDate;
        }
        
        if ([self.delegate respondsToSelector:@selector(periodChanged:)])
        {
            [self.delegate periodChanged:_period];
        }

        [self periodUpdated];
    }
}

#pragma mark - Touches handling -

- (NSInteger) indexForDate: (NSDate *)date
{
    NSDate *monthStartDate  = [_currentDate monthStartDate];
    NSInteger monthStartDay = [monthStartDate weekday];
    monthStartDay           = (monthStartDay + (self.mondayFirstDayOfWeek?5:6)) % 7;

    NSInteger daysSinceMonthStart = [date daysSinceDate:monthStartDate];
    return daysSinceMonthStart + monthStartDay;
}

- (NSDate *) dateForPoint: (CGPoint)point
{
    CGFloat width  = _initialFrame.size.width;
    CGFloat height = _initialFrame.size.height;
    CGFloat hDiff  = width / 7;
    CGFloat vDiff  = (height - kPMThemeHeaderHeight) / ((kPMThemeDayTitlesInHeader)?6:7);
    
    CGFloat yInCalendar = point.y - (kPMThemeHeaderHeight + ((kPMThemeDayTitlesInHeader)?0:vDiff));
    NSInteger row = yInCalendar / vDiff;
    
    int numDaysInMonth      = [_currentDate numberOfDaysInMonth];
    NSDate *monthStartDate  = [_currentDate monthStartDate];
    NSInteger monthStartDay = [monthStartDate weekday];
    monthStartDay           = (monthStartDay + (self.mondayFirstDayOfWeek?5:6)) % 7;
    numDaysInMonth         += monthStartDay;
    int maxNumberOfRows     = ceil((CGFloat)numDaysInMonth / 7) - 1;
    
    row = MAX(0, MIN(row, maxNumberOfRows));
    
    CGFloat xInCalendar = point.x - 2;
    NSInteger col       = xInCalendar / hDiff;
    
    col = MAX(0, MIN(col, 6));
    
    NSInteger days = row * 7 + col - monthStartDay;
    NSDate *selectedDate = [monthStartDate dateByAddingDays:days];

    return selectedDate;
}

- (void) periodSelectionStarted: (CGPoint) point
{
    PMPeriod* calcPeriod = [PMPeriod oneDayPeriodWithDate:[self dateForPoint:point]];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:calcPeriod.startDate];
    NSInteger month = [dateComponents month];
    
    if(month != currentMonth)
    {
        return;
    }
    
    self.period = calcPeriod;
}

- (void) periodSelectionChanged: (CGPoint) point
{
    NSDate *newDate = [self dateForPoint:point];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:newDate];
    NSInteger month = [dateComponents month];
    
    if(month != currentMonth)
    {
        return;
    }
    
    if (_allowsPeriodSelection)
    {
        self.period = [PMPeriod periodWithStartDate:self.period.startDate endDate:newDate];
    }
    else
    {
        self.period = [PMPeriod oneDayPeriodWithDate:newDate];
    }
}

- (void) panTimerCallback: (NSTimer *)timer
{
    NSNumber *increment = timer.userInfo;
    
    [self setCurrentDate:[self.currentDate dateByAddingMonths:[increment intValue]]];
    [self periodSelectionChanged:_panPoint];
}

- (void) panHandling: (UIGestureRecognizer *)recognizer
{
    CGPoint point  = [recognizer locationInView:self];
    
    CGFloat height = _initialFrame.size.height;
    CGFloat vDiff  = (height - kPMThemeHeaderHeight) / ((kPMThemeDayTitlesInHeader)?6:7);
    
    if (point.y > kPMThemeHeaderHeight + ((kPMThemeDayTitlesInHeader)?0:vDiff)) // select date in calendar
    {
        if (([recognizer state] == UIGestureRecognizerStateBegan) && (recognizer.numberOfTouches == 1)) 
        {
            [self periodSelectionStarted:point];
        }
        else if (([recognizer state] == UIGestureRecognizerStateChanged) && (recognizer.numberOfTouches == 1))
        {
            if ((point.x < 20) || (point.x > _initialFrame.size.width - 20))
            {
                self.panPoint = point;
                if (self.panTimer)
                {
                    return;
                }
                
                NSNumber *increment = [NSNumber numberWithInt:1];
                if (point.x < 20)
                {
                    increment = [NSNumber numberWithInt:-1];
                }
                
                if(!self.showOnlyCurrentMonth)
                {
                    self.panTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                 target:self 
                                                               selector:@selector(panTimerCallback:)
                                                               userInfo:increment
                                                                repeats:YES];
                }
            }
            else
            {
                [self.panTimer invalidate];
                self.panTimer = nil;
            }
            
            [self periodSelectionChanged:point];
        }
    }
    
    if (([recognizer state] == UIGestureRecognizerStateEnded) 
        || ([recognizer state] == UIGestureRecognizerStateCancelled)
        || ([recognizer state] == UIGestureRecognizerStateFailed))
    {
        [self.panTimer invalidate];
        self.panTimer = nil;
    }
}

- (void) tapHandling: (UIGestureRecognizer *)recognizer
{
    CGPoint point  = [recognizer locationInView:self];
    
    CGFloat height = _initialFrame.size.height;
    CGFloat vDiff  = (height - kPMThemeHeaderHeight) / ((kPMThemeDayTitlesInHeader)?6:7);

    if (point.y > kPMThemeHeaderHeight + ((kPMThemeDayTitlesInHeader)?0:vDiff)) // select date in calendar
    {
        [self periodSelectionStarted:point];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(periodChanged:)])
    {
        [self.delegate periodChanged:_period];
    }
    
    if(!self.showOnlyCurrentMonth)
    {
        if(CGRectContainsPoint(leftArrowRect, point))
        {
            //User tapped the prevMonth button
            [self setCurrentDate:[self.currentDate dateByAddingMonths:-1]];
        }
        else if(CGRectContainsPoint(rightArrowRect, point))
        {
            //User tapped the nextMonth button
            [self setCurrentDate:[self.currentDate dateByAddingMonths:1]];
        }
    }
    
}

- (void) longPressTimerCallback: (NSTimer *)timer
{
    NSNumber *increment = timer.userInfo;
    [self setCurrentDate:[self.currentDate dateByAddingMonths:[increment intValue]]];
}

- (void) longPressHandling: (UIGestureRecognizer *)recognizer
{
    if (([recognizer state] == UIGestureRecognizerStateBegan) && (recognizer.numberOfTouches == 1)) 
    {
        if (self.longPressTimer)
        {
            return;
        }

        CGPoint point = [recognizer locationInView:self];
        CGFloat height = _initialFrame.size.height;
        CGFloat vDiff  = (height - kPMThemeHeaderHeight) / ((kPMThemeDayTitlesInHeader)?6:7);
        
        if (point.y > kPMThemeHeaderHeight + ((kPMThemeDayTitlesInHeader)?0:vDiff)) // select date in calendar
        {
            [self periodSelectionChanged:point];
            return;
        }

        NSNumber *increment = nil;
        if(CGRectContainsPoint(leftArrowRect, point)) 
        {
            //User tapped the prevMonth button
            increment = [NSNumber numberWithInt:-1];
        } 
        else if(CGRectContainsPoint(rightArrowRect, point)) 
        {
            //User tapped the nextMonth button
            increment = [NSNumber numberWithInt:1];
        }

        if (increment)
        {
            self.longPressTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f
                                                                   target:self
                                                                 selector:@selector(longPressTimerCallback:)
                                                                 userInfo:increment 
                                                                  repeats:YES];
        }
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        if (self.longPressTimer)
        {
            return;
        }

        CGPoint point = [recognizer locationInView:self];
        [self periodSelectionChanged:point];
    }
    else if (([recognizer state] == UIGestureRecognizerStateCancelled) 
             || ([recognizer state] == UIGestureRecognizerStateEnded) )
    {
        if (self.longPressTimer)
        {
            [self.longPressTimer invalidate];
            self.longPressTimer = nil;
        }
    }
}

- (void)setAllowsLongPressMonthChange:(BOOL)allowsLongPressMonthChange
{
    if (!allowsLongPressMonthChange)
    {
        if (self.longPressGestureRecognizer)
        {
            [self removeGestureRecognizer:self.longPressGestureRecognizer];
            self.longPressGestureRecognizer = nil;
        }
    }
    else if (!self.longPressGestureRecognizer)
    {
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(longPressHandling:)];
        self.longPressGestureRecognizer.numberOfTouchesRequired = 1;
        self.longPressGestureRecognizer.delegate = self;
        self.longPressGestureRecognizer.minimumPressDuration = 0.5;
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
}

@end

@implementation PMDaysView

@synthesize font;
@synthesize currentDate = _currentDate;
@synthesize selectedPeriod = _selectedPeriod;
@synthesize mondayFirstDayOfWeek = _mondayFirstDayOfWeek;
@synthesize rects;
@synthesize initialFrame = _initialFrame;
@synthesize showOnlyCurrentMonth = _showOnlyCurrentMonth;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)redrawComponent
{
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }

    self.initialFrame = frame;

    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redrawComponent)
                                                 name:kPMCalendarRedrawNotification
                                               object:nil];
    
    NSMutableArray *tmpRects   = [NSMutableArray arrayWithCapacity:42];
    UIEdgeInsets shadowPadding = kPMThemeShadowPadding;
    CGFloat headerHeight       = kPMThemeHeaderHeight;
    UIFont *calendarFont       = kPMThemeDefaultFont;

    CGFloat width  = _initialFrame.size.width + shadowPadding.left + shadowPadding.right;
    CGFloat hDiff  = width / 7;
    CGFloat height = _initialFrame.size.height;
    CGFloat vDiff  = (height - headerHeight) / (kPMThemeDayTitlesInHeaderIntOffset + 6);
    CGSize shadow2Offset = CGSizeMake(1, 1); // TODO: remove!

    for (NSInteger i = 0; i < 42; i++) 
    {
        CGRect rect = CGRectMake(ceil((i % 7) * hDiff)
                                 , headerHeight + ((int)(i / 7) + kPMThemeDayTitlesInHeaderIntOffset) * vDiff
                                        + (vDiff - calendarFont.pointSize) / 2 - shadow2Offset.height
                                 , hDiff
                                 , calendarFont.pointSize); 
        [tmpRects addObject:NSStringFromCGRect(rect)];
    }
    
    self.rects = [NSArray arrayWithArray:tmpRects];

    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context       = UIGraphicsGetCurrentContext();
    UIFont *calendarFont       = kPMThemeDefaultFont;
    UIEdgeInsets shadowPadding = kPMThemeShadowPadding;
    CGFloat headerHeight       = kPMThemeHeaderHeight;

    // digits drawing
	NSDate *dateOnFirst = [_currentDate monthStartDate];
	int weekdayOfFirst = ([dateOnFirst weekday] + (_mondayFirstDayOfWeek?5:6)) % 7 + 1;
	int numDaysInMonth = [dateOnFirst numberOfDaysInMonth];
    NSDate *monthStartDate = [_currentDate monthStartDate];
    int todayIndex = [[[NSDate date] dateWithoutTime] daysSinceDate:monthStartDate] + weekdayOfFirst - 1;

    //Find number of days in previous month
    NSDate *prevDateOnFirst = [[_currentDate dateByAddingMonths:-1] monthStartDate];
    int numDaysInPrevMonth = [prevDateOnFirst numberOfDaysInMonth];
    NSDate *firstDateInCal = [monthStartDate dateByAddingDays:(-weekdayOfFirst + 1)];
    
    int selectionStartIndex = [[self.selectedPeriod normalizedPeriod].startDate daysSinceDate:firstDateInCal];
    int selectionEndIndex = [[self.selectedPeriod normalizedPeriod].endDate daysSinceDate:firstDateInCal];
    NSDictionary *todayBGDict = [[PMThemeEngine sharedInstance] themeDictForType:PMThemeCalendarDigitsTodayElementType
                                                                         subtype:PMThemeBackgroundSubtype];
    NSDictionary *todaySelectedBGDict = [[PMThemeEngine sharedInstance] themeDictForType:PMThemeCalendarDigitsTodaySelectedElementType
                                                                                 subtype:PMThemeBackgroundSubtype];
    NSDictionary *inactiveSelectedDict = [[PMThemeEngine sharedInstance] themeDictForType:PMThemeCalendarDigitsInactiveSelectedElementType
                                                                                  subtype:PMThemeMainSubtype];
    NSDictionary *todaySelectedDict = [[PMThemeEngine sharedInstance] themeDictForType:PMThemeCalendarDigitsTodaySelectedElementType
                                                                               subtype:PMThemeMainSubtype];
    NSDictionary *activeSelectedDict = [[PMThemeEngine sharedInstance] themeDictForType:PMThemeCalendarDigitsActiveSelectedElementType
                                                                                subtype:PMThemeMainSubtype];

    //Draw the text for each of those days.
    for(int i = 0; i <= weekdayOfFirst-2; i++) 
    {
        int day = numDaysInPrevMonth - weekdayOfFirst + 2 + i;
        BOOL selected = (i >= selectionStartIndex) && (i <= selectionEndIndex);
        BOOL isToday = (i == todayIndex);

        NSString *string = [NSString stringWithFormat:@"%d", day];
        CGRect dayHeader2Frame = CGRectFromString([self.rects objectAtIndex:i]);
        
        PMThemeElementType type = PMThemeCalendarDigitsInactiveElementType;
        
        if (isToday)
        {
            type = PMThemeCalendarDigitsTodayElementType;
            if (selected && todaySelectedDict)
            {
                type = PMThemeCalendarDigitsTodaySelectedElementType;
            }
        }
        else if (selected && inactiveSelectedDict)
        {
            type = PMThemeCalendarDigitsInactiveSelectedElementType;
        }

        if(!self.showOnlyCurrentMonth)
        {
            [[PMThemeEngine sharedInstance] drawString:string
                                              withFont:calendarFont
                                                inRect:dayHeader2Frame
                                        forElementType:type
                                               subType:PMThemeMainSubtype
                                             inContext:context];
        }
    }

    int startIndex = [[self.calendarView.allowedPeriod.startDate dateWithoutTime] daysSinceDate:monthStartDate] + weekdayOfFirst - 1;
    int endIndex   = [[self.calendarView.allowedPeriod.endDate dateWithoutTime] daysSinceDate:monthStartDate] + weekdayOfFirst - 1;
    
    BOOL isStartSameAsCurrentMonth = [self.calendarView.allowedPeriod.startDate isCurrentMonth:_currentDate];
    BOOL isEndSameAsCurrentMonth   = [self.calendarView.allowedPeriod.endDate isCurrentMonth:_currentDate];
    
	int day = 1;

	for (int i = 0; i < 6; i++) 
    {
		for(int j = 0; j < 7; j++) 
        {
			int dayNumber = i * 7 + j;

			if (dayNumber >= (weekdayOfFirst-1) && day <= numDaysInMonth) 
            {
                NSString *string = [NSString stringWithFormat:@"%d", day];
                CGRect dayHeader2Frame = CGRectFromString([self.rects objectAtIndex:dayNumber]);
                BOOL selected = (dayNumber >= selectionStartIndex) && (dayNumber <= selectionEndIndex);
                BOOL isToday = (dayNumber == todayIndex);

                if(isToday) 
                {
                    
                    if (todayBGDict)
                    {

                        CGFloat width  = _initialFrame.size.width + shadowPadding.left + shadowPadding.right;
                        CGFloat height = _initialFrame.size.height;
                        CGFloat hDiff = (width + shadowPadding.left + shadowPadding.right - kPMThemeInnerPadding.width * 2) / 7;
                        CGFloat vDiff = (height - kPMThemeHeaderHeight - kPMThemeInnerPadding.height * 2) / ((kPMThemeDayTitlesInHeader)?6:7);
                        CGSize bgOffset = [[todayBGDict elementInThemeDictOfGenericType:PMThemeOffsetGenericType] pmThemeGenerateSize];
                        
                        NSString *coordinatesRound = [todayBGDict elementInThemeDictOfGenericType:PMThemeCoordinatesRoundGenericType];
                        
                        if (coordinatesRound)
                        {
                            if ([coordinatesRound isEqualToString:@"ceil"])
                            {
                                hDiff = ceil(hDiff);
                                vDiff = ceil(vDiff);
                            }
                            else if ([coordinatesRound isEqualToString:@"floor"])
                            {
                                hDiff = floor(hDiff);
                                vDiff = floor(vDiff);
                            }
                        }

                        CGRect rect = CGRectMake(floor(j * hDiff) + bgOffset.width
                                                 , headerHeight + (i + kPMThemeDayTitlesInHeaderIntOffset) * vDiff + bgOffset.height
                                                 , floor(hDiff)
                                                 , vDiff);
                        PMThemeElementType type = PMThemeCalendarDigitsTodayElementType;
                        
                        if (selected && todaySelectedBGDict)
                        {
                            type = PMThemeCalendarDigitsTodaySelectedElementType;
                        }

                        UIEdgeInsets rectInset = [[[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeEdgeInsetsGenericType
                                                                                               subtype:PMThemeBackgroundSubtype
                                                                                                  type:type] pmThemeGenerateEdgeInsets];

                        UIBezierPath* selectedRectPath = [UIBezierPath bezierPathWithRoundedRect:UIEdgeInsetsInsetRect(rect, rectInset)
                                                                                    cornerRadius:0];
                        

                        [[PMThemeEngine sharedInstance] drawPath:selectedRectPath
                                                  forElementType:type
                                                         subType:PMThemeBackgroundSubtype
                                                       inContext:context];
                    }
                }
                
                BOOL isBeforeBeginningOfAllowedPeriod = (dayNumber < startIndex && isStartSameAsCurrentMonth);
                BOOL isAfterEndOfAllowedPeriod = (dayNumber > endIndex && isEndSameAsCurrentMonth);
                
                PMThemeElementType type = PMThemeCalendarDigitsActiveElementType;
                
                if (isToday)
                {
                    type = PMThemeCalendarDigitsTodayElementType;
                    if (selected && todaySelectedDict)
                    {
                        type = PMThemeCalendarDigitsTodaySelectedElementType;
                    }
                }
                else if (selected && activeSelectedDict)
                {
                    type = PMThemeCalendarDigitsActiveSelectedElementType;
                }
                else if (isBeforeBeginningOfAllowedPeriod || isAfterEndOfAllowedPeriod)
                {
                    type = PMThemeCalendarDigitsNotAllowedElementType;
                }

                [[PMThemeEngine sharedInstance] drawString:string
                                                  withFont:calendarFont
                                                    inRect:dayHeader2Frame
                                            forElementType:type
                                                   subType:PMThemeMainSubtype
                                                 inContext:context];
                
				++day;
			}
		}
	}

    int weekdayOfNextFirst = (weekdayOfFirst - 1 + numDaysInMonth) % 7;
    
    if( weekdayOfNextFirst > 0 )
    {
        //Draw the text for each of those days.
        for ( int i = weekdayOfNextFirst; i < 7; i++ ) 
        {
            int index = numDaysInMonth + weekdayOfFirst + i - weekdayOfNextFirst - 1;
            int day = i - weekdayOfNextFirst + 1;
            BOOL isToday = (numDaysInMonth + (weekdayOfFirst - 1) + day - 1 == todayIndex);
            BOOL selected = (index >= selectionStartIndex) && (index <= selectionEndIndex);
            NSString *string = [NSString stringWithFormat:@"%d", day];
            CGRect dayHeader2Frame = CGRectFromString([self.rects objectAtIndex:index]);
            
            PMThemeElementType type = PMThemeCalendarDigitsInactiveElementType;
            
            if (isToday)
            {
                type = PMThemeCalendarDigitsTodayElementType;
                if (selected && todaySelectedDict)
                {
                    type = PMThemeCalendarDigitsTodaySelectedElementType;
                }
            }
            else if (selected && inactiveSelectedDict)
            {
                type = PMThemeCalendarDigitsInactiveSelectedElementType;
            }
            
            if(!self.showOnlyCurrentMonth)
            {
            
                [[PMThemeEngine sharedInstance] drawString:string
                                                  withFont:calendarFont
                                                    inRect:dayHeader2Frame
                                            forElementType:type
                                                   subType:PMThemeMainSubtype
                                                 inContext:context];
            }
        }
    }
}

- (void) setCurrentDate:(NSDate *)currentDate
{
    if (![_currentDate isEqualToDate:currentDate])
    {
        _currentDate = currentDate;
        [self setNeedsDisplay];
    }
}

- (void)setMondayFirstDayOfWeek:(BOOL)mondayFirstDayOfWeek
{
    if (_mondayFirstDayOfWeek != mondayFirstDayOfWeek)
    {
        _mondayFirstDayOfWeek = mondayFirstDayOfWeek;
        [self setNeedsDisplay];
    }
}

@end
