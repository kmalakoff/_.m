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
  _.each(_IA(1, 2, 3), ^(N* num, N* i) {
    self.equalI(num.i, i.i + 1, @"each iterators provide value and iteration count");
  });

  __block A* answers = A.new_;
  _.eachWithContext(_IA(1, 2, 3), ^(N* num, N* i, O* this){ answers.push(N.i(num.i * ((N*)this.get(@"multiplier")).i));}, _O({@"multiplier", N.i(5)})); // CHANGE
  self.equal(answers.join(@", "), @"5, 10, 15", @"context object property accessed");

  answers = A.new_;
  _.forEach(_IA(1, 2, 3), ^(N* num, N* i){ answers.push(num); });
  self.equal(answers.join(@", "), @"1, 2, 3", @"aliased as 'forEach'");

  answers =  A.new_;
  O* obj = _O({@"one", N.i(1)}, {@"two", N.i(2)}, {@"three", N.i(3)});
//  obj.constructor.prototype.four = 4;
  _.each(obj, ^(id value, id key){ answers.push(key); });
  self.equal(answers.join(@", "), @"one, two, three", @"iterating over objects works, and ignores the object prototype.");
//  delete obj.constructor.prototype.four;

//  answer = nil;
//  _.each(_IA(1, 2, 3), ^(num, index, arr){ if (_.include(arr, num)) answer = true; });
//  ok(answer, @"can reference the original collection from inside the iterator");

  __block I iAnswers = 0;
  _.each(nil, ^(id v, id k){ ++iAnswers; });
  self.equalI(iAnswers, 0, @"handles a nil properly");
}

- (void)test_map
{
  A* doubled = _.map(_IA(1, 2, 3), ^(N* num, id i){ return N.i(num.i * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"doubled numbers");

  doubled = _.collect(_IA(1, 2, 3), ^(N* num, id i){ return N.i(num.i * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"aliased as 'collect'");

  __block A* tripled = _.mapWithContext(_IA(1, 2, 3), ^(N* num, N* i, O* this){ return N.i(num.i * ((N*)this.get(@"multiplier")).i); }, _O({@"multiplier", N.i(3)})); // CHANGE
  self.equal(tripled.join(@", "), @"3, 6, 9", @"tripled numbers with context");

  // TODO: chain
//  doubled = _(_IA(1, 2, 3)).map(^(N* num){ return  N.i(num.i * 2); });
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
