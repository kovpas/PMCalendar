//
//  PMViewController.m
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMViewController.h"
#import "PMCalendar.h"

@interface PMViewController ()

@property (nonatomic, strong) PMCalendarController *pmCC;

@end

@implementation PMViewController

@synthesize pmCC;

@synthesize periodLabel;

- (IBAction)showCalendar:(id)sender
{
    self.pmCC = [[PMCalendarController alloc] init];
    pmCC.delegate = self;
    pmCC.mondayFirstDayOfWeek = YES;

    [pmCC presentCalendarFromView:sender 
         permittedArrowDirections:PMCalendarArrowDirectionAny 
                         animated:YES];
/*    [pmCC presentCalendarFromRect:[sender frame]
                           inView:[sender superview]
         permittedArrowDirections:PMCalendarArrowDirectionAny
                         animated:YES];*/
    [self calendarController:pmCC didChangePeriod:pmCC.period];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    periodLabel.text = [NSString stringWithFormat:@"%@ - %@"
                        , [newPeriod.startDate dateStringWithFormat:@"dd-MM-yyyy"]
                        , [newPeriod.endDate dateStringWithFormat:@"dd-MM-yyyy"]];
}

@end
