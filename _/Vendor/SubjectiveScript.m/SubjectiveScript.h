//
//  SubjectiveScript.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
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

#if !__has_feature(objc_arc)
# error SubjectiveScript.m requires Automatic Reference Counting to be enabled
#endif

// core
#import "SS.h"
#import "NSDictionary+NamedProperties.h"

// helpers
#import "SSArguments.h"
#import "NSString+Versioning.h"
#import "SS+Functions.h"
#import "SS+System.h"

// types and extensions
#import "SSTypes.h"
#import "SS+Types.h"
#import "NSObject+SS.h"
#import "NSArray+SS.h"
#import "NSMutableArray+SS.h"
#import "NSDictionary+SS.h"
#import "NSMutableDictionary+SS.h"
#import "NSString+SS.h"
#import "NSMutableString+SS.h"
#import "NSNumber+SS.h"
#import "NSDate+SS.h"

// JavaScript Emulation
#import "SS+JavaScript.h"
#import "NSObject+JavaScript.h"
#import "NSArray+JavaScript.h"
#import "NSMutableArray+JavaScript.h"
#import "NSDictionary+JavaScript.h"
#import "NSMutableDictionary+JavaScript.h"
#import "NSString+JavaScript.h"
#import "NSMutableString+JavaScript.h"
#import "NSNumber+JavaScript.h"
#import "NSDate+JavaScript.h"