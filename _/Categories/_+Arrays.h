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

+ (id(^)(NSArray* array, N* index))first;
+ (id(^)(NSArray* array, N* index))head;
+ (id(^)(NSArray* array, N* index))take;
//
//+ (NSArray*(^)(NSArray* array, N* index))initial;
//
//+ (id (^)(NSArray* array, N* index))last;
//
+ (NSArray*(^)(NSArray* array, N* index))rest;
+ (NSArray*(^)(NSArray* array, N* index))tail;
//
//+ (NSArray*(^)(NSArray* array))compact;
//
+ (A*(^)(NSArray* array, N* shallow))flatten;

//+ (NSArray*(^)(NSArray* array, id value1, ...))without;
//
//+ (NSArray*(^)(NSArray* array1, ...))union;
//
//+ (NSArray*(^)(NSArray* array1, ...))intersection;
//
//+ (NSArray*(^)(NSArray* array, NSArray* array1, ...))difference;
//
//+ (id (^)(NSArray* array, B isSorted, _MapBlock iterator))uniq;
//+ (id (^)(NSArray* array, B isSorted, _MapBlock iterator))unique;
//
//+ (NSArray*(^)(NSArray* array1, NSArray* array2, ...))zip;
//
//+ (I (^)(NSArray* array, id value, B isSorted))indexOf;
//
//+ (I (^)(NSArray* array, id value))lastIndexOf;
//
//+ (NSArray* (^)(I start, I stop, I step))range;
//
@end