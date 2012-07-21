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
  _.each(AI(1, 2, 3), ^(N* num, KH kh) {
    self.equalI(num.I, KHIndex(kh) + 1, @"each iterators provide value and iteration count");
  });

//  __block A* answers = A.new;
//  _.each(AI(1, 2, 3), ^(N* num, KH kh, O* this){ answers.push(N.I(num.I * ((N*)this.get(@"multiplier")).I));}, OAKV({@"multiplier", N.I(5)}));
//  self.equal(answers.join(@", "), @"5, 10, 15", @"context object property accessed");

  __block A*answers = A.new;
  _.forEach(AI(1, 2, 3), ^(N* num, KH kh){ answers.push(num); });
  self.equal(answers.join(@", "), @"1, 2, 3", @"aliased as 'forEach'");

  answers =  A.new;
  O* obj = OAKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)});
//  obj.constructor.prototype.four = 4;
  _.each(obj, ^(id value, KH kh){ answers.push(KHKey(kh)); });
  self.equal(answers.join(@", "), @"one, two, three", @"iterating over objects works, and ignores the object prototype.");
//  delete obj.constructor.prototype.four;

//  answer = nil;
//  _.each(AI(1, 2, 3), ^(num, index, arr){ if (_.include(arr, num)) answer = YES; });
//  ok(answer, @"can reference the original collection from inside the iterator");

  __block I iAnswers = 0;
  _.each(nil, ^(id v, KH kh){ ++iAnswers; });
  self.equalI(iAnswers, 0, @"handles a nil properly");
}

- (void)test_map
{
  A* doubled = _.map(AI(1, 2, 3), ^(N* num, KH kh){ return N.I(num.I * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"doubled numbers");

  doubled = _.collect(AI(1, 2, 3), ^(N* num, KH kh){ return N.I(num.I * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"aliased as 'collect'");

//  __block A* tripled = _.mapWithContext(AI(1, 2, 3), ^(N* num, KH kh, O* this){ return N.I(num.I * ((N*)this.get(@"multiplier")).I); }, OAKV({@"multiplier", N.I(3)})); // CHANGE
//  self.equal(tripled.join(@", "), @"3, 6, 9", @"tripled numbers with context");

  // TODO: chain
//  doubled = _(AI(1, 2, 3)).map(^(N* num){ return N.I(num.I * 2); });
//  self.equal(doubled.join(@", "), @"2, 4, 6", @"OO-style doubled numbers");

//  var ids = _.map($(@"#map-test").children(), ^(n){ return n.id; });
//  deepEqual(ids, AI("id1", @"id2"), @"Can use collection methods on NodeLists.");

//  var ids = _.map(document.images, ^(n){ return n.id; });
//  ok(idsAI(0) == "chart_image", @"can use collection methods on HTMLCollections");

  A* ifnil = _.map(nil, ^id(id v, KH kh){ return nil; });
  self.ok(_.isArray(ifnil) && ifnil.length == 0, @"handles a nil properly");
}

//reduce
//reduceRight
//find

- (void)test_filter
{
  A* evens = _.select(AI(1, 2, 3, 4, 5, 6), ^B(N* num, KH kh){ return num.I % 2 == 0; });
  self.equal(evens.join(@", "), @"2, 4, 6", @"selected each even number");

  evens = _.filter(AI(1, 2, 3, 4, 5, 6), ^B(N* num, KH kh){ return num.I % 2 == 0; });
  self.equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");

//  evens = _.filterWithContext(AI(1, 2, 3, 4, 5, 6), ^B(N* num, KH kh, O* this){ return num.I % ((N*)this.get(@"factor")).I == 0; }, OAKV({@"factor", N.I(2)})); // ADDED
//  self.equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");
}


//reject

- (void)test_all
{
  self.ok(_.all(A.new, /* SPECIALIZED */ _.identityValueKeyTest), @"the empty set");
  self.ok(_.all(AB(true, true, true), /* SPECIALIZED */ _.identityValueKeyTest), @"all true values");
  self.ok(!_.all(AB(true, false, true), /* SPECIALIZED */ _.identityValueKeyTest), @"one false value");
  self.ok(_.all(AI(0, 10, 28), ^B(N* num, KH kh){ return num.I % 2 == 0; }), @"even numbers");
  self.ok(!_.all(AI(0, 11, 28), ^B(N* num, KH kh){ return num.I % 2 == 0; }), @"an odd number");
  self.ok(_.all(AI(1), /* SPECIALIZED */ _.identityValueKeyTest) == true, @"cast to boolean - true");
  self.ok(_.all(AI(0), /* SPECIALIZED */ _.identityValueKeyTest) == false, @"cast to boolean - false");
  self.ok(_.every(AB(true, true, true), /* SPECIALIZED */ _.identityValueKeyTest), @"aliased as 'every'");
}

- (void)test_any
{
  self.ok(!_.any(A.new, /* MANDATORY */ nil), @"the empty set");
  self.ok(!_.any(AB(false, false, false), /* MANDATORY */ nil), @"all false values");
  self.ok(_.any(AB(false, false, true), /* MANDATORY */ nil), @"one true value");
  self.ok(_.any(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"yes", N.B(false)), /* MANDATORY */ nil), @"a string");
  self.ok(!_.any(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"", N.B(false)), /* MANDATORY */ nil), @"falsy values");
  self.ok(!_.any(AI(1, 11, 29), ^B(N* num, /* MANDATORY */ KH kh){ return num.I % 2 == 0; }), @"all odd numbers");
  self.ok(_.any(AI(1, 10, 29), ^B(N* num, /* MANDATORY */ KH kh){ return num.I % 2 == 0; }), @"an even number");
  self.ok(_.any(AI(1), /* SPECIALIZED */ _.identityValueKeyTest) == true, @"cast to boolean - true");
  self.ok(_.any(AI(0), /* SPECIALIZED */ _.identityValueKeyTest) == false, @"cast to boolean - false");
  self.ok(_.some(AB(false, false, true), /* MANDATORY */ nil), @"aliased as 'some'");
}

//include
//invoke

- (void)test_pluck
{
  A* people = AO(OAKV({@"name", @"moe"}, {@"age", N.I(30)}), OAKV({@"name", @"curly"}, {@"age", N.I(50)}));
  self.equal(((A*)_.pluck(people, @"name")).join(@", "), @"moe, curly", @"pulls names out of objects");
}

- (void)test_max
{
  self.equal(N.I(3), _.max(AI(1, 2, 3), /* MANDATORY */ nil), @"can perform a regular Math.max");

  N* neg = _.max(AI(1, 2, 3), ^(N* num){ return N.I(-num.I); });
  self.equal(neg, N.I(1), @"can perform a computation-based max");

  self.equal(NF_NEG_INFINITY, _.max(O.new, /* MANDATORY */ nil), @"Maximum value of an empty object");
  self.equal(NF_NEG_INFINITY, _.max(A.new, /* MANDATORY */ nil), @"Maximum value of an empty array");

  self.equal(N.I(299999), _.max(_.range(1,300000, /* MANDATORY */ 1), /* MANDATORY */ nil ), @"Maximum value of a too-big array");
}

//min
//sortBy
//groupBy

- (void)test_sortedIndex
{
  A* numbers = AI(10, 20, 30, 40, 50); N* num = N.I(35);
  I indexForNum = _.sortedIndex(numbers, num, /* MANDATORY */ nil);
  self.equalI(indexForNum, 3, @"35 should be inserted at index 3");

  I indexFor30 = _.sortedIndex(numbers, N.I(30), /* MANDATORY */ nil);
  self.equalI(indexFor30, 2, @"30 should be inserted at index 2");
}

//shuffle
//toArray
//size

@end
