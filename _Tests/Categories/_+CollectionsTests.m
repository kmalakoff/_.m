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
  _.each(AI(1, 2, 3), ^(N* num, N* i) {
    self.equalI(num.I, i.I + 1, @"each iterators provide value and iteration count");
  });

//  __block A* answers = A.new_;
//  _.each(AI(1, 2, 3), ^(N* num, N* i, O* this){ answers.push(N.I(num.I * ((N*)this.get(@"multiplier")).I));}, OAKV({@"multiplier", N.I(5)}));
//  self.equal(answers.join(@", "), @"5, 10, 15", @"context object property accessed");

  __block A*answers = A.new_;
  _.forEach(AI(1, 2, 3), ^(N* num, N* i){ answers.push(num); });
  self.equal(answers.join(@", "), @"1, 2, 3", @"aliased as 'forEach'");

  answers =  A.new_;
  O* obj = OAKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)});
//  obj.constructor.prototype.four = 4;
  _.each(obj, ^(id value, id key){ answers.push(key); });
  self.equal(answers.join(@", "), @"one, two, three", @"iterating over objects works, and ignores the object prototype.");
//  delete obj.constructor.prototype.four;

//  answer = nil;
//  _.each(AI(1, 2, 3), ^(num, index, arr){ if (_.include(arr, num)) answer = true; });
//  ok(answer, @"can reference the original collection from inside the iterator");

  __block I iAnswers = 0;
  _.each(nil, ^(id v, id k){ ++iAnswers; });
  self.equalI(iAnswers, 0, @"handles a nil properly");
}

- (void)test_map
{
  A* doubled = _.map(AI(1, 2, 3), ^(N* num, id i){ return N.I(num.I * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"doubled numbers");

  doubled = _.collect(AI(1, 2, 3), ^(N* num, id i){ return N.I(num.I * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"aliased as 'collect'");

//  __block A* tripled = _.mapWithContext(AI(1, 2, 3), ^(N* num, N* i, O* this){ return N.I(num.I * ((N*)this.get(@"multiplier")).I); }, OAKV({@"multiplier", N.I(3)})); // CHANGE
//  self.equal(tripled.join(@", "), @"3, 6, 9", @"tripled numbers with context");

  // TODO: chain
//  doubled = _(AI(1, 2, 3)).map(^(N* num){ return  N.I(num.I * 2); });
//  self.equal(doubled.join(@", "), @"2, 4, 6", @"OO-style doubled numbers");

//  var ids = _.map($(@"#map-test").children(), ^(n){ return n.id; });
//  deepEqual(ids, AI("id1", @"id2"), @"Can use collection methods on NodeLists.");

//  var ids = _.map(document.images, ^(n){ return n.id; });
//  ok(idsAI(0) == "chart_image", @"can use collection methods on HTMLCollections");

  A* ifnil = _.map(nil, ^id(id v, id k){ return nil; });
  self.ok(_.isArray(ifnil) && ifnil.length == 0, @"handles a nil properly");
}

//reduce
//reduceRight
//find

- (void)test_filter
{
  A* evens = _.select(AI(1, 2, 3, 4, 5, 6), ^BOOL(N* num, N* i){ return num.I % 2 == 0; });
  self.equal(evens.join(@", "), @"2, 4, 6", @"selected each even number");

  evens = _.filter(AI(1, 2, 3, 4, 5, 6), ^BOOL(N* num, N* i){ return num.I % 2 == 0; });
  self.equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");

//  evens = _.filterWithContext(AI(1, 2, 3, 4, 5, 6), ^BOOL(N* num, N* i, O* this){ return num.I % ((N*)this.get(@"factor")).I == 0; }, OAKV({@"factor", N.I(2)})); // ADDED
//  self.equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");
}


//reject
//all
//any
//include
//invoke

- (void)test_pluck
{
  A* people = AO(OAKV({@"name", @"moe"}, {@"age", N.I(30)}), OAKV({@"name", @"curly"}, {@"age", N.I(50)}));
  self.equal(((A*)_.pluck(people, @"name")).join(@", "), @"moe, curly", @"pulls names out of objects");
}

//max
//min
//sortBy
//groupBy
//sortedIndex
//shuffle
//toArray
//size

@end
