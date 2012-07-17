//
//  PMCalendarConstants.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#define UIColorMakeRGBA(nRed, nGreen, nBlue, nAlpha) [UIColor colorWithRed:(nRed)/255.0f green:(nGreen)/255.0f blue:(nBlue)/255.0f alpha:nAlpha]
#define UIColorMakeRGB(nRed, nGreen, nBlue) UIColorMakeRGBA(nRed, nGreen, nBlue, 1.0f)

extern CGFloat shadowPadding;
extern CGFloat cornerRadius;
extern CGFloat headerHeight;
extern CGSize arrowSize;
//TODO: Replace paddings with UIEdgeInsets (what for? :))
extern CGSize innerPadding;
extern CGSize outerPadding;
extern NSString *kPMCalendarRedrawNotification;

enum {
    PMCalendarArrowDirectionUp = 1UL << 0,
    PMCalendarArrowDirectionDown = 1UL << 1,
    PMCalendarArrowDirectionLeft = 1UL << 2,
    PMCalendarArrowDirectionRight = 1UL << 3,
    PMCalendarArrowDirectionAny = PMCalendarArrowDirectionUp | PMCalendarArrowDirectionDown | PMCalendarArrowDirectionLeft | PMCalendarArrowDirectionRight,
    PMCalendarArrowDirectionUnknown = NSUIntegerMax
};
typedef NSUInteger PMCalendarArrowDirection;
