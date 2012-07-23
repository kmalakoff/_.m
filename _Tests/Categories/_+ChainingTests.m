//
//  _+ChainingTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_+ChainingTests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation __ChainingTests

//- (void)test_map_flatten_reduce
//{
//  A* lyrics = AO(
//    @"I'm a lumberjack and I'm okay",
//    @"I sleep all night and I work all day",
//    @"He's a lumberjack and he's okay",
//    @"He sleeps all night and he works all day"
//  );
//  O* counts = (O*) __(lyrics).chain()
//    .map(^(NSS* line, /* MANDATORY */ id index) { return line.split(@""); })
//    .flatten( /* MANDATORY */ false )
//    .reduce(^(O* hash, N* l, id key) {
//      N* value = (N*) hash.getOrAdd(l, ^{ return N.I(0); });
//      hash.set(l, N.I(value.I+1));
//      return hash;
//  }, O.new).value();
//  self.ok(((N*)counts.get(@"a")).I == 16 && ((N*)counts.get(@"e")).I == 10, @"counted all the letters in the song");
//}
//
//- (void)test_select_reject_sortBy
//{
//  A* numbers = AI(1,2,3,4,5,6,7,8,9,10);
//  numbers = __(numbers).chain().select(^B(N* n, /* MANDATORY */ id key) {
//    return n.I % 2 == 0;
//  }).reject(^(N* n, /* MANDATORY */ id key) {
//    return n.I % 4 == 0;
//  }).sortBy(^(N* n, /* MANDATORY */ id key) {
//    return -n.I;
//  }).value();
//  self.equal(numbers.join(@", "), @"10, 6, 2", @"filtered and reversed the numbers");
//}
//
//- (void)test_select_reject_sortBy_in_^al_style
//{
//  var numbers = [1,2,3,4,5,6,7,8,9,10];
//  numbers = _.chain(numbers).select(^(n) {
//    return n % 2 == 0;
//  }).reject(^(n) {
//    return n % 4 == 0;
//  }).sortBy(^(n) {
//    return -n;
//  }).value();
//  self.equal(numbers.join(@", "), @"10, 6, 2", @"filtered and reversed the numbers");
//}
//
//- (void)test_reverse_concat_unshift_pop_map
//{
//  var numbers = [1,2,3,4,5];
//  numbers = _(numbers).chain()
//    .reverse()
//    .concat([5, 5, 5])
//    .unshift(17)
//    .pop()
//    .map(^(n){ return n * 2; })
//    .value();
//  self.equal(numbers.join(@", "), @"34, 10, 8, 6, 4, 2, 10, 10", @"can chain together array ^s.");
//}

@end
