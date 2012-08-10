//
//  PMThemeShadow.m
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/23/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMThemeShadow.h"
#import "PMThemeEngine.h"
#import "PMTheme.h"

@implementation PMThemeShadow

@synthesize color = _color;
@synthesize offset = _offset;
@synthesize blurRadius = _blurRadius;

- (id) initWithShadowDict:(NSDictionary *) shadowDict
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    self.color = [PMThemeEngine colorFromString:[shadowDict elementInThemeDictOfGenericType:PMThemeColorGenericType]];
    self.offset = [[shadowDict elementInThemeDictOfGenericType:PMThemeOffsetGenericType] pmThemeGenerateSize];
    NSNumber *blurRadiusNumber = [shadowDict elementInThemeDictOfGenericType:PMThemeShadowBlurRadiusType];
    
    if (!blurRadiusNumber)
    {
        self.blurRadius = kPMThemeShadowBlurRadius;
    }
    else 
    {
        self.blurRadius = [blurRadiusNumber floatValue];
    }
    
    
    return self;
}

@end
