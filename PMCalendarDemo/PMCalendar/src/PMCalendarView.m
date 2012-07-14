//
//  PMCalendarView.m
//  PMCalendarDemo
//
//  Created by Mazurin Pavel on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMCalendarView.h"
#import "PMPeriod.h"
#import "PMCalendarConstants.h"
#import "NSDate+Helpers.h"

@interface PMCalendarView ()

@property (nonatomic, strong) NSCalendar *gregorian;
@property (nonatomic, strong) UIFont *font;

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
@synthesize gregorian = _gregorian;
@synthesize delegate = _delegate;
@synthesize font = _font;

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.mondayFirstDayOfWeek = NO;
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *dayTitles = [dateFormatter shortStandaloneWeekdaySymbols];
    NSArray *monthTitles = [dateFormatter standaloneMonthSymbols];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(1, 1);
    CGFloat shadow2BlurRadius = 1;

    CGFloat width = self.frame.size.width - outerPadding * 2;
    CGFloat height = self.frame.size.height - outerPadding * 2;
    CGFloat hDiff = (width - innerPadding.width * 2) / 7;

    CGFloat vDiff = (height - headerHeight - innerPadding.height * 2) / 7; // 7 = 1st row - day names plus 6 - max amount of rows (4 - min amount of rows)
    UIFont *calendarFont = self.font;
    UIFont *monthFont = [UIFont fontWithName:@"Helvetica-Bold" size:self.font.pointSize];

    for (int i = 0; i < dayTitles.count; i++) 
    {
        NSInteger index = i + (_mondayFirstDayOfWeek?1:0);
        index = index % 7;
        //// dayHeader Drawing
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
        CGRect dayHeaderFrame = CGRectMake(innerPadding.width + outerPadding + i * hDiff + 2
                                           , innerPadding.height + outerPadding + headerHeight
                                           , hDiff
                                           , 30);
        [[UIColor whiteColor] setFill];
        [((NSString *)[dayTitles objectAtIndex:index]) drawInRect: dayHeaderFrame 
                                                         withFont: calendarFont 
                                                    lineBreakMode: UILineBreakModeWordWrap
                                                        alignment: UITextAlignmentCenter];
        CGContextRestoreGState(context);
    }
    
    int month = currentMonth;
    int year = currentYear;
    
	NSString *monthTitle = [NSString stringWithFormat:@"%@ %d", [monthTitles objectAtIndex:(month - 1)], year];
    //// Month Header Drawing
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    CGRect textFrame = CGRectMake(innerPadding.width + outerPadding
                                  , innerPadding.height + outerPadding + (headerHeight - [monthTitle sizeWithFont:monthFont].height) / 2
                                  , width - innerPadding.width * 2
                                  , headerHeight);
    [[UIColor whiteColor] setFill];
    [monthTitle drawInRect: textFrame
                  withFont: monthFont
             lineBreakMode: UILineBreakModeWordWrap 
                 alignment: UITextAlignmentCenter];
    CGContextRestoreGState(context);
    
    //// backArrow Drawing
    UIBezierPath* backArrowPath = [UIBezierPath bezierPath];
    [backArrowPath moveToPoint: CGPointMake(innerPadding.width + outerPadding + hDiff / 2 - 6
                                            , innerPadding.height + outerPadding + headerHeight / 2)];
    [backArrowPath addLineToPoint: CGPointMake(innerPadding.width + outerPadding + 6 + hDiff / 2 - 6
                                               , innerPadding.height + outerPadding + headerHeight / 2 + 4)];
    [backArrowPath addLineToPoint: CGPointMake(innerPadding.width + outerPadding + 6 + hDiff / 2 - 6
                                               , innerPadding.height + outerPadding + headerHeight / 2 - 4)];
    [backArrowPath addLineToPoint: CGPointMake(innerPadding.width + outerPadding + hDiff / 2 - 6
                                               , innerPadding.height + outerPadding + headerHeight / 2)];
    [backArrowPath closePath];
    [[UIColor whiteColor] setFill];
    [backArrowPath fill];
    leftArrowRect = CGRectInset(backArrowPath.bounds, -10, -10);

    //// forwardArrow Drawing
    UIBezierPath* forwardArrowPath = [UIBezierPath bezierPath];
    [forwardArrowPath moveToPoint: CGPointMake(-innerPadding.width + outerPadding + width - hDiff / 2 + 6
                                               , innerPadding.height + outerPadding + headerHeight / 2)];
    [forwardArrowPath addLineToPoint: CGPointMake(-innerPadding.width + outerPadding - 6 + width - hDiff / 2 + 6
                                                  , innerPadding.height + outerPadding + headerHeight / 2 + 4)];
    [forwardArrowPath addLineToPoint: CGPointMake(-innerPadding.width + outerPadding - 6 + width - hDiff / 2 + 6
                                                   , innerPadding.height + outerPadding + headerHeight / 2 - 4)];
    [forwardArrowPath addLineToPoint: CGPointMake(-innerPadding.width + outerPadding + width - hDiff / 2 + 6
                                                  , innerPadding.height + outerPadding + headerHeight / 2)];
    [forwardArrowPath closePath];
    [[UIColor whiteColor] setFill];
    [forwardArrowPath fill];
    rightArrowRect = CGRectInset(forwardArrowPath.bounds, -10, -10);

    // digits drawing
    NSCalendar *gregorian = self.gregorian;
	NSDate *dateOnFirst = [_currentDate monthStartDate];
	NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit 
                                                       fromDate:dateOnFirst];
	int weekdayOfFirst = ([weekdayComponents weekday] + (_mondayFirstDayOfWeek?5:6)) % 7 + 1;

	int numDaysInMonth = [gregorian rangeOfUnit:NSDayCalendarUnit 
                                         inUnit:NSMonthCalendarUnit 
                                        forDate:dateOnFirst].length;
    
    BOOL didAddExtraRow = NO;
    
    //Find number of days in previous month
    NSDate *prevDateOnFirst = [[_currentDate dateByAddingMonths:-1] monthStartDate];
    int numDaysInPrevMonth = [gregorian rangeOfUnit:NSDayCalendarUnit 
                                            inUnit:NSMonthCalendarUnit 
                                           forDate:prevDateOnFirst].length;
    
    NSDateComponents *today = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit 
                                           fromDate:[NSDate date]];
    
    void (^drawString)(NSString *, CGRect, UIColor *) = ^(NSString *string, CGRect rect, UIColor *color) {
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
        [color setFill];
        [string drawInRect: rect 
                  withFont: calendarFont
             lineBreakMode: UILineBreakModeWordWrap
                 alignment: UITextAlignmentCenter];
        CGContextRestoreGState(context);
    };
    
    //Draw the text for each of those days.
    for(int i = 0; i <= weekdayOfFirst-2; i++) {
        int day = numDaysInPrevMonth - weekdayOfFirst + 2 + i;
        
        NSString *string = [NSString stringWithFormat:@"%d", day];
        CGRect dayHeader2Frame = CGRectMake(ceil(outerPadding + innerPadding.width + i * hDiff) + 2
                                            , (int)(outerPadding + innerPadding.height + vDiff + headerHeight)
                                            , (int)(hDiff), 14);        
        UIColor *color = [UIColor colorWithWhite:0.6f alpha:1.0f];
        
        drawString( string, dayHeader2Frame, color );
    }

    BOOL endedOnSat = NO;
	int finalRow = 0;
	int day = 1;
	for (int i = 0; i < 6; i++) {
		for(int j = 0; j < 7; j++) {
			int dayNumber = i * 7 + j;
			
			if(dayNumber >= (weekdayOfFirst-1) && day <= numDaysInMonth) {
                NSString *string = [NSString stringWithFormat:@"%d", day];
                CGRect dayHeader2Frame = CGRectMake(ceil(outerPadding + innerPadding.width + j * hDiff) + 2
                                                    , (int)(outerPadding + innerPadding.height + headerHeight + (i + 1) * vDiff)
                                                    , (int)(hDiff), 14); 
                UIColor *color = nil;
                
                if([today day] == day && [today month] == month && [today year] == year) 
                {
                    color = [UIColor colorWithRed: 0.98 green: 0.24 blue: 0.09 alpha: 1];
                }
                else 
                {
                    color = [UIColor whiteColor];
                }
                
                drawString( string, dayHeader2Frame, color );
                
                finalRow = i;
                
                if(day == numDaysInMonth && j == 6) 
                {
                    endedOnSat = YES;
                }
                
                if(i == 5) 
                {
                    didAddExtraRow = YES;
                }
                
				++day;
			}
		}
	}
    
    //Find number of days in previous month
    NSDateComponents *nextDateParts = [[NSDateComponents alloc] init];
	[nextDateParts setMonth:month+1];
	[nextDateParts setYear:year];
	[nextDateParts setDay:1];
    
    NSDate *nextDateOnFirst = [gregorian dateFromComponents:nextDateParts];
        
    NSDateComponents *nextWeekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:nextDateOnFirst];
    int weekdayOfNextFirst = ([nextWeekdayComponents weekday] + (_mondayFirstDayOfWeek?5:6)) % 7 + 1;

    if(!endedOnSat) {
        //Draw the text for each of those days.
        for(int i = weekdayOfNextFirst - 1; i < 7; i++) {
            int day = i - weekdayOfNextFirst + 2;
            NSString *string = [NSString stringWithFormat:@"%d", day];
            CGRect dayHeader2Frame = CGRectMake(ceil(outerPadding + innerPadding.width + i * hDiff) + 2
                                                , (int)(outerPadding + innerPadding.height + headerHeight + (finalRow + 1) * vDiff)
                                                , (int)(hDiff), 14);        
            UIColor *color = [UIColor colorWithWhite:0.6f alpha:1.0f];
            drawString( string, dayHeader2Frame, color );
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(CGRectContainsPoint(leftArrowRect, point)) 
    {
        //User tapped the prevMonth button
        [self setCurrentDate:[self.currentDate dateByAddingMonths:-1]];
        /*        [UIView beginAnimations:@"fadeOutViews" context:nil];
        [UIView setAnimationDuration:0.1f];
        [daysView setAlpha:0.0f];
        [selectionView setAlpha:0.0f];
        [UIView commitAnimations];
        
        [self performSelector:@selector(resetViews) withObject:nil afterDelay:0.1f];*/
    } 
    else if(CGRectContainsPoint(rightArrowRect, point)) 
    {
        //User tapped the nextMonth button
        [self setCurrentDate:[self.currentDate dateByAddingMonths:1]];
/*        [UIView beginAnimations:@"fadeOutViews" context:nil];
        [UIView setAnimationDuration:0.1f];
        [daysView setAlpha:0.0f];
        [selectionView setAlpha:0.0f];
        [UIView commitAnimations];
        
        [self performSelector:@selector(resetViews) withObject:nil afterDelay:0.1f];*/
        
        [self setNeedsDisplay];
    }
}

- (void) setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    NSDateComponents *eComponents = [self.gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:_currentDate];
    
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
        [self setNeedsDisplay];
        if ([_delegate respondsToSelector:@selector(currentDateChanged:)])
        {
            [_delegate currentDateChanged:currentDate];
        }
    }
}

- (NSCalendar *) gregorian
{
    if (!_gregorian)
    {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    
    return _gregorian;
}

- (void)setMondayFirstDayOfWeek:(BOOL)mondayFirstDayOfWeek
{
    if (_mondayFirstDayOfWeek != mondayFirstDayOfWeek)
    {
        _mondayFirstDayOfWeek = mondayFirstDayOfWeek;
        NSCalendar *calendar = self.gregorian;

        if (_mondayFirstDayOfWeek)
        {
            [calendar setFirstWeekday:2]; // Sunday == 1, Saturday == 7
        }
        
        [self setNeedsDisplay];
    }
}

- (UIFont *) font
{
    NSInteger newFontSize = self.frame.size.width / 20;
    if (!_font || fontSize == 0 || fontSize != newFontSize)
    {
        _font = [UIFont fontWithName: @"Helvetica" size: newFontSize];
        fontSize = newFontSize;
    }
    return _font;
}


@end
