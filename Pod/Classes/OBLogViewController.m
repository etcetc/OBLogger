//
//  OBLogViewController.m
//  OBLogger
//
//  Created by Farhad on 7/31/14.
//  Copyright (c) 2014 OneBeat. All rights reserved.
//

#import "OBLogViewController.h"

@interface OBLogViewController ()

@end

@implementation OBLogViewController

+ (NSBundle *)frameworkBundle
{
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"OBLogger.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}


+(instancetype) instance
{
    static OBLogViewController * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithNibName: @"OBLogViewController" bundle: [[self class] frameworkBundle]];
        }
    );
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ( self.logLevelsToShow == 0 )
        [self setShowLogLevel:OBDebugLevel];
    self.currentLevel.text = [self logLevelAsString: self.logLevelsToShow];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self displayLog];
    self.levelPicker.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) displayLog
{
    NSAttributedString * logString = [NSMutableAttributedString new];
    NSArray *logLines = [[OBLogger instance] logLines];
    NSMutableAttributedString * fullString =[NSMutableAttributedString new];
    NSEnumerator *e = [logLines reverseObjectEnumerator];
    NSString *line;
    NSString *appendString = @"";
    while ( line = [e nextObject] ) {
        line = [line stringByAppendingString:@"\n"];
        line = [line stringByAppendingString:appendString];
        logString = [logString initWithString:@""];
        switch ([[OBLogger instance] lineLogLevel:line] ) {
            case OBEventLevel:
                if ( [self showLogLevel: OBEventLevel] )
                    logString = [logString initWithString:line attributes:@{NSBackgroundColorAttributeName: [UIColor blueColor],NSForegroundColorAttributeName: [UIColor yellowColor] }];
                appendString = @"";
                break;
            case OBErrorLevel:
                if ( [self showLogLevel: OBErrorLevel] )
                    logString = [logString initWithString:line attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
                appendString = @"";
                break;
            case OBWarnLevel:
                if ( [self showLogLevel: OBWarnLevel] )
                    logString = [logString initWithString:line attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]}];
                appendString = @"";
                break;
            case OBInfoLevel:
                if ( [self showLogLevel: OBInfoLevel] )
                    logString = [logString initWithString:line attributes:nil];
                appendString = @"";
                break;
            case OBDebugLevel:
                if ( [self showLogLevel: OBDebugLevel] )
                    logString = [logString initWithString:line attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
                appendString = @"";
                break;
            default:
//                We didnt find a valid log leve so we're assuming there were line breaks in the previous line
//                Add the string to the beginning because we're going backwards
                appendString = line;
//                logString = [logString initWithString:line attributes:nil];
                break;
        }
        [fullString appendAttributedString:logString];
        
    }
    self.logView.attributedText = fullString;
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearLog:(id)sender
{
    [[OBLogger instance] reset];
    [self displayLog];
}

- (IBAction)pickLevel:(id)sender
{
    self.levelPicker.hidden = NO;
}

-(BOOL) showLogLevel: (OBLogLevel) level
{
    return self.logLevelsToShow & level;
}

#pragma mark -- Picker View

+(NSArray *) logLevels
{
    static NSArray * _logLevels;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _logLevels = @[@"Event",@"Error",@"Warn",@"Info",@"Debug"];
    });
    return _logLevels;
}

-(OBLogLevel) levelForStringLevel: (NSString *) level
{
    NSDictionary *index = @{
                            @"Event": [NSNumber numberWithInt:OBEventLevel],
                            @"Error": [NSNumber numberWithInt:OBErrorLevel],
                            @"Warn": [NSNumber numberWithInt:OBWarnLevel],
                            @"Info": [NSNumber numberWithInt:OBInfoLevel],
                            @"Debug": [NSNumber numberWithInt:OBDebugLevel]
                           };
    return (OBLogLevel)[index[level] integerValue];
}

-(NSString *) logLevelAsString: (OBLogLevel) level
{
    NSDictionary *index = @{
                            [NSNumber numberWithInt:OBEventLevel]: @"Event",
                            [NSNumber numberWithInt:OBErrorLevel]: @"Error" ,
                            [NSNumber numberWithInt:OBWarnLevel]: @"Warn",
                            [NSNumber numberWithInt:OBInfoLevel]: @"Info" ,
                            [NSNumber numberWithInt:OBDebugLevel]: @"Debug"
                            };
    return index[[NSNumber numberWithInt:level]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self class] logLevels].count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self class] logLevels][row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *logLevel = [[self class] logLevels][row];
    
    [self setShowLogLevel:[self levelForStringLevel: logLevel]] ;
    self.levelPicker.hidden = YES;
    [self displayLog];
}

-(void) setShowLogLevel: (OBLogLevel) logLevel
{
    self.logLevelsToShow = 0;
    //    NOTE: no breaks in this switch statement because when we show debug level, we want to also show
    //    everything else...
    switch ( logLevel ) {
        case OBDebugLevel:
            self.logLevelsToShow += OBDebugLevel;
            
        case OBInfoLevel:
            self.logLevelsToShow += OBInfoLevel;
            
        case OBWarnLevel:
            self.logLevelsToShow += OBWarnLevel;
            
        case OBErrorLevel:
            self.logLevelsToShow += OBErrorLevel;
            
        case OBEventLevel:
            self.logLevelsToShow += OBEventLevel;
            
        default:
            break;
    }

}
@end
