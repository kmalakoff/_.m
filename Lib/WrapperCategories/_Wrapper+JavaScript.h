//
//  _Wrapper+JavaScript.h
//  _.m
//
//  Created by Kevin Malakoff on 7/29/12.
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

@interface _Wrapper (JavaScript)

- (_Wrapper*)length;
- (_Wrapper*(^)(id key))hasOwnProperty;

// Add all mutator Array functions to the wrapper.
- (_Wrapper*(^)())pop;
- (_Wrapper*(^)(id value))push;
- (_Wrapper*(^)())reverse;
- (_Wrapper*(^)(_SortBlock iterator))sort;
- (_Wrapper*(^)(I start, I count, id item1, ... /* NIL_TERMINATED */))splice;
- (_Wrapper*(^)(id item1, ... /* NIL_TERMINATED */))unshift;
- (_Wrapper*(^)())shift;

// Add all accessor Array functions to the wrapper.
- (_Wrapper*(^)(NSA* other))concat;
- (_Wrapper*(^)(NSS* separator))join;
- (_Wrapper*(^)(I start, I count))slice;

@end
