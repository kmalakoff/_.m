//
//  SSTypes.h
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

#import <Foundation/Foundation.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>

// fundamental types
typedef BOOL            B;
typedef NSInteger       I;
typedef NSUInteger      UI;
typedef float           F;
typedef double          D;
typedef id              KV[2];  // key-value pair

// object types
#define NSO             NSObject
#define A               NSMutableArray
#define NSA             NSArray
#define O               NSMutableDictionary
#define NSD             NSDictionary
#define S               NSMutableString
#define NSS             NSString
#define Date            NSDate
#define N               NSNumber
#define E               NSException

// number helpers
#define NF_NaN              [NSNumber numberWithFloat:NAN]
#define NF_POS_INFINITY     [NSNumber numberWithFloat:INFINITY]
#define NF_NEG_INFINITY     [NSNumber numberWithFloat:-INFINITY]

// tasks and timeouts
typedef NSNumber SSTaskId;
typedef SSTaskId SSTimeout;

// blocks
typedef void                (^SSDispatchBlock)();
typedef void                (^SSTaskIdBlock)();
typedef id                  (^SSGetOrAddBlock)();
typedef NSComparisonResult  (^SSSortBlock)(id left, id right);