//
//  OBLogViewController.h
//  OBLogger
//
//  Created by Farhad on 7/31/14.
//  Copyright (c) 2014 OneBeat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBLoggerCore.h"

@interface OBLogViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *logView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIPickerView *levelPicker;
@property (weak, nonatomic) IBOutlet UILabel *currentLevel;
@property (nonatomic) OBLogLevel logLevelsToShow;

+(instancetype) instance;

- (IBAction)done:(id)sender;
- (IBAction)clearLog:(id)sender;
- (IBAction)pickLevel:(id)sender;
- (IBAction)levelPicked:(id)sender;

@end
