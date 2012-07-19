//
//  PMCalendarHelpers.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/18/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "NSDate+Helpers.h"

// Geometry helpers

static inline float radians(double degrees) 
{ 
    return degrees * M_PI / 180; 
}
static inline CGPoint CGPointOffset(CGPoint originalPoint, CGFloat dx, CGFloat dy) 
{ 
    return CGPointMake(originalPoint.x + dx, originalPoint.y + dy); 
}
static inline CGPoint CGPointOffsetByPoint(CGPoint originalPoint, CGPoint offsetPoint) 
{ 
    return CGPointOffset(originalPoint, offsetPoint.x, offsetPoint.y); 
}

// UIColor helpers

#define UIColorMakeRGBA(nRed, nGreen, nBlue, nAlpha) [UIColor colorWithRed:(nRed)/255.0f \
                                                                     green:(nGreen)/255.0f \
                                                                      blue:(nBlue)/255.0f \
                                                                     alpha:nAlpha]
#define UIColorMakeRGB(nRed, nGreen, nBlue) UIColorMakeRGBA(nRed, nGreen, nBlue, 1.0f)
