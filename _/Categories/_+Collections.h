//
//  _+Collections.h
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

@interface _ (Collections)

+ (void(^)(id obj, _IteratorBlock iterator))each;
+ (void(^)(id obj, _IteratorBlock iterator))forEach;

+ (id(^)(id obj, _MapBlock iterator))map;
+ (id(^)(id obj, _MapBlock iterator))collect;

//reduce
//reduceRight
//find

+ (A*(^)(id obj, _IteratorTestBlock iterator))filter;
+ (A*(^)(id obj, _IteratorTestBlock iterator))select;

//reject
//all
//any
//include
//invoke

+ (id(^)(id obj, NSString *keyPath))pluck;

+ (id(^)(id obj, _MapBlock iterator))max;

//min
//sortBy
//groupBy
//sortedIndex
//shuffle
//toArray
//size

@end
