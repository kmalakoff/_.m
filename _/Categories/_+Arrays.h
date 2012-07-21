//
//  _+Arrays.h
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

#import "_.h"

@interface _ (Arrays)

+ (NSO*(^)(NSA* array, I n))first;
+ (NSO*(^)(NSA* array, I n))head;
+ (NSO*(^)(NSA* array, I n))take;
+ (NSO*(^)(NSA* array, KH kh))firstIterator; /* SPECIALIZED */

+ (NSA*(^)(NSA* array, I n))initial;
+ (NSA*(^)(NSA* array, KH kh))initialIterator; /* SPECIALIZED */

+ (NSO*(^)(NSA* array, I n))last;
+ (NSO*(^)(NSA* array, KH kh))lastIterator; /* SPECIALIZED */

+ (NSA*(^)(NSA* array, I index))rest;
+ (NSA*(^)(NSA* array, I index))tail;
+ (NSA*(^)(NSA* array, KH kh))restIterator; /* SPECIALIZED */

+ (A*(^)(NSA* array))compact;

+ (A*(^)(NSA* array, BOOL shallow))flatten;
 
+ (A*(^)(NSA* array, id value1, ...))without; // TODO: nil terminated

+ (A*(^)(NSA* array, ...))union_; /* RESERVED KEYWORD 'union' -> 'union_' */ // TODO: nil terminated

+ (A*(^)(NSA* array, NSA* array1, ...))intersection; // TODO: nil terminated

+ (A*(^)(NSA* array, NSA* array1, ...))difference; // TODO: nil terminated

+ (A*(^)(NSA* array))uniq;
+ (A*(^)(NSA* array, B isSorted, _MapBlock iterator))uniq3; /* SPECIALIZED */
+ (A*(^)(NSA* array, B isSorted, _MapBlock iterator))unique;

+ (A*(^)(NSA* array, ...))zip; // TODO: nil terminated

+ (O*(^)(NSA* keys, NSA* values))zipObject;

+ (I(^)(NSA* array, id value))indexOf;
+ (I(^)(NSA* array, id value))indexOfSorted; /* SPECIALIZED */

+ (I(^)(NSA* array, id value))lastIndexOf;

+ (A*(^)(I count))range1; /* SPECIALIZED */
+ (A*(^)(I start, I stop, I step))range;

@end