//
//  NSDate+Helpers.h
//  PMCalendarDemo
//
//  Created by Mazurin Pavel on 7/14/12.
//  Copyright (c) 2012 TomTom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

- (NSDate *) dateByAddingMonths:(NSInteger) months;
- (NSDate *) monthStartDate;
- (NSInteger) numberOfDaysInMonth;
- (NSInteger) weekday;

@end
