//
//  PMPeriod.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * PMPeriod is a simple class which represents a period of time.
 * PMPeriod has start and end date which could be the same in order to represent one-day period.
 */
@interface PMPeriod : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

/**
 * Creates new period with same startDate and endDate.
 */
+ (id) oneDayPeriodWithDate:(NSDate *) date;

/**
 * Creates new period.
 */
+ (id) periodWithStartDate:(NSDate *) startDate endDate:(NSDate *) endDate;

- (NSInteger) lengthInDays;

/**
 * Creates new period from the current (self) period self with proper order of startDate and endDate.
 */
- (PMPeriod *) normalizedPeriod;

@end
