//
//  PMPeriod.m
//  PMCalendarDemo
//
//  Created by Mazurin Pavel on 7/13/12.
//  Copyright (c) 2012 TomTom. All rights reserved.
//

#import "PMPeriod.h"

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

@end
