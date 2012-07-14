//
//  NSDate+Helpers.m
//  PMCalendarDemo
//
//  Created by Mazurin Pavel on 7/14/12.
//  Copyright (c) 2012 TomTom. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

- (NSDate *) dateByAddingMonths:(NSInteger) months
{
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	dateComponents.month = months;
	
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

- (NSDate *)startDateWithUnit:(int)calendarUnit withOffset:(NSInteger)offset
{
	NSDate *beginningOfDate = nil;
	[[NSCalendar currentCalendar] rangeOfUnit:calendarUnit startDate:&beginningOfDate interval:NULL forDate:self];
	NSDateComponents *date = [[NSDateComponents alloc] init];
	switch ( calendarUnit ) {
		case NSMonthCalendarUnit:
			[date setMonth:offset];
			break;
		case NSYearCalendarUnit:
			[date setYear:offset];
			break;
		default:
			break;
	}
    
	NSDate *startDateWithOffset = [[NSCalendar currentCalendar] dateByAddingComponents:date toDate:beginningOfDate options:0];
	
	return startDateWithOffset;
}

- (NSDate *) monthStartDate 
{
	return [self monthStartDateWithOffset:0];
}

- (NSDate *) monthStartDateWithOffset:(NSInteger)monthOffset
{
	return [self startDateWithUnit:NSMonthCalendarUnit withOffset:monthOffset];
}

- (NSInteger) numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit 
                                              inUnit:NSMonthCalendarUnit 
                                             forDate:self].length;
}

- (NSInteger) weekday
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    
    return [weekdayComponents weekday];
}

@end
