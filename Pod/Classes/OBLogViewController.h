//
//  OBLogViewController.h
//  OBLogger
//
//  Created by Farhad on 7/31/14.
//  Copyright (c) 2014 OneBeat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBLoggerCore.h"

@interface OBLogViewController : UIViewController
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *logView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

+(instancetype) instance;

- (IBAction)done:(id)sender;
- (IBAction)clearLog:(id)sender;

@end
