//
//  _+CollectionsTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_+CollectionsTests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation __CollectionsTests

- (void)test_each
{
  _.each(Ai3(1, 2, 3), ^(N* num, N* i) {
    self.equal(N.i(num.i), N.i(i.i + 1), @"each iterators provide value and iteration count");
  });

//  A* answers = A.new_;
//  _.each(Ai3(1, 2, 3), ^(N* num, N* i){ answers.push(num.f * this.multiplier);}, O.o_(@"multiplier", N.i(5)).__);
//  self.equal(answers.join(@", "), @"5, 10, 15", @"context object property accessed");

  __block A* answers = A.new_;
  _.forEach(Ai3(1, 2, 3), ^(N* num, N* i){ answers.push(num); });
  self.equal(answers.join(@", "), @"1, 2, 3", @"aliased as 'forEach'");

  answers =  A.new_;
  O* obj = O.o_(@"one", N.i(1))._(@"two", N.i(2))._(@"three", N.i(3)).__;
//  obj.constructor.prototype.four = 4;
  _.each(obj, ^(id value, id key){ answers.push(key); });
  self.equal(answers.join(@", "), @"one, two, three", @"iterating over objects works, and ignores the object prototype.");
//  delete obj.constructor.prototype.four;

//  answer = nil;
//  _.each(Ai3(1, 2, 3), ^(num, index, arr){ if (_.include(arr, num)) answer = true; });
//  ok(answer, @"can reference the original collection from inside the iterator");

//  answers = 0;
//  _.each(nil, ^(){ ++answers; });
//  self.equal(answers, 0, @"handles a nil properly");
}

- (void)test_map
{
  A* doubled = _.map(Ai3(1, 2, 3), ^(N* num, id i){ return N.i(num.i * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"doubled numbers");

  doubled = _.collect(Ai3(1, 2, 3), ^(N* num, id i){ return N.i(num.i * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"aliased as 'collect'");

//  A* tripled = _.map(Ai3(1, 2, 3), ^(num){ return num * this.multiplier; }, O.o_(@"multiplier", N.i(3)).__);
//  self.equal(tripled.join(@", "), @"3, 6, 9", @"tripled numbers with context");

  // TODO: chain
//  doubled = _(Ai3(1, 2, 3)).map(^(N* num){ return  N.i(num.i * 2); });
//  self.equal(doubled.join(@", "), @"2, 4, 6", @"OO-style doubled numbers");

//  var ids = _.map($(@"#map-test").children(), ^(n){ return n.id; });
//  deepEqual(ids, ["id1", @"id2"], @"Can use collection methods on NodeLists.");

//  var ids = _.map(document.images, ^(n){ return n.id; });
//  ok(ids[0] == "chart_image", @"can use collection methods on HTMLCollections");

  A* ifnil = _.map(nil, ^id(id v, id k){ return nil; });
  self.ok(_.isArray(ifnil) && ifnil.length == 0, @"handles a nil properly");
}

//reduce
//reduceRight
//find
//filter
//reject
//all
//any
//include
//invoke
//pluck
//max
//min
//sortBy
//groupBy
//sortedIndex
//shuffle
//toArray
//size

@end
