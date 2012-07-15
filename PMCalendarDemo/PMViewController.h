//
//  PMViewController.h
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCalendar.h"

@interface PMViewController : UIViewController <PMCalendarControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *periodLabel;
- (IBAction)randomResize:(id)sender;

@end
