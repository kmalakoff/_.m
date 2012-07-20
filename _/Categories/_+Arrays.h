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

+ (NSO*(^)(NSA* array, N* n))first;  // TODO: nil terminated
+ (NSO*(^)(NSA* array, N* n))head;
+ (NSO*(^)(NSA* array, N* n))take;
+ (NSO*(^)(NSA* array, N* unused))firstIterator;

+ (A*(^)(NSA* array, N* n))initial;   // TODO: nil terminated
+ (A*(^)(NSA* array, N* unused))initialIterator; 

+ (NSO*(^)(NSA* array, N* n))last; // TODO: nil terminated
+ (NSO*(^)(NSA* array, N* unused))lastIterator;

+ (A*(^)(NSA* array, N* index))rest;  // TODO: nil terminated
+ (A*(^)(NSA* array, N* index))tail;
+ (A*(^)(NSA* array, N* unused))restIterator;

+ (A*(^)(NSA* array))compact;

+ (A*(^)(NSA* array, BOOL shallow))flatten;

+ (A*(^)(NSA* array, id value1, ...))without;

+ (A*(^)(NSA* array1, ...))union_; // CHANGE: reserved keyword

+ (A*(^)(NSA* array1, ...))intersection;

+ (A*(^)(NSA* array, NSA* array1, ...))difference;

+ (A*(^)(NSA* array))uniq;
+ (A*(^)(NSA* array, B isSorted, _MapBlock iterator))uniq3;
+ (A*(^)(NSA* array, B isSorted, _MapBlock iterator))unique;

+ (A*(^)(NSA* array1, ...))zip;

+ (O*(^)(NSA* keys, NSA* values))zipObject;

+ (I(^)(NSA* array, id value))indexOf;
+ (I(^)(NSA* array, id value))indexOfSorted;

+ (I(^)(NSA* array, id value))lastIndexOf;

+ (A*(^)(I start, I stop, I step))range;

@end