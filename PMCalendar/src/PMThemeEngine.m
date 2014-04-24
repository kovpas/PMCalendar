//
//  PMThemeEngine.m
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/22/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMThemeEngine.h"
#import "PMCalendarHelpers.h"
#import <CoreText/CoreText.h>

static PMThemeEngine* sharedInstance;

@interface PMThemeEngine ()

@property (nonatomic, strong) NSDictionary *themeDict;

+ (NSString *) keyNameForElementType:(PMThemeElementType) type;
+ (NSString *) keyNameForElementSubtype:(PMThemeElementSubtype) type;
+ (NSString *) keyNameForGenericType:(PMThemeGenericType) type;

@end

@implementation PMThemeEngine

@synthesize themeName = _themeName;
@synthesize themeDict = _themeDict;

@synthesize dayTitlesInHeader = _dayTitlesInHeader;
@synthesize defaultFont = _defaultFont;
@synthesize arrowSize = _arrowSize;
@synthesize shadowInsets = _shadowInsets;
@synthesize innerPadding = _innerPadding;
@synthesize outerPadding = _outerPadding;
@synthesize headerHeight = _headerHeight;
@synthesize cornerRadius = _cornerRadius;
@synthesize defaultSize = _defaultSize;
@synthesize shadowBlurRadius = _shadowBlurRadius;

+ (PMThemeEngine *) sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PMThemeEngine alloc] init];
    });
    
    return sharedInstance;
}

+ (UIColor *) colorFromString:(NSString *)colorString
{
    UIColor *color = nil;
    if ([colorString isKindOfClass:[NSString class]]) // plain color
    {
        if ([colorString hasSuffix:@".png"])
        {
            color = [UIColor colorWithPatternImage:[UIImage imageNamed:colorString]];
        }
        else
        {
            NSArray *elements = [colorString componentsSeparatedByString:@","];
            NSAssert([elements count] >= 3 && [elements count] <= 4, @"Wrong count of color components.");
            
            NSString *r = [elements objectAtIndex:0];
            NSString *g = [elements objectAtIndex:1];
            NSString *b = [elements objectAtIndex:2];
            
            if ([elements count] > 3) // R,G,B,A
            {
                NSString *a = [elements objectAtIndex:3];
                color = UIColorMakeRGBA([r floatValue], [g floatValue], [b floatValue], [a floatValue]);
            }
            else
            {
                color = UIColorMakeRGB([r floatValue], [g floatValue], [b floatValue]);
            }
        }
    }
    return color;
}

// draws vertical gradient
+ (void) drawGradientInContext:(CGContextRef) context
                        inRect:(CGRect) rect
                     fromArray:(NSArray *) gradientArray
{
    NSMutableArray *gradientColorsArray = [NSMutableArray arrayWithCapacity:[gradientArray count]];
    CGFloat gradientLocations[gradientArray.count];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // TODO: ADD CACHING! May be expensive!
    int i = 0;
    for (NSDictionary *colElement in gradientArray) 
    {
        NSString *color = [colElement elementInThemeDictOfGenericType:PMThemeColorGenericType];
        NSNumber *pos = [colElement elementInThemeDictOfGenericType:PMThemePositionGenericType];
        [gradientColorsArray addObject:(id)[PMThemeEngine colorFromString:color].CGColor];
        gradientLocations[i] = 1 - pos.floatValue;
        i++;
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace
                                                        , (__bridge CFArrayRef)gradientColorsArray
                                                        , gradientLocations);
    
    CGContextDrawLinearGradient(context
                                , gradient
                                , CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height)
                                , CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y)
                                , 0);
    CGGradientRelease(gradient);
//    CGColorSpaceRelease(colorSpace);
}

+ (NSString *) keyNameForElementType: (PMThemeElementType) type
{
    NSString *result = nil;
    
    switch (type) {
        case PMThemeGeneralElementType:
            result = @"General";
            break;
        case PMThemeBackgroundElementType:
            result = @"Background";
            break;
        case PMThemeSeparatorsElementType:
            result = @"Separators";
            break;
        case PMThemeMonthTitleElementType:
            result = @"Month title";
            break;
        case PMThemeDayTitlesElementType:
            result = @"Day titles";
            break;
        case PMThemeCalendarDigitsActiveElementType:
            result = @"Calendar digits active";
            break;
        case PMThemeCalendarDigitsActiveSelectedElementType:
            result = @"Calendar digits active selected";
            break;
        case PMThemeCalendarDigitsInactiveElementType:
            result = @"Calendar digits inactive";
            break;
        case PMThemeCalendarDigitsInactiveSelectedElementType:
            result = @"Calendar digits inactive selected";
            break;
        case PMThemeCalendarDigitsTodayElementType:
            result = @"Calendar digits today";
            break;
        case PMThemeCalendarDigitsTodaySelectedElementType:
            result = @"Calendar digits today selected";
            break;
        case PMThemeCalendarDigitsNotAllowedElementType:
            result = @"Calendar digits not allowed";
            break;
        case PMThemeMonthArrowsElementType:
            result = @"Month arrows";
            break;
        case PMThemeSelectionElementType:
            result = @"Selection";
            break;
        default:
            break;
    }
    
    return result;
}

+ (NSString *) keyNameForElementSubtype: (PMThemeElementSubtype) type
{
    NSString *result = nil;
    
    switch (type) {
        case PMThemeBackgroundSubtype:
            result = @"Background";
            break;
        case PMThemeMainSubtype:
            result = @"Main";
            break;
        case PMThemeOverlaySubtype:
            result = @"Overlay";
            break;
        default:
            break;
    }
    
    return result;
}

+ (NSString *) keyNameForGenericType: (PMThemeGenericType) type
{
    NSString *result = nil;
    
    switch (type) {
        case PMThemeColorGenericType:
            result = @"Color";
            break;
        case PMThemeFontGenericType:
            result = @"Font";
            break;
        case PMThemeFontNameGenericType:
            result = @"Name";
            break;
        case PMThemeFontSizeGenericType:
            result = @"Size";
            break;
        case PMThemeFontTypeGenericType:
            result = @"Type";
            break;
        case PMThemePositionGenericType:
            result = @"Position";
            break;
        case PMThemeOffsetGenericType:
            result = @"Offset";
            break;
        case PMThemeOffsetHorizontalGenericType:
            result = @"Horizontal";
            break;
        case PMThemeOffsetVerticalGenericType:
            result = @"Vertical";
            break;
        case PMThemeShadowGenericType:
            result = @"Shadow";
            break;
        case PMThemeShadowBlurRadiusType:
            result = @"Blur radius";
            break;
        case PMThemeSizeGenericType:
            result = @"Size";
            break;
        case PMThemeSizeWidthGenericType:
            result = @"Width";
            break;
        case PMThemeSizeHeightGenericType:
            result = @"Height";
            break;
        case PMThemeSizeInsetGenericType:
            result = @"Size inset";
            break;
        case PMThemeStrokeGenericType:
            result = @"Stroke";
            break;
        case PMThemeEdgeInsetsGenericType:
            result = @"Insets";
            break;
        case PMThemeEdgeInsetsTopGenericType:
            result = @"Top";
            break;
        case PMThemeEdgeInsetsLeftGenericType:
            result = @"Left";
            break;
        case PMThemeEdgeInsetsBottomGenericType:
            result = @"Bottom";
            break;
        case PMThemeEdgeInsetsRightGenericType:
            result = @"Right";
            break;
        case PMThemeCornerRadiusGenericType:
            result = @"Corner radius";
            break;
        case PMThemeCoordinatesRoundGenericType:
            result = @"Coordinates round";
            break;
        default:
            break;
    }
    
    return result;
}

- (void) setThemeName:(NSString *)themeName
{
    if ([_themeName isEqualToString:themeName])
    {
        return;
    }
    
    _themeName = themeName;
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:themeName ofType:@"plist"];
    self.themeDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSAssert(self.themeDict, @"FATAL ERROR: Cannot initialize theme! Please check that you have at least default theme added to your project.");
    
    NSDictionary *generalSettings = [sharedInstance themeDictForType:PMThemeGeneralElementType
                                                             subtype:PMThemeNoSubtype];
    
    self.dayTitlesInHeader = [[generalSettings objectForKey:@"Day titles in header"] boolValue];
    self.defaultFont = [[generalSettings elementInThemeDictOfGenericType:PMThemeFontGenericType] pmThemeGenerateFont];
    self.arrowSize = [[generalSettings objectForKey:@"Arrow size"] pmThemeGenerateSize];
    self.defaultSize = [[generalSettings objectForKey:@"Default size"] pmThemeGenerateSize];
    self.cornerRadius = [[generalSettings objectForKey:@"Corner radius"] floatValue];
    self.headerHeight = [[generalSettings objectForKey:@"Header height"] floatValue];
    self.outerPadding = [[generalSettings objectForKey:@"Outer padding"] pmThemeGenerateSize];
    self.innerPadding = [[generalSettings objectForKey:@"Inner padding"] pmThemeGenerateSize];
    self.shadowInsets = [[generalSettings objectForKey:@"Shadow insets"] pmThemeGenerateEdgeInsets];
    self.shadowBlurRadius = [[generalSettings objectForKey:@"Shadow blur radius"] floatValue];
}

- (void) drawString:(NSString *) string 
           withFont:(UIFont *) font
             inRect:(CGRect) rect 
     forElementType:(PMThemeElementType) themeElementType
            subType:(PMThemeElementSubtype) themeElementSubtype
          inContext:(CGContextRef) context
{
    NSDictionary *themeDictionary = [[PMThemeEngine sharedInstance] themeDictForType:themeElementType 
                                                                             subtype:themeElementSubtype];
    id colorObj = [themeDictionary elementInThemeDictOfGenericType:PMThemeColorGenericType];
    NSDictionary *shadowDict = [themeDictionary elementInThemeDictOfGenericType:PMThemeShadowGenericType];
    UIFont *usedFont = font;
    CGSize offset = [[themeDictionary elementInThemeDictOfGenericType:PMThemeOffsetGenericType] pmThemeGenerateSize];
    CGRect realRect = CGRectOffset(rect, offset.width, offset.height);

    if (!usedFont)
    {
        usedFont = [[themeDictionary elementInThemeDictOfGenericType:PMThemeFontGenericType] pmThemeGenerateFont];
    }

    if (!usedFont)
    {
        usedFont = self.defaultFont;
    }

    NSAssert(usedFont != nil, @"Please provide proper font either in theme file or in a code.");
    
    CGSize sz = CGSizeZero;
    if(usedFont)
    {
        sz = [string sizeWithAttributes:@{NSFontAttributeName:usedFont}];
    }
    
    
    
    BOOL isGradient = ![colorObj isKindOfClass:[NSString class]];
    CGSize shadowOffset = CGSizeZero;

    CGContextSaveGState(context);
    {
        if (shadowDict)
        {
            shadowOffset = [[shadowDict elementInThemeDictOfGenericType:PMThemeOffsetGenericType] pmThemeGenerateSize];
            UIColor *shadowColor = [PMThemeEngine colorFromString:[shadowDict elementInThemeDictOfGenericType:PMThemeColorGenericType]];
            [shadowColor set];
        }
        
        CGPoint textPoint = CGPointMake((int)(realRect.origin.x + (realRect.size.width - sz.width) / 2)
                                        , (int)(realRect.origin.y + realRect.size.height - 1));

        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)[usedFont fontName]
                                              , usedFont.pointSize
                                              , NULL);
        
        // Create an attributed string
        CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorFromContextAttributeName };
        CFTypeRef values[] = { font, kCFBooleanTrue };
        CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                                  sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFAttributedStringRef attrString = CFAttributedStringCreate(NULL, (__bridge CFStringRef)string, attr);
        CFRelease(attr);
        
        // Draw the string
        CTLineRef line = CTLineCreateWithAttributedString(attrString);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);  //Use this one when using standard view coordinates
        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0)); //Use this one if the view's coordinates are flipped
        if (!CGSizeEqualToSize(shadowOffset, CGSizeZero))
        {
            CGContextSetTextPosition(context
                                     , textPoint.x + shadowOffset.width
                                     , textPoint.y + shadowOffset.height);
            CGContextSetTextDrawingMode(context, kCGTextFill);
            CTLineDraw(line, context);
        }

        CGContextSetTextPosition(context, textPoint.x, textPoint.y);

        // Clean up
        if (isGradient)
        {
            CGContextSetTextDrawingMode(context, kCGTextClip);
            CTLineDraw(line, context);

            [PMThemeEngine drawGradientInContext: context
                                          inRect: CGRectMake(textPoint.x
                                                             , textPoint.y - usedFont.pointSize + 1
                                                             , sz.width
                                                             , usedFont.pointSize)
                                       fromArray: colorObj];
        }
        else
        {
            CGContextSetTextDrawingMode(context, kCGTextFill);
            [[PMThemeEngine colorFromString:colorObj] setFill];
            
            CTLineDraw(line, context);
        }
        
        CFRelease(line);
        CFRelease(attrString);
        CFRelease(font);
    }
    CGContextRestoreGState(context);
}

- (void) drawPath:(UIBezierPath *) path 
   forElementType:(PMThemeElementType) themeElementType
          subType:(PMThemeElementSubtype) themeElementSubtype
        inContext:(CGContextRef) context
{
    NSDictionary *themeDictionary = [[PMThemeEngine sharedInstance] themeDictForType:themeElementType 
                                                                             subtype:themeElementSubtype];
    id colorObj = [themeDictionary elementInThemeDictOfGenericType:PMThemeColorGenericType];

    NSDictionary *shadowDict = [themeDictionary elementInThemeDictOfGenericType:PMThemeShadowGenericType];
    CGContextSaveGState(context);
    {
        if (shadowDict)
        {
            CGSize shadowOffset = [[shadowDict elementInThemeDictOfGenericType:PMThemeOffsetGenericType] pmThemeGenerateSize];
            UIColor *shadowColor = [PMThemeEngine colorFromString:[shadowDict elementInThemeDictOfGenericType:PMThemeColorGenericType]];
            NSNumber *blurRadius = [shadowDict elementInThemeDictOfGenericType:PMThemeShadowBlurRadiusType];
            CGContextSetShadowWithColor(context
                                        , shadowOffset
                                        , blurRadius?[blurRadius floatValue]:sharedInstance.shadowBlurRadius
                                        , shadowColor.CGColor);
            if (![shadowDict objectForKey:@"Type"])
            {
                [shadowColor setFill];
                [path fill];
            }
        }
    }
    if (![shadowDict objectForKey:@"Type"])
    {
        CGContextRestoreGState(context);

        CGContextSaveGState(context);
    }
    {
        [path addClip];

        if ([colorObj isKindOfClass:[NSString class]]) // plain color
        {
            [[PMThemeEngine colorFromString:colorObj] setFill];
            
            [path fill];
        }
        else
        {
            [PMThemeEngine drawGradientInContext:context
                                          inRect:path.bounds
                                       fromArray:colorObj];
        }

        NSDictionary *stroke = [themeDictionary elementInThemeDictOfGenericType:PMThemeStrokeGenericType];
        
        if (stroke)
        {
            NSString *strokeColorStr = [stroke elementInThemeDictOfGenericType:PMThemeColorGenericType];
            UIColor *strokeColor = [PMThemeEngine colorFromString:strokeColorStr];
            [strokeColor setStroke];
            path.lineWidth = [[stroke elementInThemeDictOfGenericType:PMThemeSizeWidthGenericType] floatValue]; // TODO: make separate stroke width generic type

            [path stroke];
        }
    }
    CGContextRestoreGState(context);
}

- (id) elementOfGenericType:(PMThemeGenericType) genericType
                    subtype:(PMThemeElementSubtype) subtype
                       type:(PMThemeElementType) type
{
    return [[[PMThemeEngine sharedInstance] themeDictForType:type 
                                                     subtype:subtype] elementInThemeDictOfGenericType:genericType];
}

- (NSDictionary *) themeDictForType:(PMThemeElementType) type 
                            subtype:(PMThemeElementSubtype) subtype
{
    NSDictionary *result = [sharedInstance.themeDict objectForKey:[PMThemeEngine keyNameForElementType:type]];
    
    if (subtype != PMThemeNoSubtype)
    {
        result = [result objectForKey:[PMThemeEngine keyNameForElementSubtype:subtype]];
    }
    
    return result;
}

- (NSDictionary *) themeDict
{
    if (!_themeDict)
    {
        self.themeName = @"default";
    }
    
    return _themeDict;
}

@end

@implementation NSDictionary (PMThemeAddons)

- (id) elementInThemeDictOfGenericType:(PMThemeGenericType) type
{
    return [self objectForKey:[PMThemeEngine keyNameForGenericType:type]];
}

- (CGSize) pmThemeGenerateSize
{
    NSNumber *width = [self elementInThemeDictOfGenericType:PMThemeSizeWidthGenericType];
    NSNumber *height = [self elementInThemeDictOfGenericType:PMThemeSizeHeightGenericType];
    
    if (!width || !height)
    {
        return CGSizeZero;
    }
    
    NSAssert( [width isKindOfClass:[NSNumber class]], @"Expected numeric width value to generate CGSize" );
    NSAssert( [height isKindOfClass:[NSNumber class]], @"Expected numeric height value to generate CGSize" );
    
    return CGSizeMake([width floatValue], [height floatValue]);
}

- (UIFont *) pmThemeGenerateFont
{
    NSNumber *size = [self elementInThemeDictOfGenericType:PMThemeFontSizeGenericType];
    NSString *name = [self elementInThemeDictOfGenericType:PMThemeFontNameGenericType];
    
    if (!size)
    {
        return [PMThemeEngine sharedInstance].defaultFont;
    }
    
    NSAssert( [size isKindOfClass:[NSNumber class]], @"Expected numeric font size value to generate UIFont" );

    if (!name)
    {
        NSString *type = [self elementInThemeDictOfGenericType:PMThemeFontTypeGenericType];
        if ([type isEqualToString:@"bold"])
        {
            return [UIFont boldSystemFontOfSize:[size floatValue]];            
        }
        
        return [UIFont systemFontOfSize:[size floatValue]];
    }
    
    return [UIFont fontWithName:name size:[size floatValue]];
}

- (UIEdgeInsets) pmThemeGenerateEdgeInsets
{
    NSNumber *top = [self elementInThemeDictOfGenericType:PMThemeEdgeInsetsTopGenericType];
    NSNumber *left = [self elementInThemeDictOfGenericType:PMThemeEdgeInsetsLeftGenericType];
    NSNumber *bottom = [self elementInThemeDictOfGenericType:PMThemeEdgeInsetsBottomGenericType];
    NSNumber *right = [self elementInThemeDictOfGenericType:PMThemeEdgeInsetsRightGenericType];
    
    if (!top || !bottom || !left || !right)
    {
        return UIEdgeInsetsZero;
    }
    
    NSAssert( [top isKindOfClass:[NSNumber class]], @"Expected numeric top value to generate UIEdgeInsets" );
    NSAssert( [left isKindOfClass:[NSNumber class]], @"Expected numeric left value to generate UIEdgeInsets" );
    NSAssert( [bottom isKindOfClass:[NSNumber class]], @"Expected numeric bottom value to generate UIEdgeInsets" );
    NSAssert( [right isKindOfClass:[NSNumber class]], @"Expected numeric right value to generate UIEdgeInsets" );
    
    return UIEdgeInsetsMake([top floatValue], [left floatValue], [bottom floatValue], [right floatValue]);
}

@end

