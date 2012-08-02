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

+ (void(^)(id list, _EachBlock iterator))each;
+ (void(^)(id list, _EachBlock iterator))forEach; // ALIAS
+ (B(^)(id list, _EachWithStopBlock iterator))eachWithStop; /* SPECIALIZED: returns YES if processed all elements without a request to stop */

+ (A*(^)(NSO* list, _MapBlock iterator))map;
+ (A*(^)(id list, _MapBlock iterator))collect; // ALIAS

+ (id(^)(id list, _ReduceBlock iterator, id memo))reduce;
+ (id(^)(id list, _ReduceBlock iterator, id memo))foldl; // ALIAS
+ (id(^)(id list, _ReduceBlock iterator, id memo))inject; // ALIAS

+ (id(^)(id list, _ReduceBlock iterator, id memo))reduceRight;
+ (id(^)(id list, _ReduceBlock iterator, id memo))foldr; // ALIAS

+ (id(^)(id list, _FindBlock iterator))find;
+ (id(^)(id list, _FindBlock iterator))detect; // ALIAS

+ (A*(^)(id list, _ItemTestBlock iterator))filter;
+ (A*(^)(id list, _ItemTestBlock iterator))select; // ALIAS

+ (A*(^)(id list, _ItemTestBlock iterator))reject;

+ (B(^)(id list, _ItemTestBlock iterator))all;
+ (B(^)(id list, _ItemTestBlock iterator))every; // ALIAS

+ (B(^)(id list, _ItemTestBlock iterator))any;
+ (B(^)(id list, _ItemTestBlock iterator))some; // ALIAS

+ (B(^)(id list, id target))include;
+ (B(^)(id list, id target))contains; // ALIAS

+ (id(^)(id list, NSS* methodName, id arg1, ... /* NIL_TERMINATION */))invoke;

+ (NSO*(^)(id list, NSString *propertyName))pluck;

+ (id(^)(id list, _MaxBlock iterator))max;
+ (id(^)(id list, _MinBlock iterator))min;

+ (id(^)(id list, id iteratorOrKey /* _SortByBlock or id */))sortBy;

+ (O*(^)(id list, id iteratorOrKey /* _GroupByBlock or id */))groupBy;

+ (UI(^)(NSA* array, id list, _SortedIndexBlock iterator))sortedIndex;

+ (A*(^)(id list))shuffle;

+ (NSA*(^)(id list))toArray;

+ (UI(^)(id list))size;

@end
