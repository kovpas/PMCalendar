//
//  PMSelectionView.m
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMSelectionView.h"
#import "PMCalendarConstants.h"
#import "PMTheme.h"

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
    PMLog(@"Start");
    if((_startIndex >= 0) || (_endIndex >= 0)) 
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGColorRef backgroundShadow = [UIColor blackColor].CGColor;
        CGSize backgroundShadowOffset = CGSizeMake(2, 3);
        CGFloat backgroundShadowBlurRadius = 5;
        
        UIColor* darkColor = kPMThemeSelectionStrokeColor;
        NSArray* gradient3Colors = kPMThemeSelectionGradientColors;
        CGFloat gradient3Locations[] = kPMThemeSelectionGradientColorLocations;
        CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient3Colors, gradient3Locations);
        
        CGFloat width  = self.frame.size.width;
        CGFloat height = self.frame.size.height;
#ifdef kPMThemeSelectionCeilCoordinates
        CGFloat hDiff = ceil((width + shadowPadding.left + shadowPadding.right - innerPadding.width * 2) / 7);
        CGFloat vDiff = ceil((height - headerHeight - innerPadding.height * 2) / ((kPMThemeDayTitlesInHeader)?6:7));
#else        
        CGFloat hDiff = (width + shadowPadding.left + shadowPadding.right - innerPadding.width * 2) / 7;
        CGFloat vDiff = (height - headerHeight - innerPadding.height * 2) / ((kPMThemeDayTitlesInHeader)?6:7);
#endif

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
            CGRect rect = CGRectMake(innerPadding.width + floor(thisRowStartCell*hDiff) + kPMThemeSelectionOffset.horizontal
                                     , headerHeight + innerPadding.height + ceil((i + ((kPMThemeDayTitlesInHeader)?0:1))*vDiff) + kPMThemeSelectionOffset.vertical
                                     , floor((thisRowEndCell - thisRowStartCell + 1) * (hDiff)) + kPMThemeSelectionSizeInset.width
                                     , vDiff + kPMThemeSelectionSizeInset.height);
            UIBezierPath* selectedRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius: kPMThemeSelectionCornerRadius];
            CGContextSaveGState(context);
            [selectedRectPath addClip];
            CGContextDrawLinearGradient(context, gradient3
                                        , CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))
                                        , CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)), 0);
            CGContextRestoreGState(context);
            
            CGContextSaveGState(context);
//            CGContextSetShadowWithColor(context, backgroundShadowOffset, backgroundShadowBlurRadius, backgroundShadow);
            [darkColor setStroke];
            selectedRectPath.lineWidth = kPMThemeSelectionStrokeWidth;
            [selectedRectPath stroke];
            CGContextRestoreGState(context);
        }
        
        CGGradientRelease(gradient3);
        CGColorSpaceRelease(colorSpace);
    }
    PMLog(@"End");
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
