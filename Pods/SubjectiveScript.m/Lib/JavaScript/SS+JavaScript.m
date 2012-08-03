//
//  SS+JavaScript.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/22/12.
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

#import "SS+JavaScript.h"
#import "NSObject+JavaScript.h"
#import "NSNumber+SS.h"
#import "NSMutableString+SS.h"
#import "SS+Functions.h"
#import "SS+Types.h"
#import "SSArguments.h"

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

const NSS* SSJSTypeOfObject = @"object";
const NSS* SSJSTypeOfString = @"string";
const NSS* SSJSTypeOfNumber = @"number";
const NSS* SSJSTypeOfBoolean = @"boolean";

@implementation SS (JavaScript)

// JSON
+ (NSS*(^)(NSO* obj))stringify
{
  return ^NSS*(NSO* obj) {
    if (SS.isNull(obj))
      return @"null";
    if (SS.isString(obj))
      return [NSString stringWithFormat:@"\"%@\"", obj];
    if (SS.isObject(obj)) {
      NSD* dictionary = (NSD*)obj;
      __block S* result = S.newS(@"{");

      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [result appendString:self.stringify(key)];
        [result appendString:@":"];
        [result appendString:self.stringify(obj)];
      }];
      
      [result appendString:@"}"];
      return result;
    }
    if (SS.isArray(obj)) {
      NSA* array = (NSA*)obj;
      __block S* result = S.newS(@"[");
      BOOL writeSeparator = NO;

      for(NSO* item in array) {
        if (writeSeparator)
          [result appendString:@","];
        [result appendString:self.stringify(item)];
        writeSeparator = YES;
      };
      
      [result appendString:@"]"];
      return result;
    }
  
    return obj.toString();
  };
}

// functions
+ (id(^)(id function, id arg1, ... /* NIL_TERMINATED*/))call
{
  return ^id(id function, id arg1, ... /* NIL_TERMINATED*/) {
    ARGS_AO(arguments, arg1);
    return SS.callFunction(function, arguments);
  };
}

+ (id(^)(id function, NSA* arguments))apply
{
  return ^id(id function, NSA* arguments) {
    return SS.callFunction(function, arguments);
  };
}


// global functions
+ (N*(^)(NSS* string))parseInt
{
  return ^N*(NSS* string) {
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    I result;
    if([scan scanInteger:&result] && [scan isAtEnd]) 
      return N.I(result);
    return nil;
  };
}

+ (const NSS*(^)(id obj))typeof_
{
  return ^const NSS*(id obj) {
    if (SS.isArray(obj) || SS.isObject(obj) || SS.isDate(obj)) return SSJSTypeOfObject;
    if (SS.isString(obj)) return SSJSTypeOfString;
    if (SS.isNumber(obj)) return ((N*)obj).isBoolean() ? SSJSTypeOfBoolean : SSJSTypeOfNumber;
    if (SS.isNumber(obj)) return ((N*)obj).isBoolean() ? SSJSTypeOfBoolean : SSJSTypeOfNumber;
    
    NSLog(@"unrecognized type for typeof_");
    return @"unknown type";
  };
}

+ (void(^)(NSO* message))alert
{
  return ^(NSO* message) {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"alert" message:message.toString() delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
  [alertView show];
#elif TARGET_OS_MAC
  NSAlert *alert = [NSAlert alertWithMessageText:@"alert" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", message.toString()];
  [alert beginSheetModalForWindow:NSApplication.sharedApplication.mainWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
#endif
  };
}

// timeouts
+ (SSTimeout*(^)(SSTaskIdBlock block, I waitNS))setTimeout
{
  return ^(SSTaskIdBlock block, I waitNS) {
    return SS.addTask(block, waitNS, false);
  };
}
+ (SSTimeout*(^)(SSTaskIdBlock block, I waitNS))setTimeoutBackground
{
  return ^(SSTaskIdBlock block, I waitNS) {
    return SS.addTask(block, waitNS, true);
  };
}

+ (void(^)(SSTimeout* timeout))clearTimeout
{
  return ^(SSTimeout* timeout) {
    return SS.stopTask(timeout);
  };
}
@end