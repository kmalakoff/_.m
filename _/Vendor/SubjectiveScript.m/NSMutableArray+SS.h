//
//  NSMutableArray+SS.h
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

#import "SSTypes.h"

@interface NSMutableArray (SS)

+ (A*)new_;
+ (A*(^)(UI capacity))newWithCapacity;
+ (A*(^)(const B* values))newB;
+ (A*(^)(const I* values))newI;
+ (A*(^)(const UI* values))newUI;
+ (A*(^)(const F* values))newF;
+ (A*(^)(const id* values))newO;

- (A*(^)(I index, id value))set;
- (A*(^)(id value))push;

@end

// terminators
#define AB_       (BOOL)2
#define AI_       (NSInteger)NSNotFound
#define AUI_      (NSUInteger)NSNotFound
#define AF_       (float)NaN
#define AO_       nil

// new array helpers
#define AB(...)   A.newB((B[]){__VA_ARGS__, AB_})
#define AI(...)   A.newI((I[]){__VA_ARGS__, AI_})
#define AUI(...)  A.newUI((UI[]){__VA_ARGS__, AUI_})
#define AF(...)   A.newF((F[]){__VA_ARGS__, AF_})
#define AO(...)   A.newO((id[]){__VA_ARGS__, AO_})