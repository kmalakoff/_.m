//
//  NSDate+JavaScript.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/29/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSDate+JavaScript.h"
// #import "ISO8601DateFormatter.h" // REVIEW: should this be part of the library?

@implementation NSDate (JavaScript)

+ (Date*(^)(I year, I month, I day))newYMD_JS
{
  return ^(I year, I month, I day) {
    NSDateComponents *components = NSDateComponents.new;
    components.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    components.year = year;
    components.month = month+1;
    components.day = day;

    return components.date;
  };
}

- (NSS*(^)())toString
{
  return ^{
    return [[Date ISO8601Writter] stringFromDate:self];
  };
}

+ (NSDateFormatter*)ISO8601Writter
{
  static NSDateFormatter *singleton = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSCalendar *utcCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    utcCalendar.timeZone = utcTimeZone;

    singleton = NSDateFormatter.new;
    singleton.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.000'Z'";
    singleton.timeZone = utcTimeZone;
    singleton.calendar = utcCalendar;
    singleton.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
  });
  return singleton;
}

//+ (NSDateFormatter*)ISO8601Parser
//{
//  static ISO8601DateFormatter *singleton = nil;
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    NSCalendar *utcCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    utcCalendar.timeZone = utcTimeZone;
//
//    singleton = ISO8601DateFormatter.new;
//    singleton.format = ISO8601DateFormatCalendar;
//    singleton.defaultTimeZone = utcTimeZone;
//    singleton.includeTime = YES;
//  });
//  return (NSDateFormatter*) singleton;
//}

@end
