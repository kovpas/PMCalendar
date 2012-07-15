//
//  PMPeriod.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMPeriod : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

+ (id) oneDayPeriodWithDate:(NSDate *) date;
+ (id) periodWithStartDate:(NSDate *) startDate endDate:(NSDate *) endDate;

- (NSInteger) lengthInDays;

@end
