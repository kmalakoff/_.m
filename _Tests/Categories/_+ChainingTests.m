//
//  _+ChainingTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_+ChainingTests.h"
#import "QUnit.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

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
    .map(^(NSS* line, ... /* KEY, COLLECTION */) { return line.split(@""); })
    .flatten(/* REQUIRED */ false )
    .reduce(^(O* hash, N* l, ... /* KEY, COLLECTION */) {
      N* value = (N*) hash.getOrAdd(l, ^{ return N.I(0); });
      hash.set(l, N.I(value.I+1));
      return hash;
  }, O.new).value();
  ok(counts.get(@"a").I == 16 && counts.get(@"e").I == 10, @"counted all the letters in the song");
}

- (void)test_select_reject_sortBy
{
  NSA* numbers = AI(1,2,3,4,5,6,7,8,9,10);
  numbers = __(numbers).select(^B(N* n, ... /* KEY, COLLECTION */) {
    return n.I % 2 == 0;
  }).reject(^B(N* n, ... /* KEY, COLLECTION */) {
    return n.I % 4 == 0;
  }).sortBy(^(N* n, ... /* KEY, COLLECTION */) {
    return N.I(-n.I);
  }).NSA;
  equal(numbers.join(@", "), @"10, 6, 2", @"filtered and reversed the numbers");
}

- (void)test_select_reject_sortBy_in_functional_style
{
  NSA* numbers = AI(1,2,3,4,5,6,7,8,9,10);
  numbers = _.chain(numbers).select(^B(N* n, ... /* KEY, COLLECTION */) {
    return n.I % 2 == 0;
  }).reject(^B(N* n, ... /* KEY, COLLECTION */) {
    return n.I % 4 == 0;
  }).sortBy(^(N* n, ... /* KEY, COLLECTION */) {
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
    .map(^(N* n, ... /* KEY, COLLECTION */){ return N.I(n.I * 2); })
    .NSA;
  equal(numbers.join(@", "), @"34, 10, 8, 6, 4, 2, 10, 10", @"can chain together array ^s.");
}

@end
