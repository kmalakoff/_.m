//
//  _Wrapper+Arrays.h
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
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

#import "_Wrapper.h"

@interface _Wrapper (Arrays)

- (NSO*(^)(I n))first;
- (NSO*(^)(I n))head;
- (NSO*(^)(I n))take;

- (NSA*(^)(I n))initial;

- (NSO*(^)(I n))last;

- (NSA*(^)(I index))rest;
- (NSA*(^)(I index))tail;

- (A*(^)())compact;

- (A*(^)(BOOL shallow))flatten;
 
- (A*(^)(id value1, ...))without; // TODO: nil terminated

- (A*(^)(NSA* array1, ...))union_;  /* RESERVED KEYWORD 'union' -> 'union_' */ // TODO: nil terminated

- (A*(^)(NSA* array1, ...))intersection; // TODO: nil terminated

- (A*(^)(NSA* array1, ...))difference; // TODO: nil terminated

- (A*(^)())uniq;
- (A*(^)(B isSorted, _MapBlock iterator))uniq3; /* SPECIALIZED */
- (A*(^)(B isSorted, _MapBlock iterator))unique;

- (A*(^)(NSA* array1, ...))zip; // TODO: nil terminated

// zipObject /* NO OO-STYLE WRAPPER VERSION */

- (I(^)(id value))indexOf;
- (I(^)(id value))indexOfSorted; /* SPECIALIZED */

- (I(^)(id value))lastIndexOf;

// range1 /* NO OO-STYLE WRAPPER VERSION */
// range /* NO OO-STYLE WRAPPER VERSION */

@end
