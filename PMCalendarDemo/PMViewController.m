//
//  PMViewController.m
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMViewController.h"
#import "PMCalendar.h"
#import "NSDate+Helpers.h"

@interface PMViewController ()

@property (nonatomic, strong) PMCalendarController *pmCC;

@end

@implementation PMViewController

@synthesize pmCC;

@synthesize periodLabel;

- (void)viewDidAppear:(BOOL)animated
{
    self.pmCC = [[PMCalendarController alloc] init];
    pmCC.delegate = self;
    pmCC.mondayFirstDayOfWeek = YES;
    [pmCC presentCalendarFromRect:CGRectZero
                           inView:self.view
         permittedArrowDirections:PMCalendarArrowDirectionDown
                         animated:YES];
    
    // Update period label
    [self calendarController:pmCC didChangePeriod:pmCC.period];
}

- (IBAction)randomResize:(id)sender
{
    NSInteger increment = 5;
    if ([sender tag] < 0)
    {
        increment = -5;
    }
    
    CGSize currentSize = self.pmCC.size;
    CGSize tmpSize = CGSizeZero;
    tmpSize.width = currentSize.width + increment;
    tmpSize.height = currentSize.height + increment;
    
    currentSize.width = MIN(MAX( 250, tmpSize.width ), 320);
    currentSize.height = MIN(MAX( 200, tmpSize.height ), 320);
    
    [self.pmCC setSize:currentSize];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    periodLabel.text = [NSString stringWithFormat:@"%@ - %@"
                        , [newPeriod.startDate dateStringWithFormat:@"dd-MM-yyy"]
                        , [newPeriod.endDate dateStringWithFormat:@"dd-MM-yyy"]];
}

@end
