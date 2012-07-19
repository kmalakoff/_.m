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

+ (id(^)(NSArray* array, N* n))first;  // TODO: nil terminated
+ (id(^)(NSArray* array, N* n))head;
+ (id(^)(NSArray* array, N* n))take;
+ (id(^)(NSArray* array, N* unused))firstIterator;

+ (NSArray*(^)(NSArray* array, N* n))initial;   // TODO: nil terminated
+ (NSArray*(^)(NSArray* array, N* unused))initialIterator; 

+ (id(^)(NSArray* array, N* n))last; // TODO: nil terminated
+ (id(^)(NSArray* array, N* unused))lastIterator;

+ (NSArray*(^)(NSArray* array, N* index))rest;  // TODO: nil terminated
+ (NSArray*(^)(NSArray* array, N* index))tail;
+ (NSArray*(^)(NSArray* array, N* unused))restIterator;

+ (NSArray*(^)(NSArray* array))compact;

+ (A*(^)(NSArray* array, N* shallow))flatten;

+ (NSArray*(^)(NSArray* array, id value1, ...))without;

+ (NSArray*(^)(NSArray* array1, ...))union_; // CHANGE: reserved keyword

+ (NSArray*(^)(NSArray* array1, ...))intersection;

+ (NSArray*(^)(NSArray* array, NSArray* array1, ...))difference;

+ (id(^)(NSArray* array))uniq;
+ (id(^)(NSArray* array, B isSorted, _MapBlock iterator))uniqCustomized;
+ (id(^)(NSArray* array, B isSorted, _MapBlock iterator))unique;

+ (NSArray*(^)(NSArray* array1, ...))zip;

+ (O*(^)(NSArray* keys, NSArray* values))zipObject;

+ (I(^)(NSArray* array, id value))indexOf;
+ (I(^)(NSArray* array, id value))indexOfSorted;

+ (I(^)(NSArray* array, id value))lastIndexOf;

+ (NSArray* (^)(I start, I stop, I step))range;

@end