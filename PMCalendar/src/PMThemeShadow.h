//
//  PMThemeShadow.h
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/23/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMThemeShadow : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGSize offset;
@property (nonatomic, assign) CGFloat blurRadius;

- (id) initWithShadowDict:(NSDictionary *) shadowDict;

@end
