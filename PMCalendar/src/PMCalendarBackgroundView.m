//
//  PMCalendarBackgroundView.m
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMCalendarBackgroundView.h"
#import "PMCalendarConstants.h"

static CGFloat cornerRadiusW = 11.0f;
static CGFloat cornerRadiusH = 10.0f;
static CGFloat shadowPadding = 3.0f;
CGFloat headerHeight = 50.0f;
CGSize innerPadding = (CGSize){10, 5};

static UIImage* bgImage;

@interface PMGradientOverlayWithSeparators : UIView

@end

@implementation PMCalendarBackgroundView

+ (UIBezierPath*) createBezierPathForSize:(CGSize) size
{
    UIBezierPath* result = [UIBezierPath bezierPath];
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    [result moveToPoint: CGPointMake(shadowPadding, shadowPadding + height - cornerRadiusH)];
    [result addCurveToPoint: CGPointMake(shadowPadding + cornerRadiusW, shadowPadding + height)
              controlPoint1: CGPointMake(shadowPadding, shadowPadding + height - cornerRadiusH + 6.05) 
              controlPoint2: CGPointMake(shadowPadding + 4.48, shadowPadding + height)];
    
    [result addLineToPoint: CGPointMake(shadowPadding + width - cornerRadiusW, shadowPadding + height)];
    [result addCurveToPoint: CGPointMake(shadowPadding + width, shadowPadding + height - cornerRadiusH)
              controlPoint1: CGPointMake(shadowPadding + width - 4.48, shadowPadding + height)
              controlPoint2: CGPointMake(shadowPadding + width, shadowPadding + height - cornerRadiusH + 6.05)];
    [result addLineToPoint: CGPointMake(shadowPadding + width, shadowPadding + cornerRadiusH)];
    [result addCurveToPoint: CGPointMake(shadowPadding + width - cornerRadiusW, shadowPadding)
              controlPoint1: CGPointMake(shadowPadding + width, shadowPadding + cornerRadiusH - 6.05) 
              controlPoint2: CGPointMake(shadowPadding + width - 4.48, shadowPadding)];
    [result addLineToPoint: CGPointMake(shadowPadding + cornerRadiusW, shadowPadding)];
    [result addCurveToPoint: CGPointMake(shadowPadding, shadowPadding + cornerRadiusH) 
              controlPoint1: CGPointMake(shadowPadding + 4.48, shadowPadding)
              controlPoint2: CGPointMake(shadowPadding, shadowPadding + cornerRadiusH - 6.05)];
    [result addLineToPoint: CGPointMake(shadowPadding, shadowPadding + height - cornerRadiusH)];
    
    [result closePath];
    
    return result;
};

+ (void) createBGImage
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat width = 90;
    CGFloat height = 90;
    
    // create a bitmap graphics context the size of the image
    UIGraphicsBeginImageContext(CGSizeMake(width, height));

//    context = CGBitmapContextCreate( NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast );
    CGContextRef context = UIGraphicsGetCurrentContext();
    width -= shadowPadding * 2;
    height -= shadowPadding * 2;
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);    
    
    if ( context == NULL ) 
    {
        return;
    }
    
    //// Color Declarations
    UIColor* bigBoxInnerShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.56];
    UIColor* backgroundLightColor = [UIColor colorWithWhite:0.2 alpha: 1];
        
    //// Shadow Declarations
    CGColorRef bigBoxInnerShadow = bigBoxInnerShadowColor.CGColor;
    CGSize bigBoxInnerShadowOffset = CGSizeMake(0, 1);
    CGFloat bigBoxInnerShadowBlurRadius = 1;
    CGColorRef backgroundShadow = [UIColor blackColor].CGColor;
    CGSize backgroundShadowOffset = CGSizeMake(1, 1);
    CGFloat backgroundShadowBlurRadius = 2;
    
//    CGFloat width = self.frame.size.width - shadowPadding * 2;
//    CGFloat height = self.frame.size.height - shadowPadding * 2;
    
    //////// Draws background of popover    
    
    UIBezierPath *roundedRectanglePath = [PMCalendarBackgroundView createBezierPathForSize:CGSizeMake(width, height)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, backgroundShadowOffset, backgroundShadowBlurRadius, backgroundShadow);
    [backgroundLightColor setFill];
    [roundedRectanglePath fill];
    
    ////// background Inner Shadow
    CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds]
                                                    , -bigBoxInnerShadowBlurRadius
                                                    , -bigBoxInnerShadowBlurRadius);
    roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect
                                              , -bigBoxInnerShadowOffset.width
                                              , -bigBoxInnerShadowOffset.height);
    roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect
                                                         , [roundedRectanglePath bounds]), -1, -1);
    
    UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
    [roundedRectangleNegativePath appendPath: roundedRectanglePath];
    roundedRectangleNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = bigBoxInnerShadowOffset.width + round(roundedRectangleBorderRect.size.width);
        CGFloat yOffset = bigBoxInnerShadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset)
                                               , yOffset + copysign(0.1, yOffset)),
                                    bigBoxInnerShadowBlurRadius,
                                    bigBoxInnerShadow);
        
        [roundedRectanglePath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width)
                                                                       , 0);
        [roundedRectangleNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [roundedRectangleNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    UIBezierPath *roundedRectangle2Path = [PMCalendarBackgroundView createBezierPathForSize:CGSizeMake(width, height)];
    CGContextSaveGState(context);
    [roundedRectangle2Path addClip];
    CGContextRestoreGState(context);
    
    //// Cleanup
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef bitmapContext = CGBitmapContextCreateImage( context );
    CGContextRelease( context );
    
    // convert the finished resized image to a UIImage 
    bgImage = [UIImage imageWithCGImage:bitmapContext];
    // image is retained by the property setting above, so we can 
    // release the original
    CGImageRelease(bitmapContext);
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }
    
    if (!bgImage)
    {
        [PMCalendarBackgroundView createBGImage];
    }
    
    UIImage *background = [bgImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.image = background;
    bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:bgImageView];
    
    PMGradientOverlayWithSeparators *overlay = [[PMGradientOverlayWithSeparators alloc] initWithFrame:self.bounds];
    overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlay.backgroundColor = [UIColor clearColor];
    [self addSubview:overlay];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return self;
}


@end

@implementation PMGradientOverlayWithSeparators

- (void)drawRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor* darkColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.45];
    UIColor* lightColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.15];
    UIColor* lineLightColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.27];
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(-1, -0);
    CGFloat shadowBlurRadius = 0;
    UIColor* boxStroke = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.59];
    
    //// Gradient Declarations
    NSArray* gradient2Colors = [NSArray arrayWithObjects: 
                                (id)darkColor.CGColor, 
                                (id)lightColor.CGColor, nil];
    CGFloat gradient2Locations[] = {0, 1};
    CGGradientRef gradient2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient2Colors, gradient2Locations);
    
    CGFloat width = self.frame.size.width - shadowPadding * 2;
    CGFloat height = self.frame.size.height - shadowPadding * 2;
    UIBezierPath *roundedRectanglePath = [PMCalendarBackgroundView createBezierPathForSize:CGSizeMake(width, height)];
    [boxStroke setStroke];
    roundedRectanglePath.lineWidth = 0.5;
    [roundedRectanglePath stroke];
    
    //Dividers
    CGFloat hDiff = (width + shadowPadding * 2 - innerPadding.width * 2) / 7;

    for(int i = 0; i < 6; i++) {
        //// divider Drawing
        UIBezierPath* dividerPath = [UIBezierPath bezierPathWithRect:
                                     CGRectMake(floor(innerPadding.width + shadowPadding + (i + 1) * hDiff) - 1
                                                , innerPadding.height + shadowPadding + headerHeight
                                                , 0.5
                                                , height - innerPadding.height * 2 - headerHeight)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
        [lineLightColor setFill];
        [dividerPath fill];
        CGContextRestoreGState(context);
    }
    
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context
                                , gradient2
                                , CGPointMake(width / 2, shadowPadding + self.frame.size.height)
                                , CGPointMake(width / 2, shadowPadding), 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient2);
    CGColorSpaceRelease(colorSpace);
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

@end

