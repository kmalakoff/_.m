//
//  _+CollectionsTests.m
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

#import "_+CollectionsTests.h"
#import "QUnit.h"
#import "Underscore.h"

// for test_sortByNamed
@interface Stooge : O
  @property (strong) NSS* name;
  @property (strong) N* age;
@end
@implementation Stooge
  @dynamic name, age;
  IMPLEMENT_NAMED_PROPERTIES
@end

@implementation __CollectionsTests

- (void)test_each
{
  _.each(AI(1, 2, 3), ^(N* num, ... /* KEY, LIST */) {
    ARGS_INDEX(num);
    equal(num.I, index + 1, @"each iterators provide value and iteration count");
  });

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  __block A* answers = A.new;
//  _.each(AI(1, 2, 3), ^(N* num, ..., O* this){ answers.push(N.I(num.I * this.get(@"multiplier")).I));}, OKV({@"multiplier", N.I(5)}));
//  equal(answers.join(@", "), @"5, 10, 15", @"context object property accessed");

  __block A* answers = A.new;
  _.forEach(AI(1, 2, 3), ^(N* num, ... /* KEY, LIST */){ answers.push(num); });
  equal(answers.join(@", "), @"1, 2, 3", @"aliased as 'forEach'");

  /* NOT SUPPORTED: JavaScript-only because of prototype */
  answers =  A.new;
  O* obj = OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)});
//  obj.constructor.prototype.four = 4; 
  _.each(obj, ^(id value, ... /* KEY, LIST */){ ARGS_KEY(value); answers.push(key); });
  equal(answers.join(@", "), @"one, two, three", @"iterating over objects works, and ignores the object prototype.");
//  delete obj.constructor.prototype.four;

  __block B answer = false;
  _.each(AI(1, 2, 3), ^(N* num, ... /* KEY, LIST */){ ARGS_LIST(num, arr); if (_.include(arr, num)) answer = true; });
  ok(answer, @"can reference the original collection from inside the iterator");

  __block I iAnswers = 0;
  _.each(nil, ^(id v, ... /* KEY, LIST */){ ++iAnswers; });
  equal(iAnswers, 0, @"handles a nil properly");
}

- (void)test_map
{
  A* doubled = _.map(AI(1, 2, 3), ^(N* num, ... /* KEY, LIST */){ return N.I(num.I * 2); });
  equal(doubled.join(@", "), @"2, 4, 6", @"doubled numbers");

  doubled = _.collect(AI(1, 2, 3), ^(N* num, ... /* KEY, LIST */){ return N.I(num.I * 2); });
  equal(doubled.join(@", "), @"2, 4, 6", @"aliased as 'collect'");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  __block A* tripled = _.mapWithContext(AI(1, 2, 3), ^(N* num, ..., O* this){ return N.I(num.I * this.get(@"multiplier")).I); }, OKV({@"multiplier", N.I(3)})); // CHANGE
//  equal(tripled.join(@", "), @"3, 6, 9", @"tripled numbers with context");

  doubled =  __(AI(1, 2, 3)).map(^(N* num, ... /* KEY, LIST */){ return N.I(num.I * 2); }).A;
  equal(doubled.join(@", "), @"2, 4, 6", @"OO-style doubled numbers");

  /* NOT SUPPORTED: JavaScript-only because of DOM */
//  NSA* ids = _.map($(@"#map-test").children(), ^(n){ return n.id; });
//  deepEqual(ids, AI(@"id1", @"id2"), @"Can use collection methods on NodeLists.");

  /* NOT SUPPORTED: JavaScript-only because of DOM */
//  NSA* ids = _.map(document.images, ^(n){ return n.id; });
//  ok(idsAI(0) == "chart_image", @"can use collection methods on HTMLCollections");

  A* ifnil = _.map(nil, ^id(id v, ... /* KEY, LIST */){ return nil; });
  ok(_.isArray(ifnil) && ifnil.length == 0, @"handles a nil properly");
}

- (void)test_reduce
{
  N* sum = _.reduce(AI(1, 2, 3), ^(N* sum, N* num, ... /* KEY, LIST */){ return N.I(sum.I + num.I); }, 0);
  equal(sum.I, 6, @"can sum up an array");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  NSD* context = {multiplier : 3};
//  N* sum = _.reduce(AI(1, 2, 3), ^(sum, num){ return sum + num * this.multiplier; }, 0, context);
//  equal(sum, 18, @"can reduce with a context object");

  sum = (N*) _.inject(AI(1, 2, 3), ^(N* sum, N* num, ... /* KEY, LIST */){ return N.I(sum.I + num.I); }, 0);
  equal(sum.I, 6, @"aliased as 'inject'");

  sum =  __(AI(1, 2, 3)).reduce(^(N* sum, N* num, ... /* KEY, LIST */){ return N.I(sum.I + num.I); }, 0).N;
  equal(sum.I, 6, @"OO-style reduce");

  sum = _.reduce(AI(1, 2, 3), ^(N* sum, N* num, ... /* KEY, LIST */){ return N.I(sum.I + num.I); }, /* REQUIRED */ 0);
  equal(sum.I, 6, @"default initial value");

  E* ifnull;
  @try {
    _.reduce(nil, ^(/* REQUIRED */ N* memo, N* num, ... /* KEY, LIST */){ return memo; }, 0);
  } @catch (E* ex) {
    ifnull = ex;
  }
  ok(ifnull.instanceof(NSException.class), @"handles a null (without inital value) properly");

  equal(_.reduce(nil, ^(/* REQUIRED */ N* sum, N* num, ... /* KEY, LIST */){ return NSNull.null; }, N.I(138)), N.I(138), @"handles a null (with initial value) properly");

  /* NOT SUPPORTED: JavaScript-only because of 'undefined' */
//  equal(_.reduce(A.new, ^{}, undefined), undefined, @"undefined can be passed as a special case");
  raises(^{ _.reduce(A.new, ^(/* REQUIRED */ N* memo, N* num, ... /* KEY, LIST */){ return memo; }, /* REQUIRED */ 0); }, @"TypeError", @"throws an error for empty arrays with no initial value");
}

- (void)test_reduceRight
{
  S* list = (S*) _.reduceRight(AO(@"foo", @"bar", @"baz"), ^(S* memo, S* str, ... /* KEY, LIST */){ return memo.add(str); }, S.new);
  equal(list, @"bazbarfoo", @"can perform right folds");

  list = (S*) _.foldr(AO(@"foo", @"bar", @"baz"), ^(S* memo, S* str, ... /* KEY, LIST */){ return memo.add(str); }, S.new);
  equal(list, @"bazbarfoo", @"aliased as 'foldr'");

  list = (S*) _.foldr(AO(@"foo", @"bar", @"baz"), ^(S* memo, S* str, ... /* KEY, LIST */){ return memo.add(str); }, /* REQUIRED */ nil);
  equal(list, @"bazbarfoo", @"default initial value");

  E* ifnull;
  @try {
    _.reduceRight(nil, ^(/* REQUIRED */ N* memo, N* num, ... /* KEY, LIST */){ return memo; }, 0);
  } @catch (E* ex) {
    ifnull = ex;
  }
  ok(ifnull.instanceof(NSException.class), @"handles a null (without inital value) properly");

  equal(_.reduceRight(nil, ^(/* REQUIRED */ N* sum, N* num, ... /* KEY, LIST */){ return NSNull.null; }, N.I(138)), N.I(138), @"handles a null (with initial value) properly");

  /* NOT SUPPORTED: JavaScript-only because of 'undefined' */
//  equal(_.reduceRight(A.new, ^{}, undefined), undefined, @"undefined can be passed as a special case");
  raises(^{ _.reduceRight(A.new, ^(/* REQUIRED */ N* memo, N* num, ... /* KEY, LIST */){ return memo; }, /* REQUIRED */ 0); }, @"TypeError", @"throws an error for empty arrays with no initial value");
}

- (void)test_find
{
  A* array = AI(1, 2, 3, 4);
  strictEqual(_.find(array, ^B(N* n) { return n.I > 2; }), N.I(3), @"should return first found `value`");
  strictEqual(_.find(array, ^B(/* REQUIRED */ id value) { return false; }), nil, @"should return `undefined` if `value` is not found");
}

- (void)test_detect
{
  N* result = (N*) _.detect(AI(1, 2, 3), ^B(N* num){ return num.I * 2 == 4; });
  equal(result.I, 2, @"found the first '2' and broke the loop");
}

- (void)test_filter
{
  A* evens = _.select(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; });
  equal(evens.join(@", "), @"2, 4, 6", @"selected each even number");

  evens = _.filter(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; });
  equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  evens = _.filterWithContext(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ..., O* this){ return num.I % this.get(@"factor")).I == 0; }, OKV({@"factor", N.I(2)})); // ADDED
//  equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");
}

- (void)test_reject
{
  A* odds = _.reject(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; });
  equal(odds.join(@", "), @"1, 3, 5", @"rejected each even number");
}

- (void)test_all
{
  ok(_.all(A.new, /* SPECIALIZED */ _.identityTruthy), @"the empty set");
  ok(_.all(AB(true, true, true), /* SPECIALIZED */ _.identityTruthy), @"all true values");
  ok(!_.all(AB(true, false, true), /* SPECIALIZED */ _.identityTruthy), @"one false value");
  ok(_.all(AI(0, 10, 28), ^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }), @"even numbers");
  ok(!_.all(AI(0, 11, 28), ^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }), @"an odd number");
  ok(_.all(AI(1), /* SPECIALIZED */ _.identityTruthy) == true, @"cast to boolean - true");
  ok(_.all(AI(0), /* SPECIALIZED */ _.identityTruthy) == false, @"cast to boolean - false");
  ok(_.every(AB(true, true, true), /* SPECIALIZED */ _.identityTruthy), @"aliased as 'every'");
}

- (void)test_any
{
  ok(!_.any(A.new, /* REQUIRED */ nil), @"the empty set");
  ok(!_.any(AB(false, false, false), /* REQUIRED */ nil), @"all false values");
  ok(_.any(AB(false, false, true), /* REQUIRED */ nil), @"one true value");
  ok(_.any(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"yes", N.B(false)), /* REQUIRED */ nil), @"a string");
  ok(!_.any(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"", N.B(false)), /* REQUIRED */ nil), @"falsy values");
  ok(!_.any(AI(1, 11, 29), ^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }), @"all odd numbers");
  ok(_.any(AI(1, 10, 29), ^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }), @"an even number");
  ok(_.any(AI(1), /* SPECIALIZED */ _.identityTruthy) == true, @"cast to boolean - true");
  ok(_.any(AI(0), /* SPECIALIZED */ _.identityTruthy) == false, @"cast to boolean - false");
  ok(_.some(AB(false, false, true), /* REQUIRED */ nil), @"aliased as 'some'");
}

- (void)test_include
{
  ok(_.include(AI(1,2,3), N.I(2)), @"two is in the array");
  ok(!_.include(AI(1,3,9), N.I(2)), @"two is not in the array");
  ok(_.contains(OKV({@"moe",N.I(1)}, {@"larry",N.I(3)}, {@"curly", N.I(9)}), N.I(3)) == true, @"_.include on objects checks their values");
  ok(__(AI(1,2,3)).include(N.I(2)).B, @"OO-style include");
}

- (void)test_invoke
{
  NSA* list = AO(AI(5, 1, 7), AI(3, 2, 1));
  NSA* result = (NSA*) _.invoke(list, @"sort", /* REQUIRED */ NSNull.null, /* NIL_TERMINATION */ nil);
  equal(result.getAt(0).join(@", "), @"1, 5, 7", @"first array sorted");
  equal(result.getAt(1).join(@", "), @"1, 2, 3", @"second array sorted");
}

/* NOT SUPPORTED: JavaScript-only because of prototype */
//- (void)test_invokeWithFunctionReference
//{
//  NSA* list = AO(AI(5, 1, 7), AI(3, 2, 1));
//  NSA* result = _.invoke(list, Array.prototype.sort);
//  equal(result[0].join(@", "), @"1, 5, 7", @"first array sorted");
//  equal(result[1].join(@", "), @"1, 2, 3", @"second array sorted");
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
//  equal(s.call(), 42, @"call function exists");
//  var result = _.invoke(list, @"sort");
//  equal(result[0].join(@", "), @"1, 5, 7", @"first array sorted");
//  equal(result[1].join(@", "), @"1, 2, 3", @"second array sorted");
//  delete String.prototype.call;
//  equal(s.call, undefined, @"call function removed");
//}

- (void)test_pluck
{
  A* people = AO(OKV({@"name", @"moe"}, {@"age", N.I(30)}), OKV({@"name", @"curly"}, {@"age", N.I(50)}));
  equal(((A*)_.pluck(people, @"name")).join(@", "), @"moe, curly", @"pulls names out of objects");
}

- (void)test_max
{
  equal(N.I(3), _.max(AI(1, 2, 3), /* REQUIRED */ nil), @"can perform a regular Math.max");

  N* neg = (N*) _.max(AI(1, 2, 3), ^(N* num){ return N.I(-num.I); });
  equal(neg, N.I(1), @"can perform a computation-based max");

  equal(NF_NEG_INFINITY, _.max(O.new, /* REQUIRED */ nil), @"Maximum value of an empty object");
  equal(NF_NEG_INFINITY, _.max(A.new, /* REQUIRED */ nil), @"Maximum value of an empty array");

  equal(N.I(299999), _.max(_.range(1,300000, /* REQUIRED */ 1), /* REQUIRED */ nil), @"Maximum value of a too-big array");
}

- (void)test_min
{
  equal(N.I(1), _.min(AI(1, 2, 3), /* REQUIRED */ nil), @"can perform a regular Math.min");

  N* neg = (N*) _.min(AI(1, 2, 3), ^(N* num){ return N.I(-num.I); });
  equal(neg.I, 3, @"can perform a computation-based min");

  equal(NF_POS_INFINITY, _.min(O.new, /* REQUIRED */ nil), @"Minimum value of an empty object");
  equal(NF_POS_INFINITY, _.min(A.new, /* REQUIRED */ nil), @"Minimum value of an empty array");

  Date* now = [Date distantFuture];
  Date* then = Date.new;
  equal(_.min(AO(now, then), /* REQUIRED */ nil), then, @"the time is now");

  equal(N.I(1), _.min(_.range(1,300000, /* REQUIRED */ 1), /* REQUIRED */ nil), @"Minimum value of a too-big array");
}

- (void)test_sortBy
{
  A* people = AO(OKV({@"name", @"curly"}, {@"age", N.I(50)}), OKV({@"name", @"moe"}, {@"age", N.I(30)}));
  people = (A*) _.sortBy(people, ^(O* person){ return person.get(@"age"); });
  equal(_.pluck(people, @"name").join(@", "), @"moe, curly", @"stooges sorted by age");

/* NOT SUPPORTED: JavaScript-only because of undefined */
//  A* list = [undefined, 4, 1, undefined, 3, 2];
//  equal(_.sortBy(list, _.identity).join(@","), @"1,2,3,4,,", @"sortBy with undefined values");

  A* list = AO(@"one", @"two", @"three", @"four", @"five");
  NSA* sorted = (NSA*) _.sortBy(list, @"length");
  equal(sorted.join(@" "), @"one two four five three", @"sorted by length");
}

- (void)test_sortByNamed
{
  A* people = AO(OTKV(Stooge, {@"name", @"curly"}, {@"age", N.I(50)}), OTKV(Stooge, {@"name", @"moe"}, {@"age", N.I(30)}));
  people = (A*) _.sortBy(people, ^(Stooge* person){ return person.age; });
  equal(_.pluck(people, @"name").join(@", "), @"moe, curly", @"stooges sorted by age");

/* NOT SUPPORTED: JavaScript-only because of undefined */
//  A* list = [undefined, 4, 1, undefined, 3, 2];
//  equal(_.sortBy(list, _.identity).join(@","), @"1,2,3,4,,", @"sortBy with undefined values");

  A* list = AO(@"one", @"two", @"three", @"four", @"five");
  NSA* sorted = (NSA*) _.sortBy(list, @"length");
  equal(sorted.join(@" "), @"one two four five three", @"sorted by length");
}

- (void)test_groupBy
{
  O* parity = _.groupBy(AI(1, 2, 3, 4, 5, 6), ^(N* num, ... /* KEY, LIST */){ return N.I(num.I % 2); });
  
  ok(N.I(0).in(parity) && N.I(1).in(parity), @"created a group for each value");
  equal(parity.get(N.I(0)).join(@", "), @"2, 4, 6", @"put each even number in the right group");

  A* list = AO(@"one", @"two", @"three", @"four", @"five", @"six", @"seven", @"eight", @"nine", @"ten");
  O* grouped = _.groupBy(list, @"length");
  equal(grouped.get(N.I(3)).join(@" "), @"one two six ten", @"");
  equal(grouped.get(N.I(4)).join(@" "), @"four five nine", @"");
  equal(grouped.get(N.I(5)).join(@" "), @"three seven eight", @"");
}

- (void)test_sortedIndex
{
  A* numbers = AI(10, 20, 30, 40, 50); N* num = N.I(35);
  UI indexForNum = _.sortedIndex(numbers, num, /* REQUIRED */ nil);
  equal(indexForNum, 3, @"35 should be inserted at index 3");

  UI indexFor30 = _.sortedIndex(numbers, N.I(30), /* REQUIRED */ nil);
  equal(indexFor30, 2, @"30 should be inserted at index 2");
}

- (void)test_shuffle
{
  A* numbers = _.rangeSimple(10); /* SPECIALIZED */
  NSA* shuffled = _.shuffle(numbers).sort(/* REQUIRED */ nil);
  notStrictEqual(numbers, shuffled, @"original object is unmodified");
  equal(shuffled.join(@","), numbers.join(@","), @"contains the same members before and after shuffle");
}

- (void)test_toArray
{
  (^(id arg1, ...) {
    ARGS_AO(arguments, arg1);
    equal(arguments.length, 2, @"argument passed");

//    ok(!_.isArray(arguments), @"arguments object is not an array"); /* NOT SUPPORTED: JavaScript-only because of arguments object */
    ok(_.isArray(_.toArray(arguments)), @"arguments object converted into array");
  })(N.I(0), S.new, nil);

  NSA* a = AI(1,2,3);
  ok(_.toArray(a) != a, @"array is cloned");
  equal(_.toArray(a).join(@", "), @"1, 2, 3", @"cloned array contains same elements");

  NSA* numbers = _.toArray(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}));
  equal(numbers.join(@", "), @"1, 2, 3", @"object flattened into array");

  O* objectWithToArrayFunction = OKV({@"toArray", ^{
    return AI(1, 2, 3);
  }});
  equal(_.toArray(objectWithToArrayFunction).join(@", "), @"1, 2, 3", @"toArray method used if present");

  O* objectWithToArrayValue = OKV({@"toArray", N.I(1)});
  equal(_.toArray(objectWithToArrayValue).join(@", "), @"1", @"toArray property ignored if not a function");
}

- (void)test_size
{
  equal(_.size(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)})), 3, @"can compute the size of an object");
  equal(_.size(AI(1, 2, 3)), 3, @"can compute the size of an array");
}

@end