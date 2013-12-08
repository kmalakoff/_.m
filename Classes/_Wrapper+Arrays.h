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

- (_Wrapper*(^)(UI n))first;
- (_Wrapper*(^)(UI n))head;
- (_Wrapper*(^)(UI n))take;
//firstIterator /* NOT WRAPPED */

- (_Wrapper*(^)(UI n))initial;
//initialIterator /* NOT WRAPPED */

- (_Wrapper*(^)(UI n))last;
//lastIterator /* NOT WRAPPED */

- (_Wrapper*(^)(I index))rest;
- (_Wrapper*(^)(I index))tail;
// restIterator /* NOT WRAPPED */

- (_Wrapper*(^)())compact;

- (_Wrapper*(^)(B shallow))flatten;
 
- (_Wrapper*(^)(id value1, ... /* NIL_TERMINATION */))without;

- (_Wrapper*(^)(NSA* array1, ... /* NIL_TERMINATION */))union_;  /* RESERVED KEYWORD 'union' -> 'union_' */

- (_Wrapper*(^)(NSA* array1, ... /* NIL_TERMINATION */))intersection;

- (_Wrapper*(^)(NSA* other1, ... /* NIL_TERMINATION */))difference;

- (_Wrapper*(^)())uniq;
- (_Wrapper*(^)())unique; // ALIAS
- (_Wrapper*(^)(B isSorted, _MapBlock iterator))uniqAdvanced; /* SPECIALIZED */
- (_Wrapper*(^)(B isSorted, _MapBlock iterator))uniqueAdvanced; // ALIAS

- (_Wrapper*(^)(NSA* array2, ... /* NIL_TERMINATION */))zip;

- (_Wrapper*(^)(NSA* keys, NSA* values))zipObject;

- (_Wrapper*(^)(id value))indexOf;
- (_Wrapper*(^)(id value))indexOfSorted; /* SPECIALIZED */

- (_Wrapper*(^)(id value))lastIndexOf;

- (_Wrapper*(^)(I start, I stop, I step))range;
- (_Wrapper*(^)(UI stop))rangeSimple; /* SPECIALIZED */

@end
