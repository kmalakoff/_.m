//
//  _+ChainingTests.m
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

#import "_+ChainingTests.h"
#import "QUnit.h"
#import "Underscore.h"

@implementation __ChainingTests

- (void)test_map_flatten_reduce
{
  A* lyrics = AO(
    @"I'm a lumberjack and I'm okay",
    @"I sleep all night and I work all day",
    @"He's a lumberjack and he's okay",
    @"He sleeps all night and he works all day"
  );
  O* counts = (O*) __(lyrics).chain()
    .map(^(NSS* line, ... /* KEY, LIST */) { return line.split(@""); })
    .flatten(/* REQUIRED */ false )
    .reduce(^(O* hash, N* l, ... /* KEY, LIST */) {
      N* value = (N*) hash.getOrAdd(l, ^{ return N.I(0); });
      hash.set(l, N.I(value.I+1));
      return hash;
  }, O.new).value();
  ok(counts.get(@"a").I == 16 && counts.get(@"e").I == 10, @"counted all the letters in the song");
}

- (void)test_select_reject_sortBy
{
  NSA* numbers = AI(1,2,3,4,5,6,7,8,9,10);
  numbers = __(numbers).select(^B(N* n, ... /* KEY, LIST */) {
    return n.I % 2 == 0;
  }).reject(^B(N* n, ... /* KEY, LIST */) {
    return n.I % 4 == 0;
  }).sortBy(^(N* n, ... /* KEY, LIST */) {
    return N.I(-n.I);
  }).NSA;
  equal(numbers.join(@", "), @"10, 6, 2", @"filtered and reversed the numbers");
}

- (void)test_select_reject_sortBy_in_functional_style
{
  NSA* numbers = AI(1,2,3,4,5,6,7,8,9,10);
  numbers = _.chain(numbers).select(^B(N* n, ... /* KEY, LIST */) {
    return n.I % 2 == 0;
  }).reject(^B(N* n, ... /* KEY, LIST */) {
    return n.I % 4 == 0;
  }).sortBy(^(N* n, ... /* KEY, LIST */) {
    return N.I(-n.I);
  }).NSA;
  equal(numbers.join(@", "), @"10, 6, 2", @"filtered and reversed the numbers");
}

- (void)test_reverse_concat_unshift_pop_map
{
  NSA* numbers = AI(1,2,3,4,5);
  numbers = __(numbers).chain()
    .reverse()
    .concat(AI(5, 5, 5))
    .unshift(N.I(17), /* NIL_TERMINATED */ nil)
    .pop()
    .map(^(N* n, ... /* KEY, LIST */){ return N.I(n.I * 2); })
    .NSA;
  equal(numbers.join(@", "), @"34, 10, 8, 6, 4, 2, 10, 10", @"can chain together array ^s.");
}

@end
