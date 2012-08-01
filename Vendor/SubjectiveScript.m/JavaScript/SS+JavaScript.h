//
//  SS+JavaScript.h
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

#import "SS.h"
#import "SS+System.h"

@interface SS (JavaScript)

// JSON
+ (NSS*(^)(NSO* obj))stringify;

// functions
+ (id(^)(id function, id arg1, ... /* NIL_TERMINATED*/))call;
+ (id(^)(id function, NSA* arguments))apply;

// global functions
+ (N*(^)(NSS* string))parseInt;
+ (const NSS*(^)(id obj))typeof_;
+ (void(^)(NSO* message))alert;

// timeouts
+ (SSTimeout*(^)(SSTaskIdBlock block, I waitNS))setTimeout;
+ (SSTimeout*(^)(SSTaskIdBlock block, I waitNS))setTimeoutBackground;
+ (void(^)(SSTimeout* timeout))clearTimeout;

@end
