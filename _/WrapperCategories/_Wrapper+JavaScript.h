//
//  _Wrapper+JavaScript.h
//  _.m
//
//  Created by Kevin Malakoff on 7/29/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Wrapper.h"

@interface _Wrapper (JavaScript)

// Add all mutator Array functions to the wrapper.
- (_Wrapper*(^)())pop;
- (_Wrapper*(^)(id value))push;
- (_Wrapper*(^)())reverse;
- (_Wrapper*(^)(_SortBlock iterator))sort;
- (_Wrapper*(^)(I start, I count, id item1, ... /* NIL_TERMINATED */))splice;
- (_Wrapper*(^)(id item1, ... /* NIL_TERMINATED */))unshift;

// Add all accessor Array functions to the wrapper.
- (_Wrapper*(^)(NSA* other))concat;
- (_Wrapper*(^)(NSS* separator))join;
- (_Wrapper*(^)(I start, I count))slice;

@end
