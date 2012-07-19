//
//  PMSelectionView.m
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMSelectionView.h"
#import "PMCalendarConstants.h"

@interface PMSelectionView ()

@end

@implementation PMSelectionView

@synthesize startIndex = _startIndex;
@synthesize endIndex = _endIndex;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)redrawComponent
{
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }    
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redrawComponent)
                                                 name:kPMCalendarRedrawNotification
                                               object:nil];
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if((_startIndex >= 0) || (_endIndex >= 0)) 
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGColorRef backgroundShadow = [UIColor blackColor].CGColor;
        CGSize backgroundShadowOffset = CGSizeMake(2, 3);
        CGFloat backgroundShadowBlurRadius = 5;
        
        UIColor* darkColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.72];
        
        UIColor* color = [UIColor colorWithRed: 0.82 green: 0.08 blue: 0 alpha: 0.86];
        UIColor* color2 = [UIColor colorWithRed: 0.66 green: 0.02 blue: 0.04 alpha: 0.88];
        NSArray* gradient3Colors = [NSArray arrayWithObjects: 
                                    (id)color.CGColor, 
                                    (id)color2.CGColor, nil];
        CGFloat gradient3Locations[] = {0, 1};
        CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient3Colors, gradient3Locations);
        
        CGFloat width  = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGFloat hDiff = (width - innerPadding.width * 2) / 7;
        CGFloat vDiff  = (height - headerHeight - innerPadding.height * 2) / 7;

        int tempStart = MAX(MIN(_startIndex, _endIndex), 0);
        int tempEnd = MAX(_startIndex, _endIndex);
        
        int rowStart = tempStart / 7;
        int rowEnd = tempEnd / 7;
        int colStart = tempStart % 7;
        int colEnd = tempEnd % 7;
        
        for (int i = rowStart; i <= rowEnd; i++)
        {
            //// selectedRect Drawing
            int thisRowStartCell = 0;
            int thisRowEndCell = 6;
            
            if (rowStart == i) 
            {
                thisRowStartCell = colStart;
            }
            
            if (rowEnd == i) 
            {
                thisRowEndCell = colEnd;
            } 

            //// selectedRect Drawing
            CGRect rect = CGRectMake(innerPadding.width + floor(thisRowStartCell*hDiff) + 1.5
                                     , headerHeight + innerPadding.height + ceil((i + 1)*vDiff) + 2
                                     , floor((thisRowEndCell - thisRowStartCell + 1) * (hDiff)) - 4, vDiff - 4);
            UIBezierPath* selectedRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius: 10];
            CGContextSaveGState(context);
            [selectedRectPath addClip];
            CGContextDrawLinearGradient(context, gradient3
                                        , CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))
                                        , CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)), 0);
            CGContextRestoreGState(context);
            
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, backgroundShadowOffset, backgroundShadowBlurRadius, backgroundShadow);
            [darkColor setStroke];
            selectedRectPath.lineWidth = 0.5;
            [selectedRectPath stroke];
            CGContextRestoreGState(context);
        }
        
        CGGradientRelease(gradient3);
        CGColorSpaceRelease(colorSpace);
    }
}

- (void)setStartIndex:(NSInteger)startIndex
{
    if (_startIndex != startIndex)
    {
        _startIndex = startIndex;
        [self setNeedsDisplay];
    }
}

- (void)setEndIndex:(NSInteger)endIndex
{
    if (_endIndex != endIndex)
    {
        _endIndex = endIndex;
        [self setNeedsDisplay];
    }
}

@end
