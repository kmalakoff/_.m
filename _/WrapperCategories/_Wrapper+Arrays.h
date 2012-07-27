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

- (_Wrapper*(^)(I n))first;
- (_Wrapper*(^)(I n))head;
- (_Wrapper*(^)(I n))take;

- (_Wrapper*(^)(I n))initial;

- (_Wrapper*(^)(I n))last;

- (_Wrapper*(^)(I index))rest;
- (_Wrapper*(^)(I index))tail;

- (_Wrapper*(^)())compact;

- (_Wrapper*(^)(BOOL shallow))flatten;
 
- (_Wrapper*(^)(id value1, ...))without; // TODO: nil terminated

- (_Wrapper*(^)(NSA* array1, ...))union_;  /* RESERVED KEYWORD 'union' -> 'union_' */ // TODO: nil terminated

- (_Wrapper*(^)(NSA* array1, ...))intersection; // TODO: nil terminated

- (_Wrapper*(^)(NSA* array1, ...))difference; // TODO: nil terminated

- (_Wrapper*(^)())uniq;
- (_Wrapper*(^)(B isSorted, _UniqueBlock iterator))uniq3; /* SPECIALIZED */
- (_Wrapper*(^)(B isSorted, _UniqueBlock iterator))unique;

- (_Wrapper*(^)(NSA* array1, ...))zip; // TODO: nil terminated

// zipObject /* NO OO-STYLE WRAPPER VERSION */

- (_Wrapper*(^)(id value))indexOf;
- (_Wrapper*(^)(id value))indexOfSorted; /* SPECIALIZED */

- (_Wrapper*(^)(id value))lastIndexOf;

// range1 /* NO OO-STYLE WRAPPER VERSION */
// range /* NO OO-STYLE WRAPPER VERSION */

@end
