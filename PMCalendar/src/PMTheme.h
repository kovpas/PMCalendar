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
