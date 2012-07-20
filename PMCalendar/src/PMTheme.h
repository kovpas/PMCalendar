//
//  PMTheme.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/19/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMCalendarHelpers.h"

#ifdef MIMIC_APPLE_THEME

#define kPMThemeArrowSize (CGSize){0, 0}
#define kPMThemeOuterPadding (CGSize){0, 0}

                                        // top, left, bottom, right
#define kPMThemeShadowInsets (UIEdgeInsets){0 ,    0,  10.0f,    0}
#define kPMThemeCornerRadius 0
#define kPMThemeHeaderHeight 45.0f
#define kPMThemeInnerPadding (CGSize){0, 0}

#define kPMThemeDefaultSize (CGSize){320, 309}

#define kPMThemeBackgroundColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]
#define kPMThemeBackgroundInnerShadowColor [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0]

#define kPMThemeBackgoundOverlayGradientColors [NSArray arrayWithObjects: \
            (id)[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0].CGColor, \
            (id)[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0].CGColor, nil]
#define kPMThemeBackgoundOverlayGradientColorLocations {0, 1}

#define kPMThemeBackgroundTodayColor UIColorMakeRGB(115, 137, 165)
#define kPMThemeBackgroundTodayStrokeWidth 2
#define kPMThemeBackgroundTodayStrokeColor UIColorMakeRGB(54, 79, 114)
#define kPMThemeBackgroundTodayOffset (UIOffset){0, -1}
#define kPMThemeBackgroundTodaySizeInset (CGSize){1, 1}
#define kPMThemeBackgroundTodayInnerShadowColor UIColorMakeRGB(0, 0, 0)
#define kPMThemeBackgroundTodayInnerShadowOffset (UIOffset){1, 1}
#define kPMThemeBackgroundTodayInnerShadowBlurRadius 5

#define kPMThemeBackgroundTodaySelectedColor UIColorMakeRGB(25, 128, 229)
#define kPMThemeBackgroundTodayStrokeSelectedColor UIColorMakeRGB(54, 79, 114)

#define kPMThemeDayTitlesInHeader YES
#define kPMThemeShadowsBlurRadius 0

#define kPMThemeMonthTitleFont [UIFont boldSystemFontOfSize:22.0f]
#define kPMThemeMonthTitleColor UIColorMakeRGB(84, 84, 84)
#define kPMThemeMonthTitleShadowColor [UIColor whiteColor]
#define kPMThemeMonthTitleShadowOffset (UIOffset){0, 1}
#define kPMThemeMonthTitleVerticalOffset -5

#define kPMThemeDayTitlesFont [UIFont boldSystemFontOfSize:10.0f] 
#define kPMThemeDayTitlesColor UIColorMakeRGB(84, 84, 84)
#define kPMThemeDayTitlesShadowColor [UIColor whiteColor]
#define kPMThemeDayTitlesShadowOffset (UIOffset){0, 1}
#define kPMThemeDayTitlesVerticalOffset -27 // todo: fix!

#define kPMThemeCalendarDigitsFont [UIFont boldSystemFontOfSize:24.0f] // nil - default
#define kPMThemeCalendarDigitsColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"text_fill@2x.png"]]
#define kPMThemeCalendarDigitsShadowColor [UIColor whiteColor]
#define kPMThemeCalendarDigitsShadowOffset (UIOffset){0, .5}
#define kPMThemeCalendarDigitsVerticalOffset -2
#define kPMThemeCalendarDigitsHorizontalOffset 0

#define kPMThemeCalendarDigitsInactiveColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"dim_text_fill@2x.png"]]
#define kPMThemeCalendarDigitsInactiveShadowColor [UIColor colorWithWhite:1 alpha:0.25]
#define kPMThemeCalendarDigitsInactiveShadowOffset (UIOffset){0, 1}

#define kPMThemeCalendarDigitsSelectedColor [UIColor whiteColor]
#define kPMThemeCalendarDigitsSelectedShadowColor UIColorMakeRGB(35, 76, 117)
#define kPMThemeCalendarDigitsSelectedShadowOffset (UIOffset){0, -1}

#define kPMThemeCalendarDigitsTodayColor [UIColor whiteColor]
#define kPMThemeCalendarDigitsTodayShadowColor UIColorMakeRGB(35, 76, 117)
#define kPMThemeCalendarDigitsTodayShadowOffset (UIOffset){0, 1}

#define kPMThemeMonthArrowSize (CGSize){12, 15}
#define kPMThemeMonthArrowColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"arrow_fill@2x.png"]]
#define kPMThemeMonthArrowShadowColor [UIColor whiteColor]
#define kPMThemeMonthArrowShadowOffset (UIOffset){0, 0.5}
#define kPMThemeMonthArrowVerticalOffset -5
#define kPMThemeMonthArrowHorizontalOffset -3

// we don't want separators as long as they are already drawn on a background
#define kPMThemeSeparatorWidth 0
#define kPMThemeSeparatorColor [UIColor lightGrayColor]
#define kPMThemeSeparatorShadowColor [UIColor colorWithWhite:1 alpha:0.25]
#define kPMThemeSeparatorShadowOffset (UIOffset){0, 0}

#define kPMThemeBoxStrokeColor nil

#define kPMThemeSelectionCornerRadius 0
#define kPMThemeSelectionGradientColors [NSArray arrayWithObjects: \
            (id)UIColorMakeRGB(0, 114, 226).CGColor, \
            (id)UIColorMakeRGB(0, 114, 226).CGColor, \
            (id)UIColorMakeRGB(43, 138, 231).CGColor, \
            (id)UIColorMakeRGB(114, 177, 239).CGColor, nil]
#define kPMThemeSelectionGradientColorLocations {0, 0.499, 0.5, 1}
#define kPMThemeSelectionStrokeWidth 1
#define kPMThemeSelectionStrokeColor UIColorMakeRGB(41, 54, 73)
#define kPMThemeSelectionOffset (UIOffset){-0.5, -0.5}
#define kPMThemeSelectionSizeInset (CGSize){0, 0}
#define kPMThemeSelectionCeilCoordinates YES

#else
 
 
//default theme
 
#define kPMThemeArrowSize (CGSize){18, 11}
#define kPMThemeOuterPadding (CGSize){0, 0}

                                        // top, left, bottom, right
#define kPMThemeShadowInsets (UIEdgeInsets){3.0f, 3.0f, 3.0f, 0.0f}

#define kPMThemeCornerRadius 10.0f
#define kPMThemeHeaderHeight 40.0f
#define kPMThemeInnerPadding (CGSize){10, 10}

#define kPMThemeDefaultSize (CGSize){260, 200}

#define kPMThemeBackgroundColor [UIColor colorWithWhite:0.2 alpha: 1]
#define kPMThemeBackgroundInnerShadowColor [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.56]
 
#define kPMThemeBackgoundOverlayGradientColors [NSArray arrayWithObjects: \
            (id)[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.45].CGColor, \
            (id)[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.15].CGColor, nil]
#define kPMThemeBackgoundOverlayGradientColorLocations {0, 1}

#define kPMThemeDayTitlesInHeader NO
#define kPMThemeShadowsBlurRadius 1

#define kPMThemeMonthTitleFont nil
#define kPMThemeMonthTitleColor [UIColor whiteColor]
#define kPMThemeMonthTitleShadowColor [UIColor blackColor]
#define kPMThemeMonthTitleShadowOffset (UIOffset){0, 0}
#define kPMThemeMonthTitleVerticalOffset 0

#define kPMThemeDayTitlesFont nil
#define kPMThemeDayTitlesColor kPMThemeMonthTitleColor
#define kPMThemeDayTitlesShadowColor kPMThemeMonthTitleShadowColor
#define kPMThemeDayTitlesShadowOffset kPMThemeMonthTitleShadowOffset
#define kPMThemeDayTitlesVerticalOffset kPMThemeMonthTitleVerticalOffset

#define kPMThemeCalendarDigitsFont nil // nil - default
#define kPMThemeCalendarDigitsColor [UIColor whiteColor]
#define kPMThemeCalendarDigitsShadowColor [UIColor blackColor]
#define kPMThemeCalendarDigitsShadowOffset (UIOffset){0, 1}
#define kPMThemeCalendarDigitsVerticalOffset -7 // shouldn't be :(
#define kPMThemeCalendarDigitsHorizontalOffset -1

#define kPMThemeCalendarDigitsInactiveColor [UIColor colorWithWhite:0.6f alpha:1.0f]
#define kPMThemeCalendarDigitsInactiveShadowColor [UIColor blackColor]
#define kPMThemeCalendarDigitsInactiveShadowOffset (UIOffset){1, 1}

#define kPMThemeCalendarDigitsTodayColor [UIColor colorWithRed: 0.98 green: 0.24 blue: 0.09 alpha: 1]
#define kPMThemeCalendarDigitsTodayShadowColor [UIColor blackColor]
#define kPMThemeCalendarDigitsTodayShadowOffset (UIOffset){0, 1}

#define kPMThemeMonthArrowSize (CGSize){6, 8}
#define kPMThemeMonthArrowColor [UIColor whiteColor]
//#define kPMThemeMonthArrowShadowColor - undefined. means no shadow
#define kPMThemeMonthArrowShadowOffset (UIOffset){0, 0}
#define kPMThemeMonthArrowVerticalOffset 0
#define kPMThemeMonthArrowHorizontalOffset -6 // -6 for left arrow, +6 for right

#define kPMThemeSeparatorWidth 0.5
#define kPMThemeSeparatorColor [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.27]
#define kPMThemeSeparatorShadowColor [UIColor blackColor]
#define kPMThemeSeparatorShadowOffset (UIOffset){-1, 0}

#define kPMThemeBoxStrokeColor [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.59]

#define kPMThemeSelectionCornerRadius 10.0f

#define kPMThemeSelectionGradientColors [NSArray arrayWithObjects: \
            (id)[UIColor colorWithRed: 0.82 green: 0.08 blue: 0 alpha: 0.86].CGColor, \
            (id)[UIColor colorWithRed: 0.66 green: 0.02 blue: 0.04 alpha: 0.88].CGColor, nil]
#define kPMThemeSelectionGradientColorLocations {0, 1}
#define kPMThemeSelectionStrokeWidth 0.5
#define kPMThemeSelectionStrokeColor [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.72]
#define kPMThemeSelectionOffset (UIOffset){2, 2}
#define kPMThemeSelectionSizeInset (CGSize){-4, -4}

#endif
