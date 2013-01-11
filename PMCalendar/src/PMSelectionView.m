//
//  PMSelectionView.m
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMSelectionView.h"
#import "PMCalendarConstants.h"
#import "PMTheme.h"

@interface PMSelectionView ()

@property (nonatomic, assign) CGRect initialFrame;

@end

@implementation PMSelectionView

@synthesize startIndex = _startIndex;
@synthesize endIndex = _endIndex;
@synthesize initialFrame = _initialFrame;

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
    self.initialFrame = frame;
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if((_startIndex >= 0) || (_endIndex >= 0)) 
    {
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGFloat cornerRadius = [[[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeCornerRadiusGenericType
                                                                             subtype:PMThemeBackgroundSubtype
                                                                                type:PMThemeSelectionElementType] floatValue];

        UIEdgeInsets shadowPadding = kPMThemeShadowPadding;
        CGSize innerPadding        = kPMThemeInnerPadding;
        CGFloat headerHeight       = kPMThemeHeaderHeight;
        
        CGFloat width  = _initialFrame.size.width;
        CGFloat height = _initialFrame.size.height;
        CGFloat hDiff = (width + shadowPadding.left + shadowPadding.right - innerPadding.width * 2) / 7;
        CGFloat vDiff = (height - headerHeight - innerPadding.height * 2) / (kPMThemeDayTitlesInHeaderIntOffset + 6);


        NSString *coordinatesRound = [[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeCoordinatesRoundGenericType
                                                                                  subtype:PMThemeBackgroundSubtype
                                                                                     type:PMThemeSelectionElementType];

        if (coordinatesRound)
        {
            if ([coordinatesRound isEqualToString:@"ceil"])
            {
                hDiff = ceil(hDiff);
                vDiff = ceil(vDiff);
            }
            else if ([coordinatesRound isEqualToString:@"floor"])
            {
                hDiff = floor(hDiff);
                vDiff = floor(vDiff);
            }
        }

        int tempStart = MAX(MIN(_startIndex, _endIndex), 0);
        int tempEnd = MAX(_startIndex, _endIndex);
        
        int rowStart = tempStart / 7;
        int rowEnd = tempEnd / 7;
        int colStart = tempStart % 7;
        int colEnd = tempEnd % 7;
        UIEdgeInsets rectInset = [[[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeEdgeInsetsGenericType
                                                                               subtype:PMThemeBackgroundSubtype
                                                                                  type:PMThemeSelectionElementType] pmThemeGenerateEdgeInsets];
        
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
            CGRect rect = CGRectMake(innerPadding.width + floor(thisRowStartCell * hDiff)
                                     , innerPadding.height + headerHeight
                                            + floor((i + kPMThemeDayTitlesInHeaderIntOffset) * vDiff)
                                     , floor((thisRowEndCell - thisRowStartCell + 1) * hDiff)
                                     , floor(vDiff));
            rect = UIEdgeInsetsInsetRect(rect, rectInset);

            UIBezierPath* selectedRectPath = [UIBezierPath bezierPathWithRoundedRect: rect
                                                                        cornerRadius: cornerRadius];
            [[PMThemeEngine sharedInstance] drawPath: selectedRectPath
                                      forElementType: PMThemeSelectionElementType
                                             subType: PMThemeBackgroundSubtype
                                           inContext: context];
        }
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
