//
//  PMThemeEngine.h
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/22/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PMThemeElementType {
    PMThemeGeneralElementType = 0,
    PMThemeBackgroundElementType,
    PMThemeSeparatorsElementType,
    PMThemeMonthArrowsElementType,
    PMThemeMonthTitleElementType,
    PMThemeDayTitlesElementType,
    PMThemeCalendarDigitsActiveElementType,
    PMThemeCalendarDigitsActiveSelectedElementType,
    PMThemeCalendarDigitsInactiveElementType,
    PMThemeCalendarDigitsInactiveSelectedElementType,
    PMThemeCalendarDigitsTodayElementType,
    PMThemeCalendarDigitsTodaySelectedElementType,
    PMThemeCalendarDigitsNotAllowedElementType,
    PMThemeSelectionElementType,
} PMThemeElementType;

typedef enum PMThemeElementSubtype {
    PMThemeNoSubtype = -1,
    PMThemeBackgroundSubtype,
    PMThemeMainSubtype,
    PMThemeOverlaySubtype,
} PMThemeElementSubtype;

typedef enum PMThemeGenericType {
    PMThemeColorGenericType,
    PMThemeFontGenericType,
    PMThemeFontNameGenericType,
    PMThemeFontSizeGenericType,
    PMThemeFontTypeGenericType,
    PMThemePositionGenericType,
    PMThemeShadowGenericType,
    PMThemeShadowBlurRadiusType,
    PMThemeOffsetGenericType,
    PMThemeOffsetHorizontalGenericType,
    PMThemeOffsetVerticalGenericType,
    PMThemeSizeInsetGenericType,
    PMThemeSizeGenericType,
    PMThemeSizeWidthGenericType,
    PMThemeSizeHeightGenericType,
    PMThemeStrokeGenericType,
    PMThemeEdgeInsetsGenericType,
    PMThemeEdgeInsetsTopGenericType,
    PMThemeEdgeInsetsLeftGenericType,
    PMThemeEdgeInsetsBottomGenericType,
    PMThemeEdgeInsetsRightGenericType,
    PMThemeCornerRadiusGenericType,
    PMThemeCoordinatesRoundGenericType,
} PMThemeGenericType;

@interface PMThemeEngine : NSObject

@property (nonatomic, strong) NSString *themeName;

/** defaults **/
@property (nonatomic, strong) UIFont *defaultFont;
@property (nonatomic, assign) BOOL dayTitlesInHeader;
@property (nonatomic, assign) UIEdgeInsets shadowInsets;
@property (nonatomic, assign) CGSize innerPadding;
@property (nonatomic, assign) CGSize outerPadding;
@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGSize defaultSize;
@property (nonatomic, assign) CGFloat shadowBlurRadius;

+ (PMThemeEngine *) sharedInstance;
+ (UIColor *) colorFromString:(NSString *)colorString;

- (void) drawString:(NSString *) string
           withFont:(UIFont *) font
             inRect:(CGRect) rect
     forElementType:(PMThemeElementType) themeElementType
            subType:(PMThemeElementSubtype) themeElementSubtype
          inContext:(CGContextRef) context;

- (void) drawPath:(UIBezierPath *) path 
   forElementType:(PMThemeElementType) themeElementType
          subType:(PMThemeElementSubtype) themeElementSubtype
        inContext:(CGContextRef) context;

- (id) elementOfGenericType:(PMThemeGenericType) genericType
                    subtype:(PMThemeElementSubtype) subtype
                       type:(PMThemeElementType) type;

- (NSDictionary *) themeDictForType:(PMThemeElementType) type 
                            subtype:(PMThemeElementSubtype) subtype;

@end

@interface NSDictionary (PMThemeAddons)

- (id) elementInThemeDictOfGenericType:(PMThemeGenericType) type;
- (CGSize) pmThemeGenerateSize;
// UIOffset is available from iOS 5.0 :(. Using CGSize instead.
//- (UIOffset) pmThemeGenerateOffset;
- (UIEdgeInsets) pmThemeGenerateEdgeInsets;
- (UIFont *) pmThemeGenerateFont;

@end
