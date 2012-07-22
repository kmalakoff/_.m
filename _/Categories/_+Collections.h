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

+ (void(^)(id obj, _ValueKeyDoBlock iterator))each;
+ (void(^)(id obj, _ValueKeyDoBlock iterator))forEach; // ALIAS
+ (B(^)(id obj, _ValueKeyTestBlock iterator))eachWithStop; /* SPECIALIZED: returns YES if processed all elements without a request to stop */

+ (A*(^)(NSO* obj, _ValueKeyMapBlock iterator))map;
+ (A*(^)(id obj, _ValueKeyMapBlock iterator))collect; // ALIAS

+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))reduce;
+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))foldl; // ALIAS
+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))inject; // ALIAS

+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))reduceRight;
+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))foldr; // ALIAS

+ (id(^)(id obj, _ValueTestBlock iterator))find;
+ (id(^)(id obj, _ValueTestBlock iterator))detect; // ALIAS

+ (A*(^)(id obj, _ValueKeyTestBlock iterator))filter;
+ (A*(^)(id obj, _ValueKeyTestBlock iterator))select; // ALIAS

+ (A*(^)(id obj, _ValueKeyTestBlock iterator))reject;

+ (B(^)(id obj, _ValueKeyTestBlock iterator))all;
+ (B(^)(id obj, _ValueKeyTestBlock iterator))every; // ALIAS

+ (B(^)(id obj, /* MANDATORY */ _ValueKeyTestBlock iterator))any;
+ (B(^)(id obj, _ValueKeyTestBlock iterator))some; // ALIAS

+ (B(^)(id obj, id target))include;
+ (B(^)(id obj, id target))contains; // ALIAS

+ (NSO*(^)(id obj, NSS* methodName, id arg1, ...))invoke; /* TODO: NIL TERMINATED */

+ (NSO*(^)(id obj, NSString *keyPath))pluck;

+ (NSO*(^)(NSO* obj, _ValueMapBlock iterator))max;
+ (NSO*(^)(NSO* obj, _ValueMapBlock iterator))min;

+ (id(^)(id obj, id iteratorOrKey))sortBy;
+ (O*(^)(id obj, id iteratorOrKey))groupBy; 

+ (I(^)(NSA* array, id obj, _ValueMapBlock iterator))sortedIndex;

+ (A*(^)(id obj))shuffle;

+ (NSA*(^)(id obj))toArray;

+ (UI(^)(id obj))size;

@end
