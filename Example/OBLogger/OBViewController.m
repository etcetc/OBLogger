//
//  OBViewController.m
//  OBLoggerTest
//
//  Created by Farhad on 8/2/14.
//  Copyright (c) 2014 OneBeat. All rights reserved.
//

#import "OBViewController.h"
#import <OBLOgger/OBLogger.h>

@interface OBViewController ()

@end

@implementation OBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    OB_INFO(@"View loaded");
    OB_DEBUG(@"Debug Message");
    OB_WARN(@"Let's throw in a warning Message: WATCH OUT");
    OB_ERROR(@"Error Message but I'm going to make it very long so that we know how it looks when it wraps");
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showLog:(id)sender {
    OBLogViewController *logViewer = [OBLogViewController instance];
    [self presentViewController:logViewer animated:YES completion:nil];
}
@end
