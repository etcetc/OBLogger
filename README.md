# OBLogger

[![CI Status](http://img.shields.io/travis/etcetc/OBLogger.svg?style=flat)](https://travis-ci.org/etcetc/OBLogger)
[![Version](https://img.shields.io/cocoapods/v/OBLogger.svg?style=flat)](http://cocoadocs.org/docsets/OBLogger)
[![License](https://img.shields.io/cocoapods/l/OBLogger.svg?style=flat)](http://cocoadocs.org/docsets/OBLogger)
[![Platform](https://img.shields.io/cocoapods/p/OBLogger.svg?style=flat)](http://cocoadocs.org/docsets/OBLogger)

OBLogger provides a super-simple set of macros and methods for logging DEBUG, WARN, INFO, and ERROR messages on the iPhone or iPad.  It's primarily designed to help in alpha or beta-test debugging: the messages are saved to a log file, which you can then presumably retrieve.  Alternatively, you can rig up a button to present the color-coded log file in the provided view controller.  See the Example code for details.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.  Please review the example project for 
examples of API usage.  

### API

Include <OBLogger/OBLogger.h> in whichever files you wish to use the logger in.  The header defines a number of macros:
 + OB_EVENT(): for logging events of interest (you can also configure the logger to handle app lifecycle events automatically)
 + OB_ERROR(): for logging errors - not that this generates a notification event OBLoggerErrorNotification which you can subscribe to, so you can display the error
 + OB_ERROR(): for logging warnings - not that this generates a notification event OBLoggerWarnNotification which you can subscribe to, so you can display the warning
 + OB_INFO(): for logging general information - typically the information that shows how the app is behaving
 + OB_DEBUG(): for logging debugging information - this information may be useful when something goes wrong but is often too noisy for normal log viewing

### Showing the logfile

To show the log file, you configure a trigger and upon the trigger present the OBViewController.  The viewcontroller shows its TextView, color-coding the different types of log messages, and allowing you to filter on different levels.

Again, the best demonstration is in OBViewController.m in the Example.

## Requirements

None.  This is standalone.

## Installation

OBLogger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "OBLogger"

## Author

etcetc, ff@onebeat.com

## TO DO

Ummm, tests...

## License

OBLogger is available under the MIT license. See the LICENSE file for more info.

