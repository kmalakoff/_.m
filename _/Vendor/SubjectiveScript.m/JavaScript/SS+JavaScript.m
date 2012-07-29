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
#import "SS+Functions.h"
#import "SSArguments.h"

@implementation SS (JavaScript)

// JSON
+ (NSS*(^)(NSO* obj))stringify { return ^(NSO* obj) { return obj.toString(); }; }

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

// timeouts
+ (SSTaskId*(^)(SSTaskIdBlock block, I waitNS))setTimeout
{
  return ^(SSTaskIdBlock block, I waitNS) {
    return SS.addTask(block, waitNS, false);
  };
}
+ (SSTaskId*(^)(SSTaskIdBlock block, I waitNS))setTimeoutBackground
{
  return ^(SSTaskIdBlock block, I waitNS) {
    return SS.addTask(block, waitNS, true);
  };
}

+ (void(^)(SSTaskId* timeout))clearTimeout
{
  return ^(SSTaskId* timeout) {
    return SS.stopTask(timeout);
  };
}
@end