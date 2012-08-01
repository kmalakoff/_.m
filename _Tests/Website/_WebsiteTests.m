//
//  _WebsiteTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_WebsiteTests.h"
#import "Underscore.h"
#import "QUnit.h"

@implementation _WebsiteTests

- (void)test_collections
{
  // each
  _.each(AI(1, 2, 3), ^(N* num, ...){ SS.alert(num); });
  _.each(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}), ^(N* num, ...){ SS.alert(num); });
  _.eachWithStop(AI(1, 2, 3), ^B(N* num, ...){ SS.alert(num); return (num.I<3); });

  // map
  A* nums = _.map(AI(1, 2, 3), ^(N* num, ...){ return N.I(num.I * 3); });
  equal(nums.toString(), @"[3,6,9]", @"map array");
  nums = _.map(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}), ^id(N* num, ...){ return N.I(num.I * 3); });
  equal(nums.toString(), @"[3,6,9]", @"map object");

  // reduce
  N* sum = _.reduce(AI(1, 2, 3), ^(N* memo, N* num, ...){ return N.I(memo.I + num.I); }, N.I(0));
  equal(sum.I, 6, @"reduce");

  // reduceRight
  A* list = AO(AI(0, 1), AI(2, 3), AI(4, 5));
  A* flat = _.reduceRight(list, ^(A* a, A* b, ...) { return a.concat(b); }, A.new);
  equal(flat, AI(4, 5, 2, 3, 0, 1), @"reduceRight");
  
  // find
  N* even = _.find(AI(1, 2, 3, 4, 5, 6), ^B(N* num){ return num.I % 2 == 0; });
  equal(even.I, 2, @"find");
  
  // filter
  A* evens = _.filter(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ...){ return num.I % 2 == 0; });
  equal(evens.toString(), @"[2,4,6]", @"filter");

  // reject
  A* odds = _.reject(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ...){ return num.I % 2 == 0; });
  equal(odds.toString(), @"[1,3,5]", @"reject");

  // all
  B all = _.all(AO(N.B(true), N.I(1), nil, @"yes"), _.identityTruthy);
  equal(all, false, @"all");
  
  // any
  B any = _.any(AO(nil, N.I(0), @"yes", N.B(false)), nil);
  equal(any, true, @"any");
  
  // include
  B include = _.include(AI(1, 2, 3), N.I(3));
  equal(include, true, @"include");
  
  // invoke
  A* invoke = _.invoke(AO(AI(5, 1, 7), AI(3, 2, 1)), @"sort", nil);
  equal(invoke.toString(), @"[[1,5,7],[1,2,3]]", @"invoke");

  // pluck
  A* stooges = AO(OKV({@"name", @"moe"}, {@"age", N.I(40)}), OKV({@"name", @"larry"}, {@"age", N.I(50)}), OKV({@"name", @"curly"}, {@"age", N.I(60)}));
  id pluck = _.pluck(stooges, @"name");
  equal(SS.stringify(pluck), @"[\"moe\",\"larry\",\"curly\"]", @"pluck");

  // max
  id max = _.max(stooges, ^(O* stooge){ return stooge.get(@"age"); });
  equal(max, OKV({@"name", @"curly"}, {@"age", N.I(60)}), @"pluck");

  // min
  A* numbers = AI(10, 5, 100, 2, 1000);
  N* min = _.min(numbers, nil);
  equal(min.I, 2, @"min")
  
  // sortBy
  A* sortBy = _.sortBy(AI(1, 2, 3, 4, 5, 6), ^(N* num, ...){ return N.F(sin(num.I)); });
  equal(sortBy, AI(5, 4, 6, 3, 1, 2), @"sortBy")
  
  // groupBy
  O* groupBy = _.groupBy(AF(1.3, 2.1, 2.4), ^(N* num, ...){ return N.I(floor(num.F)); });
  equal(groupBy, OKV({N.I(1), AF(1.3)}, {N.I(2), AF(2.1, 2.4)}), @"groupBy numbers")
  groupBy = _.groupBy(AO(@"one", @"two", @"three"), @"length");
  equal(groupBy, OKV({N.I(3), AO(@"one",@"two")}, {N.I(5), AO(@"three")}), @"groupBy string length")

  // sortedIndex
  UI sortedIndex = _.sortedIndex(AI(10, 20, 30, 40, 50), N.I(35), nil);
  equal(sortedIndex, 3, @"sortedIndex")
  
  // shuffle
  A* shuffle = _.shuffle(AI(1, 2, 3, 4, 5, 6));
  equal(shuffle.length, 6, @"shuffle")
  for (N* item in AI(1, 2, 3, 4, 5, 6)) {
    ok(_.include(shuffle, item), @"shuffle includes")
  }
  
  // toArray
  NSA* toArray = (^(I arg1, ...){ ARGS_AI(arguments, arg1); return _.toArray(arguments).slice(1, 0); })(1, 2, 3, 4, AI_END);
  equal(toArray.toString(), @"[2,3,4]", @"toArray")

  // size
  UI size = _.size(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}));
  equal(size, 3, @"size")
}

- (void)test_arrays
{
}

- (void)test_functions
{
}

- (void)test_objects
{
}

- (void)test_utility
{
}

- (void)test_chaining
{
}

@end
