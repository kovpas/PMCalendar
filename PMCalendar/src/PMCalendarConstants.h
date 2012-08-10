//
//  PMCalendarConstants.h
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

extern NSString *kPMCalendarRedrawNotification;

enum {
//    PMCalendarArrowDirectionNo      = -1, <- TBI
    PMCalendarArrowDirectionUp      = 1UL << 0,
    PMCalendarArrowDirectionDown    = 1UL << 1,
    PMCalendarArrowDirectionLeft    = 1UL << 2,
    PMCalendarArrowDirectionRight   = 1UL << 3,
    PMCalendarArrowDirectionAny     = PMCalendarArrowDirectionUp | PMCalendarArrowDirectionDown | PMCalendarArrowDirectionLeft | PMCalendarArrowDirectionRight,
    PMCalendarArrowDirectionUnknown = NSUIntegerMax
};
typedef NSUInteger PMCalendarArrowDirection;
