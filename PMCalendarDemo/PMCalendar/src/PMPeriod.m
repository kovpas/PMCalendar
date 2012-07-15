//
//  PMPeriod.m
//  PMCalendarDemo
//
//  Created by Mazurin Pavel on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMPeriod.h"
#import "NSDate+Helpers.h"

@implementation PMPeriod

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

+ (id) periodWithStartDate:(NSDate *) startDate endDate:(NSDate *) endDate
{
    PMPeriod *result = [[PMPeriod alloc] init];
    
    result.startDate = startDate;
    result.endDate = endDate;
    
    return result;
}

+ (id) oneDayPeriodWithDate:(NSDate *) date
{
    PMPeriod *result = [[PMPeriod alloc] init];
    
    result.startDate = [date dateWithoutTime];
    result.endDate = result.startDate;

    return result;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[PMPeriod class]])
    {
        return NO;
    }
    
    PMPeriod *period = object;
    return [self.startDate isEqualToDate:period.startDate] 
            && [self.endDate isEqualToDate:period.endDate];
}

- (NSInteger) lengthInDays
{
    return [self.endDate timeIntervalSinceDate:self.startDate] / (60 * 60 * 24);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"startDate = %@; endDate = %@", _startDate, _endDate];
}

@end
