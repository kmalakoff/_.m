//
//  _Wrapper+Collections.m
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

#import "_Wrapper+Collections.h"
#import "_Wrapper+Private.h"
#import "_+Collections.h"
#import "_+Objects.h"
#import "SubjectiveScript.h"

@implementation _Wrapper (Collections)

//each

- (_Wrapper*(^)(_MapBlock iterator))map
{
  return ^(_MapBlock iterator) {
    return _.chain(_.map(self.value(), iterator));
  };
}

- (_Wrapper*(^)(_ReduceBlock iterator, id memo))reduce
{
  return ^(_ReduceBlock iterator, id memo) {
    return _.chain(_.reduce(self.value(), iterator, memo));
  };
}
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))foldl { return self.reduce; } // ALIAS
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))inject { return self.reduce; } // ALIAS

- (_Wrapper*(^)(_ReduceBlock iterator, id memo))reduceRight
{
  return ^(_ReduceBlock iterator, id memo) {
    return _.chain(_.reduceRight(self.value(), iterator, memo));
  };
}
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))foldr { return self.reduceRight; } // ALIAS

//find

- (_Wrapper*(^)(_CollectionItemTestBlock iterator))filter 
{
  return ^(_CollectionItemTestBlock iterator) {
    return _.chain(_.filter(self.value(), iterator));
  };
}
- (_Wrapper*(^)(_CollectionItemTestBlock iterator))select { return self.filter; } // ALIAS

//reject
//all
//any

- (_Wrapper*(^)(id target))include
{
  return ^(id target) {
    return _.chain(N.B(_.include(self.value(), target)));
  };
}
- (_Wrapper*(^)(id target))contains { return self.include; } // ALIAS

//invoke

- (_Wrapper*(^)(NSString *keyPath))pluck {
  return ^(NSString *keyPath) {
    return _.chain(_.pluck(self.value(), keyPath));
  };
}

//max
//min

- (_Wrapper*(^)(_SortBlock iterator))sort { /* ADDED to allow sorting in chaining */
  return ^(_SortBlock iterator) {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif

    return _.chain(self.valueA().sort(iterator));
  };
}

//sortBy
//groupBy
//sortedIndex
//shuffle
//toArray
//size

@end
