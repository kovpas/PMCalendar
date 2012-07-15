//
//  PMCalendarConstants.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#define UIColorMakeRGBA(nRed, nGreen, nBlue, nAlpha) [UIColor colorWithRed:(nRed)/255.0f green:(nGreen)/255.0f blue:(nBlue)/255.0f alpha:nAlpha]
#define UIColorMakeRGB(nRed, nGreen, nBlue) UIColorMakeRGBA(nRed, nGreen, nBlue, 1.0f)

extern CGFloat headerHeight;
extern CGSize innerPadding;
extern CGFloat outerPadding;
extern NSString *kPMCalendarRedrawNotification;
