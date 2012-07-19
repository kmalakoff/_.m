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
+ (A*(^)(const B* values))newBA;
+ (A*(^)(const I* values))newIA;
+ (A*(^)(const UI* values))newUIA;
+ (A*(^)(const F* values))newFA;
+ (A*(^)(const id* values))newOA;

- (A*(^)(id value))push;

@end

// terminators
#define BA_       (BOOL)2
#define IA_       (NSInteger)NSNotFound
#define UIA_      (NSUInteger)NSNotFound
#define FA_       (float)NaN
#define OA_       nil

// new array helpers
#define BA(...)   A.newBA((B[]){__VA_ARGS__, BA_})
#define IA(...)   A.newIA((I[]){__VA_ARGS__, IA_})
#define UIA(...)  A.newUIA((UI[]){__VA_ARGS__, UIA_})
#define FA(...)   A.newFA((F[]){__VA_ARGS__, FA_})
#define OA(...)   A.newOA((id[]){__VA_ARGS__, OA_})