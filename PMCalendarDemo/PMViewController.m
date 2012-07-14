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

- (void)viewDidAppear:(BOOL)animated
{
    pmCC = [[PMCalendarController alloc] init];
    [pmCC presentCalendarFromRect:CGRectZero
                           inView:self.view
         permittedArrowDirections:0 
                         animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
