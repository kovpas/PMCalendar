//
//  PMDimmingView.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/18/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMCalendarController;

/**
 * PMDimmingView is an internal class.
 *
 * PMDimmingView is a view which is shown below the calendar. It catches  
 * user interaction outside of the calendar and dismisses calendar. 
 */
@interface PMDimmingView : UIView

@property (nonatomic, strong) PMCalendarController *controller;

- (id)initWithFrame:(CGRect)frame controller:(PMCalendarController*)controller;

@end
