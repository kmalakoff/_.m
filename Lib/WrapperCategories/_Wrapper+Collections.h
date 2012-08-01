//
//  _Wrapper+Collections.h
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

@interface _Wrapper (Collections)

- (_Wrapper*(^)(_EachBlock iterator))each;
- (_Wrapper*(^)(_EachBlock iterator))forEach; // ALIAS
- (_Wrapper*(^)(_EachWithStopBlock iterator))eachWithStop; /* SPECIALIZED: returns YES if processed all elements without a request to stop */

- (_Wrapper*(^)(_MapBlock iterator))map;
- (_Wrapper*(^)(_MapBlock iterator))collect; // ALIAS

- (_Wrapper*(^)(_ReduceBlock iterator, id memo))reduce;
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))foldl; // ALIAS
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))inject; // ALIAS

- (_Wrapper*(^)(_ReduceBlock iterator, id memo))reduceRight;
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))foldr; // ALIAS

- (_Wrapper*(^)(_FindBlock iterator))find;
- (_Wrapper*(^)(_FindBlock iterator))detect; // ALIAS

- (_Wrapper*(^)(_ItemTestBlock iterator))filter;
- (_Wrapper*(^)(_ItemTestBlock iterator))select; // ALIAS

- (_Wrapper*(^)(_ItemTestBlock iterator))reject;

- (_Wrapper*(^)(_ItemTestBlock iterator))all;
- (_Wrapper*(^)(_ItemTestBlock iterator))every; // ALIAS

- (_Wrapper*(^)(/* REQUIRED */ _ItemTestBlock iterator))any;
- (_Wrapper*(^)(_ItemTestBlock iterator))some; // ALIAS

- (_Wrapper*(^)(id target))include;
- (_Wrapper*(^)(id target))contains; // ALIAS

- (_Wrapper*(^)(NSS* methodName, id arg1, ... /* NIL_TERMINATION */))invoke;

- (_Wrapper*(^)(NSString *propertyName))pluck;

- (_Wrapper*(^)(_MaxBlock iterator))max;
- (_Wrapper*(^)(_MinBlock iterator))min;

- (_Wrapper*(^)(id iteratorOrKey /* _SortByBlock or key */))sortBy;
- (_Wrapper*(^)(id iteratorOrKey /* _GroupByBlock or key */))groupBy;

- (_Wrapper*(^)(id obj, _SortedIndexBlock iterator))sortedIndex;

- (_Wrapper*(^)())shuffle;

- (_Wrapper*(^)())toArray;

- (_Wrapper*(^)())size;

@end
