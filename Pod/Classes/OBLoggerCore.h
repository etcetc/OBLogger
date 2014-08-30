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
    OBUnknownLevel = 0,
    OBDebugLevel = 2<<0,
    OBInfoLevel = 2<<1,
    OBWarnLevel = 2<<2,
    OBErrorLevel = 2<<3,
    OBEventLevel = 2<<4
};

// Deprecated!
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
#define OB_EVENT(message,...) [[OBLogger instance] event:[NSString stringWithFormat:(message),##__VA_ARGS__]]
#endif

@interface OBLogger : NSObject

+(instancetype) instance;

@property (nonatomic) BOOL writeToConsole;

-(NSArray *) logLines;

-(OBLogLevel) lineLogLevel: (NSString *) logLine;

// You will probably prefer to use the macros instead of these
-(void) error: (NSString *) message;
-(void) warn: (NSString *) message;
-(void) info: (NSString *) message;
-(void) debug: (NSString *) message;
-(void) event: (NSString *) message;

// use this one to log discrete events as defined above, typically associated with app state changes
-(void) logEvent: (OBLogEvent)event;

-(void) reset;
-(void) logApplicationEvents: (BOOL) doLog;
-(NSString *) logFilePath;

@end

#endif
