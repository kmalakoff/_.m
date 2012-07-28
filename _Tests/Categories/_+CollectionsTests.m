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
  _.each(AI(1, 2, 3), ^(N* num, ... /* KEY, COLLECTION */) {
    _ARGS_INDEX(num);
    self.equalI(num.I, index + 1, @"each iterators provide value and iteration count");
  });

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  __block A* answers = A.new;
//  _.each(AI(1, 2, 3), ^(N* num, ..., O* this){ answers.push(N.I(num.I * ((N*)this.get(@"multiplier")).I));}, OKV({@"multiplier", N.I(5)}));
//  self.equal(answers.join(@", "), @"5, 10, 15", @"context object property accessed");

  __block A* answers = A.new;
  _.forEach(AI(1, 2, 3), ^(N* num, ... /* KEY, COLLECTION */){ answers.push(num); });
  self.equal(answers.join(@", "), @"1, 2, 3", @"aliased as 'forEach'");

  /* NOT SUPPORTED: JavaScript-only because of prototype */
  answers =  A.new;
  O* obj = OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)});
//  obj.constructor.prototype.four = 4; 
  _.each(obj, ^(id value, ... /* KEY, COLLECTION */){ _ARGS_KEY(value); answers.push(key); });
  self.equal(answers.join(@", "), @"one, two, three", @"iterating over objects works, and ignores the object prototype.");
//  delete obj.constructor.prototype.four;

  __block BOOL answer = false;
  _.each(AI(1, 2, 3), ^(N* num, ... /* KEY, COLLECTION */){ _ARGS_COLLECTION(num, arr); if (_.include(arr, num)) answer = true; });
  self.ok(answer, @"can reference the original collection from inside the iterator");

  __block I iAnswers = 0;
  _.each(nil, ^(id v, ... /* KEY, COLLECTION */){ ++iAnswers; });
  self.equalI(iAnswers, 0, @"handles a nil properly");
}

- (void)test_map
{
  A* doubled = _.map(AI(1, 2, 3), ^(N* num, ... /* KEY, COLLECTION */){ return N.I(num.I * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"doubled numbers");

  doubled = _.collect(AI(1, 2, 3), ^(N* num, ... /* KEY, COLLECTION */){ return N.I(num.I * 2); });
  self.equal(doubled.join(@", "), @"2, 4, 6", @"aliased as 'collect'");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  __block A* tripled = _.mapWithContext(AI(1, 2, 3), ^(N* num, ..., O* this){ return N.I(num.I * ((N*)this.get(@"multiplier")).I); }, OKV({@"multiplier", N.I(3)})); // CHANGE
//  self.equal(tripled.join(@", "), @"3, 6, 9", @"tripled numbers with context");

  doubled =  __(AI(1, 2, 3)).map(^(N* num, ... /* KEY, COLLECTION */){ return N.I(num.I * 2); }).valueA();
  self.equal(doubled.join(@", "), @"2, 4, 6", @"OO-style doubled numbers");

  /* NOT SUPPORTED: JavaScript-only because of DOM */
//  NSA* ids = _.map($(@"#map-test").children(), ^(n){ return n.id; });
//  deepEqual(ids, AI(@"id1", @"id2"), @"Can use collection methods on NodeLists.");

  /* NOT SUPPORTED: JavaScript-only because of DOM */
//  NSA* ids = _.map(document.images, ^(n){ return n.id; });
//  self.ok(idsAI(0) == "chart_image", @"can use collection methods on HTMLCollections");

  A* ifnil = _.map(nil, ^id(id v, ... /* KEY, COLLECTION */){ return nil; });
  self.ok(_.isArray(ifnil) && ifnil.length == 0, @"handles a nil properly");
}

- (void)test_reduce
{
  N* sum = _.reduce(AI(1, 2, 3), ^(N* sum, N* num, ... /* KEY, COLLECTION */){ return N.I(sum.I + num.I); }, 0);
  self.equalI(sum.I, 6, @"can sum up an array");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  NSD* context = {multiplier : 3};
//  N* sum = _.reduce(AI(1, 2, 3), ^(sum, num){ return sum + num * this.multiplier; }, 0, context);
//  self.equal(sum, 18, @"can reduce with a context object");

  sum = _.inject(AI(1, 2, 3), ^(N* sum, N* num, ... /* KEY, COLLECTION */){ return N.I(sum.I + num.I); }, 0);
  self.equalI(sum.I, 6, @"aliased as 'inject'");

  sum =  __(AI(1, 2, 3)).reduce(^(N* sum, N* num, ... /* KEY, COLLECTION */){ return N.I(sum.I + num.I); }, 0).valueN();
  self.equalI(sum.I, 6, @"OO-style reduce");

  sum = _.reduce(AI(1, 2, 3), ^(N* sum, N* num, ... /* KEY, COLLECTION */){ return N.I(sum.I + num.I); }, /* MANDATORY */ 0);
  self.equalI(sum.I, 6, @"default initial value");

  E* ifnull;
  @try {
    _.reduce(nil, ^(/* MANDATORY */ N* memo, N* num, ... /* KEY, COLLECTION */){ return memo; }, 0);
  } @catch (E* ex) {
    ifnull = ex;
  }
  self.ok(ifnull.instanceof(@"NSException"), @"handles a null (without inital value) properly");

  self.equal(_.reduce(nil, ^(/* MANDATORY */ N* sum, N* num, ... /* KEY, COLLECTION */){ return NSNull.null; }, N.I(138)), N.I(138), @"handles a null (with initial value) properly");

  /* NOT SUPPORTED: JavaScript-only because of 'undefined' */
//  self.equal(_.reduce(A.new, ^{}, undefined), undefined, @"undefined can be passed as a special case");
  self.raises(^{ _.reduce(A.new, ^(/* MANDATORY */ N* memo, N* num, ... /* KEY, COLLECTION */){ return memo; }, /* MANDATORY */ 0); }, @"TypeError", @"throws an error for empty arrays with no initial value");
}

- (void)test_reduceRight
{
  S* list = _.reduceRight(AO(@"foo", @"bar", @"baz"), ^(S* memo, S* str, ... /* KEY, COLLECTION */){ return memo.append(str); }, S.new);
  self.equal(list, @"bazbarfoo", @"can perform right folds");

  list = _.foldr(AO(@"foo", @"bar", @"baz"), ^(S* memo, S* str, ... /* KEY, COLLECTION */){ return memo.append(str); }, S.new);
  self.equal(list, @"bazbarfoo", @"aliased as 'foldr'");

  list = _.foldr(AO(@"foo", @"bar", @"baz"), ^(S* memo, S* str, ... /* KEY, COLLECTION */){ return memo.append(str); }, /* MANDATORY */ nil);
  self.equal(list, @"bazbarfoo", @"default initial value");

  E* ifnull;
  @try {
    _.reduceRight(nil, ^(/* MANDATORY */ N* memo, N* num, ... /* KEY, COLLECTION */){ return memo; }, 0);
  } @catch (E* ex) {
    ifnull = ex;
  }
  self.ok(ifnull.instanceof(@"NSException"), @"handles a null (without inital value) properly");

  self.equal(_.reduceRight(nil, ^(/* MANDATORY */ N* sum, N* num, ... /* KEY, COLLECTION */){ return NSNull.null; }, N.I(138)), N.I(138), @"handles a null (with initial value) properly");

  /* NOT SUPPORTED: JavaScript-only because of 'undefined' */
//  self.equal(_.reduceRight(A.new, ^{}, undefined), undefined, @"undefined can be passed as a special case");
  self.raises(^{ _.reduceRight(A.new, ^(/* MANDATORY */ N* memo, N* num, ... /* KEY, COLLECTION */){ return memo; }, /* MANDATORY */ 0); }, @"TypeError", @"throws an error for empty arrays with no initial value");
}

- (void)test_find
{
  A* array = AI(1, 2, 3, 4);
  self.strictEqual(_.find(array, ^B(N* n) { return n.I > 2; }), N.I(3), @"should return first found `value`");
  self.strictEqual(_.find(array, ^B(/* MANDATORY */ id value) { return false; }), nil, @"should return `undefined` if `value` is not found");
}

- (void)test_detect
{
  N* result = _.detect(AI(1, 2, 3), ^B(N* num){ return num.I * 2 == 4; });
  self.equalI(result.I, 2, @"found the first '2' and broke the loop");
}

- (void)test_filter
{
  A* evens = _.select(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; });
  self.equal(evens.join(@", "), @"2, 4, 6", @"selected each even number");

  evens = _.filter(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; });
  self.equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  evens = _.filterWithContext(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ..., O* this){ return num.I % ((N*)this.get(@"factor")).I == 0; }, OKV({@"factor", N.I(2)})); // ADDED
//  self.equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");
}

- (void)test_reject
{
  A* odds = _.reject(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; });
  self.equal(odds.join(@", "), @"1, 3, 5", @"rejected each even number");
}

- (void)test_all
{
  self.ok(_.all(A.new, /* SPECIALIZED */ _.identityTruthy), @"the empty set");
  self.ok(_.all(AB(true, true, true), /* SPECIALIZED */ _.identityTruthy), @"all true values");
  self.ok(!_.all(AB(true, false, true), /* SPECIALIZED */ _.identityTruthy), @"one false value");
  self.ok(_.all(AI(0, 10, 28), ^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }), @"even numbers");
  self.ok(!_.all(AI(0, 11, 28), ^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }), @"an odd number");
  self.ok(_.all(AI(1), /* SPECIALIZED */ _.identityTruthy) == true, @"cast to boolean - true");
  self.ok(_.all(AI(0), /* SPECIALIZED */ _.identityTruthy) == false, @"cast to boolean - false");
  self.ok(_.every(AB(true, true, true), /* SPECIALIZED */ _.identityTruthy), @"aliased as 'every'");
}

- (void)test_any
{
  self.ok(!_.any(A.new, /* MANDATORY */ nil), @"the empty set");
  self.ok(!_.any(AB(false, false, false), /* MANDATORY */ nil), @"all false values");
  self.ok(_.any(AB(false, false, true), /* MANDATORY */ nil), @"one true value");
  self.ok(_.any(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"yes", N.B(false)), /* MANDATORY */ nil), @"a string");
  self.ok(!_.any(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"", N.B(false)), /* MANDATORY */ nil), @"falsy values");
  self.ok(!_.any(AI(1, 11, 29), ^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }), @"all odd numbers");
  self.ok(_.any(AI(1, 10, 29), ^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }), @"an even number");
  self.ok(_.any(AI(1), /* SPECIALIZED */ _.identityTruthy) == true, @"cast to boolean - true");
  self.ok(_.any(AI(0), /* SPECIALIZED */ _.identityTruthy) == false, @"cast to boolean - false");
  self.ok(_.some(AB(false, false, true), /* MANDATORY */ nil), @"aliased as 'some'");
}

- (void)test_include
{
  self.ok(_.include(AI(1,2,3), N.I(2)), @"two is in the array");
  self.ok(!_.include(AI(1,3,9), N.I(2)), @"two is not in the array");
  self.ok(_.contains(OKV({@"moe",N.I(1)}, {@"larry",N.I(3)}, {@"curly", N.I(9)}), N.I(3)) == true, @"_.include on objects checks their values");
  self.ok(__(AI(1,2,3)).include(N.I(2)).valueB(), @"OO-style include");
}

- (void)test_invoke
{
  NSA* list = AO(AI(5, 1, 7), AI(3, 2, 1));
  NSA* result = (NSA*) _.invoke(list, @"sort", /* MANDATORY */ NSNull.null, /* NIL_TERMINATION */ nil);
  self.equal(result.getAt(0).join(@", "), @"1, 5, 7", @"first array sorted");
  self.equal(result.getAt(1).join(@", "), @"1, 2, 3", @"second array sorted");
}

/* NOT SUPPORTED: JavaScript-only because of prototype */
//- (void)test_invokeWithFunctionReference
//{
//  NSA* list = AO(AI(5, 1, 7), AI(3, 2, 1));
//  NSA* result = _.invoke(list, Array.prototype.sort);
//  self.equal(result[0].join(@", "), @"1, 5, 7", @"first array sorted");
//  self.equal(result[1].join(@", "), @"1, 2, 3", @"second array sorted");
//}

/* NOT SUPPORTED: JavaScript-only because of prototype */
// Relevant when using ClojureScript
//- (void)test_invokeWhenStringsHaveACallMethod
//{
//  String.prototype.call = ^{
//    return 42;
//  };
//  NSA* list = AO(AI(5, 1, 7), AI(3, 2, 1));
//  var s = @"foo";
//  self.equal(s.call(), 42, @"call function exists");
//  var result = _.invoke(list, @"sort");
//  self.equal(result[0].join(@", "), @"1, 5, 7", @"first array sorted");
//  self.equal(result[1].join(@", "), @"1, 2, 3", @"second array sorted");
//  delete String.prototype.call;
//  self.equal(s.call, undefined, @"call function removed");
//}

- (void)test_pluck
{
  A* people = AO(OKV({@"name", @"moe"}, {@"age", N.I(30)}), OKV({@"name", @"curly"}, {@"age", N.I(50)}));
  self.equal(((A*)_.pluck(people, @"name")).join(@", "), @"moe, curly", @"pulls names out of objects");
}

- (void)test_max
{
  self.equal(N.I(3), _.max(AI(1, 2, 3), /* MANDATORY */ nil), @"can perform a regular Math.max");

  N* neg = (N*) _.max(AI(1, 2, 3), ^(N* num){ return N.I(-num.I); });
  self.equal(neg, N.I(1), @"can perform a computation-based max");

  self.equal(NF_NEG_INFINITY, _.max(O.new, /* MANDATORY */ nil), @"Maximum value of an empty object");
  self.equal(NF_NEG_INFINITY, _.max(A.new, /* MANDATORY */ nil), @"Maximum value of an empty array");

  self.equal(N.I(299999), _.max(_.range(1,300000, /* MANDATORY */ 1), /* MANDATORY */ nil ), @"Maximum value of a too-big array");
}

- (void)test_min
{
  self.equal(N.I(1), _.min(AI(1, 2, 3), /* MANDATORY */ nil), @"can perform a regular Math.min");

  N* neg = (N*) _.min(AI(1, 2, 3), ^(N* num){ return N.I(-num.I); });
  self.equalI(neg.I, 3, @"can perform a computation-based min");

  self.equal(NF_POS_INFINITY, _.min(O.new, /* MANDATORY */ nil), @"Minimum value of an empty object");
  self.equal(NF_POS_INFINITY, _.min(A.new, /* MANDATORY */ nil), @"Minimum value of an empty array");

  Date* now = [Date distantFuture];
  Date* then = Date.new;
  self.equal(_.min(AO(now, then), /* MANDATORY */ nil), then, @"the time is now");

  self.equal(N.I(1), _.min(_.range(1,300000, /* MANDATORY */ 1), /* MANDATORY */ nil), @"Minimum value of a too-big array");
}

- (void)test_sortBy
{
  A* people = AO(OKV({@"name", @"curly"}, {@"age", N.I(50)}), OKV({@"name", @"moe"}, {@"age", N.I(30)}));
  people = _.sortBy(people, ^(O* person){ return person.get(@"age"); });
  self.equal(_.pluck(people, @"name").join(@", "), @"moe, curly", @"stooges sorted by age");

/* NOT SUPPORTED: JavaScript-only because of undefined */
//  A* list = [undefined, 4, 1, undefined, 3, 2];
//  self.equal(_.sortBy(list, _.identity).join(@","), @"1,2,3,4,,", @"sortBy with undefined values");

  A* list = AO(@"one", @"two", @"three", @"four", @"five");
  NSA* sorted = _.sortBy(list, @"length");
  self.equal(sorted.join(@" "), @"one two four five three", @"sorted by length");
}

- (void)test_groupBy
{
  O* parity = _.groupBy(AI(1, 2, 3, 4, 5, 6), ^(N* num, ... /* KEY, COLLECTION */){ return N.I(num.I % 2); });
  
  self.ok(N.I(0).in(parity) && N.I(1).in(parity), @"created a group for each value");
  self.equal(parity.get(N.I(0)).join(@", "), @"2, 4, 6", @"put each even number in the right group");

  A* list = AO(@"one", @"two", @"three", @"four", @"five", @"six", @"seven", @"eight", @"nine", @"ten");
  O* grouped = _.groupBy(list, @"length");
  self.equal(grouped.get(N.I(3)).join(@" "), @"one two six ten", @"");
  self.equal(grouped.get(N.I(4)).join(@" "), @"four five nine", @"");
  self.equal(grouped.get(N.I(5)).join(@" "), @"three seven eight", @"");
}

- (void)test_sortedIndex
{
  A* numbers = AI(10, 20, 30, 40, 50); N* num = N.I(35);
  I indexForNum = _.sortedIndex(numbers, num, /* MANDATORY */ nil);
  self.equalI(indexForNum, 3, @"35 should be inserted at index 3");

  I indexFor30 = _.sortedIndex(numbers, N.I(30), /* MANDATORY */ nil);
  self.equalI(indexFor30, 2, @"30 should be inserted at index 2");
}

- (void)test_shuffle
{
  A* numbers = _.range1(10); /* SPECIALIZED */
  NSA* shuffled = _.shuffle(numbers).sort(/* MANDATORY */ nil);
  self.notStrictEqual(numbers, shuffled, @"original object is unmodified");
  self.equal(shuffled.join(@","), numbers.join(@","), @"contains the same members before and after shuffle");
}

- (void)test_toArray
{
  (^(id arg1, ...) {
    ARGS_AO(arguments, arg1);
    self.equalI(arguments.length, 2, @"argument passed");

//    self.ok(!_.isArray(arguments), @"arguments object is not an array"); /* NOT SUPPORTED: JavaScript-only because of arguments object */
    self.ok(_.isArray(_.toArray(arguments)), @"arguments object converted into array");
  })(N.I(0), S.new, nil);

  NSA* a = AI(1,2,3);
  self.ok(_.toArray(a) != a, @"array is cloned");
  self.equal(_.toArray(a).join(@", "), @"1, 2, 3", @"cloned array contains same elements");

  NSA* numbers = _.toArray(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}));
  self.equal(numbers.join(@", "), @"1, 2, 3", @"object flattened into array");

  O* objectWithToArrayFunction = OKV({@"toArray", ^{
    return AI(1, 2, 3);
  }});
  self.equal(_.toArray(objectWithToArrayFunction).join(@", "), @"1, 2, 3", @"toArray method used if present");

  O* objectWithToArrayValue = OKV({@"toArray", N.I(1)});
  self.equal(_.toArray(objectWithToArrayValue).join(@", "), @"1", @"toArray property ignored if not a function");
}

- (void)test_size
{
  self.equalI(_.size(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)})), 3, @"can compute the size of an object");
  self.equalI(_.size(AI(1, 2, 3)), 3, @"can compute the size of an array");
}

@end