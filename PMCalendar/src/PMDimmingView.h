//
//  PMDimmingView.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/18/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMCalendarController;
@interface PMDimmingView : UIView

@property (nonatomic, strong) PMCalendarController *controller;

- (id)initWithFrame:(CGRect)frame controller:(PMCalendarController*)controller;

@end
