//
//  PMPeriod.m
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/13/12.
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

- (BOOL) isEqual:(id) object
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
    return [self.endDate daysSinceDate:self.startDate];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"startDate = %@; endDate = %@", _startDate, _endDate];
}

- (PMPeriod *) normalizedPeriod
{
    PMPeriod *result = [[PMPeriod alloc] init];
    
    if ([_startDate compare:_endDate] == NSOrderedAscending)
    {
        result.startDate = _startDate;
        result.endDate = _endDate;
    }
    else
    {
        result.startDate = _endDate;
        result.endDate = _startDate;
    }
    
    return result;
}

- (BOOL) containsDate:(NSDate *) date
{
    PMPeriod *normalizedPeriod = [self normalizedPeriod];
    
    if (([normalizedPeriod.startDate compare:date] != NSOrderedDescending)
        && ([normalizedPeriod.endDate compare:date] != NSOrderedAscending))
    {
        return YES;
    }
    
    return NO;
}

- (id) copyWithZone:(NSZone *) zone
{
    PMPeriod *copiedPeriod = [[PMPeriod alloc] init];
    copiedPeriod.startDate = [_startDate copyWithZone: zone];
    copiedPeriod.endDate = [_endDate copyWithZone: zone];
    
    return copiedPeriod;
}

@end
