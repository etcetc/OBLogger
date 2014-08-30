//
//  OBLogger.m
//  FileTransferPlay
//
//  Created by Farhad on 6/23/14.
//  Copyright (c) 2014 NoPlanBees. All rights reserved.
//

#import "OBLoggerCore.h"
#import "OBLoggerNotification.h"

@interface OBLogger()
@property (nonatomic,strong) NSString * logFilePath;
@property (nonatomic,strong) NSFileHandle * logFileHandle;
@end

// Why a separate class for logger?
// So we can conigure and implement its functionality  - for example, we could write to a log file that we download ourselves, or
// we can pop up the error message as a main thread Alert, or any of a number of other things
@implementation OBLogger

+(instancetype) instance
{
    static OBLogger * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OBLogger alloc] init];
    });
    return instance;
}

-(void) logApplicationEvents: (BOOL) doLog
{
    if ( doLog ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appGotMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appFinishedLuanching) name:UIApplicationDidFinishLaunchingNotification object:nil];
        
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
    }
}

-(void) event: (NSString *) message
{
    [self write:message atLevel:OBEventLevel];
    if ( self.writeToConsole )
        NSLog(@"EVENT: %@",message);
}


-(void) error: (NSString *) message
{
    [self write:message atLevel:OBErrorLevel];
    [[NSNotificationCenter defaultCenter] postNotificationName:OBLoggerErrorNotification object:message];
    if ( self.writeToConsole )
        NSLog(@"**** ERROR: %@",message);
}

-(void) warn: (NSString *) message
{
    [self write:message atLevel:OBWarnLevel];
    [[NSNotificationCenter defaultCenter] postNotificationName:OBLoggerWarnNotification object:message];
    if ( self.writeToConsole )
        NSLog(@"## WARN: %@",message);
}


-(void) info: (NSString *) message
{
    [self write:message atLevel:OBInfoLevel];
    if ( self.writeToConsole )
        NSLog(@"INFO: %@",message);
}

-(void) debug: (NSString *) message
{
    [self write:message atLevel:OBDebugLevel];
    if ( self.writeToConsole )
        NSLog(@"DEBUG: %@",message);
}

// Let's log events specially so we can really highlight them
-(void) logEvent: (OBLogEvent) event
{
    switch (event) {
        case OBLogEventAppBackground:
            [self event: [NSString stringWithFormat:@"APP ENTERED BACKGROUND"]];
            break;
        case OBLogEventAppStarted:
            [self event: [NSString stringWithFormat:@"APP STARTED"]];
            break;

        case OBLogEventAppForeground:
            [self event: [NSString stringWithFormat:@"APP ENTERED FOREGROUND"]];
            break;
            
        case OBLogEventAppActive:
            [self event: [NSString stringWithFormat:@"APP BECAME ACTIVE"]];
            break;
            
        case OBLogEventAppTerminate:
            [self event: [NSString stringWithFormat:@"APP ABOUT TO TERMINATE"]];
            break;
            
        default:
            break;
    }
}

// Reset the logFile
-(void) reset
{
    [self.logFileHandle truncateFileAtOffset:0L];
}

-(NSString *) logPrefix
{
//    TODO: the static variable may be bogus here.  May need to declar this as a variable in the implementation class
    static NSDateFormatter * _formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [NSDateFormatter new];
        _formatter.timeStyle = NSDateFormatterMediumStyle;
        _formatter.dateStyle = NSDateFormatterShortStyle;
    });
    return [_formatter stringFromDate:[NSDate date]];
}

// Return the log file handle and go to the end of the file
-(NSFileHandle *) logFileHandle
{
    if ( _logFileHandle == nil ) {
        _logFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.logFilePath];
        [_logFileHandle seekToEndOfFile];
    }
    return _logFileHandle;
}

-(void) write: (NSString *) message atLevel: (OBLogLevel) level
{
    NSString *logLevel;
    switch (level) {
        case OBDebugLevel:
            logLevel = @"DEBUG";
            break;
        case OBInfoLevel:
            logLevel = @"INFO";
            break;
        case OBWarnLevel:
            logLevel = @"WARN";
            break;
        case OBErrorLevel:
            logLevel = @"ERROR";
            break;
        case OBEventLevel:
            logLevel = @"EVENT";
            break;
        default:
            break;
    }
    NSString *line = [NSString stringWithFormat:@"%@ %@: %@\n",[self logPrefix],logLevel,message];
    [self.logFileHandle writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
    [self.logFileHandle synchronizeFile];
}

// Given a log line, return what type it is!
// NOTE: We'll call any line that is all CAPS to be an event.
-(OBLogLevel) lineLogLevel: (NSString *) logLine
{
    NSRange x;
    if ( [logLine rangeOfString:@"DEBUG"].location != NSNotFound )
        return OBDebugLevel;
    else if ([logLine rangeOfString:@"EVENT"].location != NSNotFound )
        return OBEventLevel;
    else if ((x =[logLine rangeOfString:@"INFO"]).location != NSNotFound ) {
//        NSString * message = [logLine substringFromIndex:x.location + x.length + 1];
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[^a-z]+$" options:0 error:nil];
//        if ( [regex matchesInString:message options:0 range:NSMakeRange(0, message.length)].count > 0 ) {
//            return OBEventLevel;
//        } else
            return OBInfoLevel;
        
    }
    else if ([logLine rangeOfString:@"WARN"].location != NSNotFound )
        return OBWarnLevel;
    else if ([logLine rangeOfString:@"ERROR"].location != NSNotFound )
        return OBErrorLevel;
    else
        return OBUnknownLevel;
}

// Returns an array of lines of log
-(NSArray *) logLines
{
    NSError * error;
    NSString *log = @"";
    if ( [[NSFileManager defaultManager] fileExistsAtPath:self.logFilePath] ) {
        log  = [NSString stringWithContentsOfFile:[self logFilePath] encoding:NSUTF8StringEncoding error:&error];
        if ( error != nil )
            [NSException raise:@"Error reading log file" format:@"Expected location: %@", self.logFilePath];
    }
    return [log componentsSeparatedByString:@"\n"];
}

// Return the log file path
-(NSString *) logFilePath
{
    if ( _logFilePath == nil ) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _logFilePath = [documentsDirectory stringByAppendingPathComponent:@"obLogger.log"];
        NSLog(@"OBLogger Log File = %@", _logFilePath);
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:_logFilePath] ) {
            [[NSFileManager defaultManager] createFileAtPath:_logFilePath contents:nil attributes:@{}];
        }
    }
    return _logFilePath;
}

#pragma mark -- Notification handlers

// Could handle all of these by implementing the method called when the object's message handler is not found...

-(void) appWillEnterForeground
{
    [self event:@"App Will Enter Foreground "];
}

-(void) appBecameActive
{
    [self event:@"App Became Active"];
}

-(void) appWillTerminate
{
    [self event:@"App Will Terminate"];
}

-(void) appWillResignActive
{
    [self event:@"App Will Resign Active"];
    
}

-(void) appDidEnterBackground
{
    [self event:@"App Entered Background"];
}

-(void) appGotMemoryWarning
{
    [self event:@"App Received a Memory Warning"];
}

-(void) appFinishedLuanching
{
    [self event:@"App Finished Launching"];
}

@end
