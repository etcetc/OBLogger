//
//  OBLoggerCore.h
//  OBLogger
//
//  Created by Farhad on 8/13/14.
//  Copyright (c) 2014 OneBeat. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef OBLoggerCore_h
#define OBLoggerCore_h

typedef NS_ENUM(NSUInteger, OBLogLevel) {
    OBUnknownLevel,
    OBDebugLevel,
    OBInfoLevel,
    OBWarnLevel,
    OBErrorLevel,
    OBEventLevel
};

typedef NS_ENUM(NSUInteger, OBLogEvent) {
    OBLogEventAppStarted,
    OBLogEventAppBackground,
    OBLogEventAppForeground,
    OBLogEventAppInactive,
    OBLogEventAppActive,
    OBLogEventAppTerminate
};

// Define some macros

#ifndef OB_ERROR
#define OB_ERROR(message,...) [[OBLogger instance] error:[NSString stringWithFormat:(message),##__VA_ARGS__]]
#endif

#ifndef OB_WARN
#define OB_WARN(message,...) [[OBLogger instance] warn:[NSString stringWithFormat:(message),##__VA_ARGS__]]
#endif

#ifndef OB_INFO
#define OB_INFO(message,...) [[OBLogger instance] info:[NSString stringWithFormat:(message),##__VA_ARGS__]]
#endif

#ifndef OB_DEBUG
#define OB_DEBUG(message,...) [[OBLogger instance] debug:[NSString stringWithFormat:(message),##__VA_ARGS__]]
#endif

#ifndef OB_EVENT
#define OB_EVENT(event) [[OBLogger instance] logEvent: event]
#endif

@interface OBLogger : NSObject

+(instancetype) instance;

@property (nonatomic) BOOL writeToConsole;

-(NSArray *) logLines;

-(OBLogLevel) lineLogLevel: (NSString *) logLine;

// You will probably prefer to use the macros instead of these
-(void) error: (NSString *) error;
-(void) warn: (NSString *) error;
-(void) info: (NSString *) error;
-(void) debug: (NSString *) error;

// use this one to log discrete events as defined above, typically associated with app state changes
-(void) logEvent: (OBLogEvent)event;

-(void) reset;
-(NSString *) logFilePath;

@end

#endif
