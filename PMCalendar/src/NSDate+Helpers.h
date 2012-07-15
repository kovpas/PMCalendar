//
//  NSDate+Helpers.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

- (NSDate *)dateWithoutTime;
- (NSDate *) dateByAddingDays:(NSInteger) days;
- (NSDate *) dateByAddingMonths:(NSInteger) months;
- (NSDate *) dateByAddingYears:(NSInteger) years;
- (NSDate *) monthStartDate;
- (NSInteger) numberOfDaysInMonth;
- (NSInteger) weekday;

@end
