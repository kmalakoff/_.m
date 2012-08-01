//
//  _Wrapper+CollectionsTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Wrapper+CollectionsTests.h"
#import "QUnit.h"
#import "Underscore.h"

@implementation _Wrapper_CollectionsTests

- (void)test_each
{
  _.chain(AI(1, 2, 3)).each(^(N* num, ... /* KEY, LIST */) {
    ARGS_INDEX(num);
    equal(num.I, index + 1, @"each iterators provide value and iteration count");
  });

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  __block A* answers = A.new;
//  _.each(AI(1, 2, 3), ^(N* num, ..., O* this){ answers.push(N.I(num.I * this.get(@"multiplier")).I));}, OKV({@"multiplier", N.I(5)}));
//  equal(answers.join(@", "), @"5, 10, 15", @"context object property accessed");

  __block A* answers = A.new;
  _.chain(AI(1, 2, 3)).forEach(^(N* num, ... /* KEY, LIST */){ answers.push(num); });
  equal(answers.join(@", "), @"1, 2, 3", @"aliased as 'forEach'");

  /* NOT SUPPORTED: JavaScript-only because of prototype */
  answers =  A.new;
  O* obj = OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)});
//  obj.constructor.prototype.four = 4; 
  _.chain(obj).each(^(id value, ... /* KEY, LIST */){ ARGS_KEY(value); answers.push(key); });
  equal(answers.join(@", "), @"one, two, three", @"iterating over objects works, and ignores the object prototype.");
//  delete obj.constructor.prototype.four;

  __block B answer = false;
  _.chain(AI(1, 2, 3)).each(^(N* num, ... /* KEY, LIST */){ ARGS_LIST(num, arr); if (_.chain(arr).include(num).B) answer = true; });
  ok(answer, @"can reference the original collection from inside the iterator");

  __block I iAnswers = 0;
  _.chain(nil).each(^(id v, ... /* KEY, LIST */){ ++iAnswers; });
  equal(iAnswers, 0, @"handles a nil properly");
}

- (void)test_map
{
  A* doubled = _.chain(AI(1, 2, 3)).map(^(N* num, ... /* KEY, LIST */){ return N.I(num.I * 2); }).A;
  equal(doubled.join(@", "), @"2, 4, 6", @"doubled numbers");

  doubled = _.chain(AI(1, 2, 3)).collect(^(N* num, ... /* KEY, LIST */){ return N.I(num.I * 2); }).A;
  equal(doubled.join(@", "), @"2, 4, 6", @"aliased as 'collect'");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  __block A* tripled = _.mapWithContext(AI(1, 2, 3), ^(N* num, ..., O* this){ return N.I(num.I * this.get(@"multiplier")).I); }, OKV({@"multiplier", N.I(3)})); // CHANGE
//  equal(tripled.join(@", "), @"3, 6, 9", @"tripled numbers with context");

  doubled =  _.chain(AI(1, 2, 3)).map(^(N* num, ... /* KEY, LIST */){ return N.I(num.I * 2); }).A;
  equal(doubled.join(@", "), @"2, 4, 6", @"OO-style doubled numbers");

  /* NOT SUPPORTED: JavaScript-only because of DOM */
//  NSA* ids = _.map($(@"#map-test").children(), ^(n){ return n.id; });
//  deepEqual(ids, AI(@"id1", @"id2"), @"Can use collection methods on NodeLists.");

  /* NOT SUPPORTED: JavaScript-only because of DOM */
//  NSA* ids = _.map(document.images, ^(n){ return n.id; });
//  ok(idsAI(0) == "chart_image", @"can use collection methods on HTMLCollections");

  A* ifnil = _.chain(nil).map(^id(id v, ... /* KEY, LIST */){ return nil; }).A;
  ok(_.chain(ifnil).isArray().B && ifnil.length == 0, @"handles a nil properly");
}

- (void)test_reduce
{
  I sum = _.chain(AI(1, 2, 3)).reduce(^(N* sum, N* num, ... /* KEY, LIST */){ return N.I(sum.I + num.I); }, 0).I;
  equal(sum, 6, @"can sum up an array");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  NSD* context = {multiplier : 3};
//  N* sum = _.reduce(AI(1, 2, 3), ^(sum, num){ return sum + num * this.multiplier; }, 0, context);
//  equal(sum, 18, @"can reduce with a context object");

  sum = _.chain(AI(1, 2, 3)).inject(^(N* sum, N* num, ... /* KEY, LIST */){ return N.I(sum.I + num.I); }, 0).I;
  equal(sum, 6, @"aliased as 'inject'");

  sum =  _.chain(AI(1, 2, 3)).reduce(^(N* sum, N* num, ... /* KEY, LIST */){ return N.I(sum.I + num.I); }, 0).I;
  equal(sum, 6, @"OO-style reduce");

  sum = _.chain(AI(1, 2, 3)).reduce(^(N* sum, N* num, ... /* KEY, LIST */){ return N.I(sum.I + num.I); }, /* REQUIRED */ 0).I;
  equal(sum, 6, @"default initial value");

  E* ifnull;
  @try {
    _.chain(nil).reduce(^(/* REQUIRED */ N* memo, N* num, ... /* KEY, LIST */){ return memo; }, 0);
  } @catch (E* ex) {
    ifnull = ex;
  }
  ok(ifnull.instanceof(NSException.class), @"handles a null (without inital value) properly");

  equal(_.chain(nil).reduce(^(/* REQUIRED */ N* sum, N* num, ... /* KEY, LIST */){ return NSNull.null; }, N.I(138)).I, 138, @"handles a null (with initial value) properly");

  /* NOT SUPPORTED: JavaScript-only because of 'undefined' */
//  equal(_.reduce(A.new, ^{}, undefined), undefined, @"undefined can be passed as a special case");
  raises(^{ _.chain(A.new).reduce(^(/* REQUIRED */ N* memo, N* num, ... /* KEY, LIST */){ return memo; }, /* REQUIRED */ 0); }, @"TypeError", @"throws an error for empty arrays with no initial value");
}

- (void)test_reduceRight
{
  S* list = _.chain(AO(@"foo", @"bar", @"baz")).reduceRight(^(S* memo, S* str, ... /* KEY, LIST */){ return memo.add(str); }, S.new).S;
  equal(list, @"bazbarfoo", @"can perform right folds");

  list = _.chain(AO(@"foo", @"bar", @"baz")).foldr(^(S* memo, S* str, ... /* KEY, LIST */){ return memo.add(str); }, S.new).S;
  equal(list, @"bazbarfoo", @"aliased as 'foldr'");

  list = _.chain(AO(@"foo", @"bar", @"baz")).foldr(^(S* memo, S* str, ... /* KEY, LIST */){ return memo.add(str); }, /* REQUIRED */ nil).S;
  equal(list, @"bazbarfoo", @"default initial value");

  E* ifnull;
  @try {
    _.chain(nil).reduceRight(^(/* REQUIRED */ N* memo, N* num, ... /* KEY, LIST */){ return memo; }, 0);
  } @catch (E* ex) {
    ifnull = ex;
  }
  ok(ifnull.instanceof(NSException.class), @"handles a null (without inital value) properly");

  equal(_.chain(nil).reduceRight(^(/* REQUIRED */ N* sum, N* num, ... /* KEY, LIST */){ return NSNull.null; }, N.I(138)).I, 138, @"handles a null (with initial value) properly");

  /* NOT SUPPORTED: JavaScript-only because of 'undefined' */
//  equal(_.reduceRight(A.new, ^{}, undefined), undefined, @"undefined can be passed as a special case");
  raises(^{ _.chain(A.new).reduceRight(^(/* REQUIRED */ N* memo, N* num, ... /* KEY, LIST */){ return memo; }, /* REQUIRED */ 0); }, @"TypeError", @"throws an error for empty arrays with no initial value");
}

- (void)test_find
{
  A* array = AI(1, 2, 3, 4);
  strictEqual(_.chain(array).find(^B(N* n) { return n.I > 2; }).N, N.I(3), @"should return first found `value`");
  strictEqual(_.chain(array).find(^B(/* REQUIRED */ id value) { return false; }).value(), nil, @"should return `undefined` if `value` is not found");
}

- (void)test_detect
{
  I result = _.chain(AI(1, 2, 3)).detect(^B(N* num){ return num.I * 2 == 4; }).I;
  equal(result, 2, @"found the first '2' and broke the loop");
}

- (void)test_filter
{
  A* evens = _.chain(AI(1, 2, 3, 4, 5, 6)).select(^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }).A;
  equal(evens.join(@", "), @"2, 4, 6", @"selected each even number");

  evens = _.chain(AI(1, 2, 3, 4, 5, 6)).filter(^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }).A;
  equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  evens = _.filterWithContext(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ..., O* this){ return num.I % this.get(@"factor")).I == 0; }, OKV({@"factor", N.I(2)})); // ADDED
//  equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");
}

- (void)test_reject
{
  A* odds = _.chain(AI(1, 2, 3, 4, 5, 6)).reject(^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }).A;
  equal(odds.join(@", "), @"1, 3, 5", @"rejected each even number");
}

- (void)test_all
{
  ok(_.chain(A.new).all(/* SPECIALIZED */ _.identityTruthy).B, @"the empty set");
  ok(_.chain(AB(true, true, true)).all(/* SPECIALIZED */ _.identityTruthy).B, @"all true values");
  ok(!_.chain(AB(true, false, true)).all(/* SPECIALIZED */ _.identityTruthy).B, @"one false value");
  ok(_.chain(AI(0, 10, 28)).all(^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }).B, @"even numbers");
  ok(!_.chain(AI(0, 11, 28)).all(^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }).B, @"an odd number");
  ok(_.chain(AI(1)).all(/* SPECIALIZED */ _.identityTruthy).B == true, @"cast to boolean - true");
  ok(_.chain(AI(0)).all(/* SPECIALIZED */ _.identityTruthy).B == false, @"cast to boolean - false");
  ok(_.chain(AB(true, true, true)).every(/* SPECIALIZED */ _.identityTruthy).B, @"aliased as 'every'");
}

- (void)test_any
{
  ok(!_.chain(A.new).any(/* REQUIRED */ nil).B, @"the empty set");
  ok(!_.chain(AB(false, false, false)).any(/* REQUIRED */ nil).B, @"all false values");
  ok(_.chain(AB(false, false, true)).any(/* REQUIRED */ nil).B, @"one true value");
  ok(_.chain(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"yes", N.B(false))).any(/* REQUIRED */ nil).B, @"a string");
  ok(!_.chain(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"", N.B(false))).any(/* REQUIRED */ nil).B, @"falsy values");
  ok(!_.chain(AI(1, 11, 29)).any(^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }).B, @"all odd numbers");
  ok(_.chain(AI(1, 10, 29)).any(^B(N* num, ... /* KEY, LIST */){ return num.I % 2 == 0; }).B, @"an even number");
  ok(_.chain(AI(1)).any(/* SPECIALIZED */ _.identityTruthy).B == true, @"cast to boolean - true");
  ok(_.chain(AI(0)).any(/* SPECIALIZED */ _.identityTruthy).B == false, @"cast to boolean - false");
  ok(_.chain(AB(false, false, true)).some(/* REQUIRED */ nil).B, @"aliased as 'some'");
}

- (void)test_include
{
  ok(_.chain(AI(1,2,3)).include(N.I(2)).B, @"two is in the array");
  ok(!_.chain(AI(1,3,9)).include(N.I(2)).B, @"two is not in the array");
  ok(_.chain(OKV({@"moe",N.I(1)}, {@"larry",N.I(3)}, {@"curly", N.I(9)})).contains(N.I(3)).B == true, @"_.include on objects checks their values");
  ok(_.chain(AI(1,2,3)).include(N.I(2)).B, @"OO-style include");
}

- (void)test_invoke
{
  NSA* list = AO(AI(5, 1, 7), AI(3, 2, 1));
  NSA* result = (NSA*) _.chain(list).invoke(@"sort", /* REQUIRED */ NSNull.null, /* NIL_TERMINATION */ nil).NSA;
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
  equal(_.chain(people).pluck(@"name").NSA.join(@", "), @"moe, curly", @"pulls names out of objects");
}

- (void)test_max
{
  equal(3, _.chain(AI(1, 2, 3)).max(/* REQUIRED */ nil).I, @"can perform a regular Math.max");

  I neg = _.chain(AI(1, 2, 3)).max(^(N* num){ return N.I(-num.I); }).I;
  equal(neg, 1, @"can perform a computation-based max");

  equal(NF_NEG_INFINITY, _.chain(O.new).max(/* REQUIRED */ nil).N, @"Maximum value of an empty object");
  equal(NF_NEG_INFINITY, _.chain(A.new).max(/* REQUIRED */ nil).N, @"Maximum value of an empty array");

  equal(299999, _.chain(nil).range(1,300000, /* REQUIRED */ 1).max(/* REQUIRED */ nil).I, @"Maximum value of a too-big array");
}

- (void)test_min
{
  equal(1, _.chain(AI(1, 2, 3)).min(/* REQUIRED */ nil).I, @"can perform a regular Math.min");

  I neg = _.chain(AI(1, 2, 3)).min(^(N* num){ return N.I(-num.I); }).I;
  equal(neg, 3, @"can perform a computation-based min");

  equal(NF_POS_INFINITY, _.chain(O.new).min(/* REQUIRED */ nil).N, @"Minimum value of an empty object");
  equal(NF_POS_INFINITY, _.chain(A.new).min(/* REQUIRED */ nil).N, @"Minimum value of an empty array");

  Date* now = [Date distantFuture];
  Date* then = Date.new;
  equal(_.chain(AO(now, then)).min(/* REQUIRED */ nil).Date, then, @"the time is now");

  equal(1, _.chain(nil).range(1,300000, /* REQUIRED */ 1).min(/* REQUIRED */ nil).I, @"Minimum value of a too-big array");
}

- (void)test_sortBy
{
  A* people = AO(OKV({@"name", @"curly"}, {@"age", N.I(50)}), OKV({@"name", @"moe"}, {@"age", N.I(30)}));
  people = _.chain(people).sortBy(^(O* person){ return person.get(@"age"); }).A;
  equal(_.chain(people).pluck(@"name").NSA.join(@", "), @"moe, curly", @"stooges sorted by age");

/* NOT SUPPORTED: JavaScript-only because of undefined */
//  A* list = [undefined, 4, 1, undefined, 3, 2];
//  equal(_.sortBy(list, _.identity).join(@","), @"1,2,3,4,,", @"sortBy with undefined values");

  A* list = AO(@"one", @"two", @"three", @"four", @"five");
  NSA* sorted = _.chain(list).sortBy(@"length").NSA;
  equal(sorted.join(@" "), @"one two four five three", @"sorted by length");
}

- (void)test_groupBy
{
  O* parity = _.chain(AI(1, 2, 3, 4, 5, 6)).groupBy(^(N* num, ... /* KEY, LIST */){ return N.I(num.I % 2); }).O;
  
  ok(N.I(0).in(parity) && N.I(1).in(parity), @"created a group for each value");
  equal(parity.get(N.I(0)).join(@", "), @"2, 4, 6", @"put each even number in the right group");

  A* list = AO(@"one", @"two", @"three", @"four", @"five", @"six", @"seven", @"eight", @"nine", @"ten");
  O* grouped = _.chain(list).groupBy(@"length").O;
  equal(grouped.get(N.I(3)).join(@" "), @"one two six ten", @"");
  equal(grouped.get(N.I(4)).join(@" "), @"four five nine", @"");
  equal(grouped.get(N.I(5)).join(@" "), @"three seven eight", @"");
}

- (void)test_sortedIndex
{
  A* numbers = AI(10, 20, 30, 40, 50); N* num = N.I(35);
  UI indexForNum = _.chain(numbers).sortedIndex(num, /* REQUIRED */ nil).UI;
  equal(indexForNum, 3, @"35 should be inserted at index 3");

  UI indexFor30 = _.chain(numbers).sortedIndex(N.I(30), /* REQUIRED */ nil).UI;
  equal(indexFor30, 2, @"30 should be inserted at index 2");
}

- (void)test_shuffle
{
  A* numbers = _.chain(nil).rangeSimple(10).A; /* SPECIALIZED */
  NSA* shuffled = _.chain(numbers).shuffle().sort(/* REQUIRED */ nil).NSA;
  notStrictEqual(numbers, shuffled, @"original object is unmodified");
  equal(shuffled.join(@","), numbers.join(@","), @"contains the same members before and after shuffle");
}

- (void)test_toArray
{
  (^(id arg1, ...) {
    ARGS_AO(arguments, arg1);
    equal(arguments.length, 2, @"argument passed");

//    ok(!_.isArray(arguments), @"arguments object is not an array"); /* NOT SUPPORTED: JavaScript-only because of arguments object */
    ok(_.isArray(_.chain(arguments).toArray().A), @"arguments object converted into array");
  })(N.I(0), S.new, nil);

  NSA* a = AI(1,2,3);
  ok(_.toArray(a) != a, @"array is cloned");
  equal(_.chain(a).toArray().A.join(@", "), @"1, 2, 3", @"cloned array contains same elements");

  NSA* numbers = _.chain(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)})).toArray().A;
  equal(numbers.join(@", "), @"1, 2, 3", @"object flattened into array");

  O* objectWithToArrayFunction = OKV({@"toArray", ^{
    return AI(1, 2, 3);
  }});
  equal(_.chain(objectWithToArrayFunction).toArray().A.join(@", "), @"1, 2, 3", @"toArray method used if present");

  O* objectWithToArrayValue = OKV({@"toArray", N.I(1)});
  equal(_.chain(objectWithToArrayValue).toArray().A.join(@", "), @"1", @"toArray property ignored if not a function");
}

- (void)test_size
{
  equal(_.chain(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)})).size().I, 3, @"can compute the size of an object");
  equal(_.chain(AI(1, 2, 3)).size().I, 3, @"can compute the size of an array");
}

@end
