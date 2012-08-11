//
//  PMTheme.h
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/19/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMCalendarHelpers.h"
#import "PMThemeEngine.h"

#define kPMThemeHeaderHeight [PMThemeEngine sharedInstance].headerHeight
#define kPMThemeDefaultFont [PMThemeEngine sharedInstance].defaultFont
#define kPMThemeInnerPadding [PMThemeEngine sharedInstance].innerPadding
#define kPMThemeShadowPadding [PMThemeEngine sharedInstance].shadowInsets
#define kPMThemeShadowBlurRadius [PMThemeEngine sharedInstance].shadowBlurRadius
#define kPMThemeDayTitlesInHeader [PMThemeEngine sharedInstance].dayTitlesInHeader
#define kPMThemeDayTitlesInHeaderIntOffset ((kPMThemeDayTitlesInHeader)?0:1)
#define kPMThemeCornerRadius [PMThemeEngine sharedInstance].cornerRadius
#define kPMThemeArrowSize [PMThemeEngine sharedInstance].arrowSize
#define kPMThemeOuterPadding [PMThemeEngine sharedInstance].outerPadding


#ifdef MIMIC_APPLE_THEME

// 226,226,228 (0)
// 204,203,208 (1)


#define kPMThemeBackgroundTodayColor UIColorMakeRGB(115, 137, 165)
#define kPMThemeBackgroundTodayStrokeWidth 2
#define kPMThemeBackgroundTodayStrokeColor UIColorMakeRGB(54, 79, 114)
#define kPMThemeBackgroundTodayOffset (UIOffset){0, -1}
#define kPMThemeBackgroundTodaySizeInset (CGSize){1, 1}
#define kPMThemeBackgroundTodayInnerShadowColor UIColorMakeRGB(0, 0, 0)
#define kPMThemeBackgroundTodayInnerShadowOffset (UIOffset){1, 1}
#define kPMThemeBackgroundTodayInnerShadowBlurRadius 5


#define kPMThemeCalendarDigitsTodayColor [UIColor whiteColor]
#define kPMThemeCalendarDigitsTodayShadowColor UIColorMakeRGB(35, 76, 117)
#define kPMThemeCalendarDigitsTodayShadowOffset (UIOffset){0, 1}


#define kPMThemeSelectionCeilCoordinates YES

#endif
