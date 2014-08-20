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

+ (NSBundle *)frameworkBundle {
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
    // Do any additional setup after loading the view from its nib.
     
}

-(void) viewWillAppear:(BOOL)animated
{
    [self displayLog];
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
    while ( line = [e nextObject] ) {
//    for ( NSString *line in logLines ) {
        line = [line stringByAppendingString:@"\n"];
        switch ([[OBLogger instance] lineLogLevel:line] ) {
            case OBErrorLevel:
                logString = [logString initWithString:line attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
                break;
            case OBWarnLevel:
                logString = [logString initWithString:line attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]}];
                break;
            case OBEventLevel:
                logString = [logString initWithString:line attributes:@{NSBackgroundColorAttributeName: [UIColor blueColor],NSForegroundColorAttributeName: [UIColor yellowColor] }];
                break;
            case OBDebugLevel:
                logString = [logString initWithString:line attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
                break;
            default:
                logString = [logString initWithString:line attributes:nil];
                break;
        }
        [fullString appendAttributedString:logString];
        
    }
    self.logView.attributedText = fullString;
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearLog:(id)sender {
    [[OBLogger instance] reset];
    [self displayLog];
}

@end
