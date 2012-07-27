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

//each

- (_Wrapper*(^)(_MapBlock iterator))map;

- (_Wrapper*(^)(_ReduceBlock iterator, id memo))reduce;
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))foldl; // ALIAS
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))inject; // ALIAS

- (_Wrapper*(^)(_ReduceBlock iterator, id memo))reduceRight;
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))foldr; // ALIAS

//find

- (_Wrapper*(^)(_CollectionItemTestBlock iterator))filter;
- (_Wrapper*(^)(_CollectionItemTestBlock iterator))select; // ALIAS

//reject
//all
//any

- (_Wrapper*(^)(id target))include;
- (_Wrapper*(^)(id target))contains; // ALIAS

//invoke

- (_Wrapper*(^)(NSString *keyPath))pluck;

//max
//min

- (_Wrapper*(^)(_SortBlock iterator))sort; /* ADDED to allow sorting in chaining */

//sortBy
//groupBy
//sortedIndex

//shuffle
//toArray
//size

@end
