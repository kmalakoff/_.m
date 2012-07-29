//
//  _Wrapper+CollectionsTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Wrapper+CollectionsTests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation _Wrapper_CollectionsTests

- (void)test_each
{
  _.chain(AI(1, 2, 3)).each(^(N* num, ... /* KEY, COLLECTION */) {
    ARGS_INDEX(num);
    self.equalI(num.I, index + 1, @"each iterators provide value and iteration count");
  });

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  __block A* answers = A.new;
//  _.each(AI(1, 2, 3), ^(N* num, ..., O* this){ answers.push(N.I(num.I * ((N*)this.get(@"multiplier")).I));}, OKV({@"multiplier", N.I(5)}));
//  self.equal(answers.join(@", "), @"5, 10, 15", @"context object property accessed");

  __block A* answers = A.new;
  _.chain(AI(1, 2, 3)).forEach(^(N* num, ... /* KEY, COLLECTION */){ answers.push(num); });
  self.equal(answers.join(@", "), @"1, 2, 3", @"aliased as 'forEach'");

  /* NOT SUPPORTED: JavaScript-only because of prototype */
  answers =  A.new;
  O* obj = OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)});
//  obj.constructor.prototype.four = 4; 
  _.chain(obj).each(^(id value, ... /* KEY, COLLECTION */){ ARGS_KEY(value); answers.push(key); });
  self.equal(answers.join(@", "), @"one, two, three", @"iterating over objects works, and ignores the object prototype.");
//  delete obj.constructor.prototype.four;

  __block B answer = false;
  _.chain(AI(1, 2, 3)).each(^(N* num, ... /* KEY, COLLECTION */){ ARGS_COLLECTION(num, arr); if (_.chain(arr).include(num).B) answer = true; });
  self.ok(answer, @"can reference the original collection from inside the iterator");

  __block I iAnswers = 0;
  _.chain(nil).each(^(id v, ... /* KEY, COLLECTION */){ ++iAnswers; });
  self.equalI(iAnswers, 0, @"handles a nil properly");
}

- (void)test_map
{
  A* doubled = _.chain(AI(1, 2, 3)).map(^(N* num, ... /* KEY, COLLECTION */){ return N.I(num.I * 2); }).A;
  self.equal(doubled.join(@", "), @"2, 4, 6", @"doubled numbers");

  doubled = _.chain(AI(1, 2, 3)).collect(^(N* num, ... /* KEY, COLLECTION */){ return N.I(num.I * 2); }).A;
  self.equal(doubled.join(@", "), @"2, 4, 6", @"aliased as 'collect'");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  __block A* tripled = _.mapWithContext(AI(1, 2, 3), ^(N* num, ..., O* this){ return N.I(num.I * ((N*)this.get(@"multiplier")).I); }, OKV({@"multiplier", N.I(3)})); // CHANGE
//  self.equal(tripled.join(@", "), @"3, 6, 9", @"tripled numbers with context");

  doubled =  _.chain(AI(1, 2, 3)).map(^(N* num, ... /* KEY, COLLECTION */){ return N.I(num.I * 2); }).A;
  self.equal(doubled.join(@", "), @"2, 4, 6", @"OO-style doubled numbers");

  /* NOT SUPPORTED: JavaScript-only because of DOM */
//  NSA* ids = _.map($(@"#map-test").children(), ^(n){ return n.id; });
//  deepEqual(ids, AI(@"id1", @"id2"), @"Can use collection methods on NodeLists.");

  /* NOT SUPPORTED: JavaScript-only because of DOM */
//  NSA* ids = _.map(document.images, ^(n){ return n.id; });
//  self.ok(idsAI(0) == "chart_image", @"can use collection methods on HTMLCollections");

  A* ifnil = _.chain(nil).map(^id(id v, ... /* KEY, COLLECTION */){ return nil; }).A;
  self.ok(_.chain(ifnil).isArray().B && ifnil.length == 0, @"handles a nil properly");
}

- (void)test_reduce
{
  I sum = _.chain(AI(1, 2, 3)).reduce(^(N* sum, N* num, ... /* KEY, COLLECTION */){ return N.I(sum.I + num.I); }, 0).I;
  self.equalI(sum, 6, @"can sum up an array");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  NSD* context = {multiplier : 3};
//  N* sum = _.reduce(AI(1, 2, 3), ^(sum, num){ return sum + num * this.multiplier; }, 0, context);
//  self.equal(sum, 18, @"can reduce with a context object");

  sum = _.chain(AI(1, 2, 3)).inject(^(N* sum, N* num, ... /* KEY, COLLECTION */){ return N.I(sum.I + num.I); }, 0).I;
  self.equalI(sum, 6, @"aliased as 'inject'");

  sum =  _.chain(AI(1, 2, 3)).reduce(^(N* sum, N* num, ... /* KEY, COLLECTION */){ return N.I(sum.I + num.I); }, 0).I;
  self.equalI(sum, 6, @"OO-style reduce");

  sum = _.chain(AI(1, 2, 3)).reduce(^(N* sum, N* num, ... /* KEY, COLLECTION */){ return N.I(sum.I + num.I); }, /* REQUIRED */ 0).I;
  self.equalI(sum, 6, @"default initial value");

  E* ifnull;
  @try {
    _.chain(nil).reduce(^(/* REQUIRED */ N* memo, N* num, ... /* KEY, COLLECTION */){ return memo; }, 0);
  } @catch (E* ex) {
    ifnull = ex;
  }
  self.ok(ifnull.instanceof(@"NSException"), @"handles a null (without inital value) properly");

  self.equalI(_.chain(nil).reduce(^(/* REQUIRED */ N* sum, N* num, ... /* KEY, COLLECTION */){ return NSNull.null; }, N.I(138)).I, 138, @"handles a null (with initial value) properly");

  /* NOT SUPPORTED: JavaScript-only because of 'undefined' */
//  self.equal(_.reduce(A.new, ^{}, undefined), undefined, @"undefined can be passed as a special case");
  self.raises(^{ _.chain(A.new).reduce(^(/* REQUIRED */ N* memo, N* num, ... /* KEY, COLLECTION */){ return memo; }, /* REQUIRED */ 0); }, @"TypeError", @"throws an error for empty arrays with no initial value");
}

- (void)test_reduceRight
{
  S* list = _.chain(AO(@"foo", @"bar", @"baz")).reduceRight(^(S* memo, S* str, ... /* KEY, COLLECTION */){ return memo.append(str); }, S.new).S;
  self.equal(list, @"bazbarfoo", @"can perform right folds");

  list = _.chain(AO(@"foo", @"bar", @"baz")).foldr(^(S* memo, S* str, ... /* KEY, COLLECTION */){ return memo.append(str); }, S.new).S;
  self.equal(list, @"bazbarfoo", @"aliased as 'foldr'");

  list = _.chain(AO(@"foo", @"bar", @"baz")).foldr(^(S* memo, S* str, ... /* KEY, COLLECTION */){ return memo.append(str); }, /* REQUIRED */ nil).S;
  self.equal(list, @"bazbarfoo", @"default initial value");

  E* ifnull;
  @try {
    _.chain(nil).reduceRight(^(/* REQUIRED */ N* memo, N* num, ... /* KEY, COLLECTION */){ return memo; }, 0);
  } @catch (E* ex) {
    ifnull = ex;
  }
  self.ok(ifnull.instanceof(@"NSException"), @"handles a null (without inital value) properly");

  self.equalI(_.chain(nil).reduceRight(^(/* REQUIRED */ N* sum, N* num, ... /* KEY, COLLECTION */){ return NSNull.null; }, N.I(138)).I, 138, @"handles a null (with initial value) properly");

  /* NOT SUPPORTED: JavaScript-only because of 'undefined' */
//  self.equal(_.reduceRight(A.new, ^{}, undefined), undefined, @"undefined can be passed as a special case");
  self.raises(^{ _.chain(A.new).reduceRight(^(/* REQUIRED */ N* memo, N* num, ... /* KEY, COLLECTION */){ return memo; }, /* REQUIRED */ 0); }, @"TypeError", @"throws an error for empty arrays with no initial value");
}

- (void)test_find
{
  A* array = AI(1, 2, 3, 4);
  self.strictEqual(_.chain(array).find(^B(N* n) { return n.I > 2; }).N, N.I(3), @"should return first found `value`");
  self.strictEqual(_.chain(array).find(^B(/* REQUIRED */ id value) { return false; }).value(), nil, @"should return `undefined` if `value` is not found");
}

- (void)test_detect
{
  I result = _.chain(AI(1, 2, 3)).detect(^B(N* num){ return num.I * 2 == 4; }).I;
  self.equalI(result, 2, @"found the first '2' and broke the loop");
}

- (void)test_filter
{
  A* evens = _.chain(AI(1, 2, 3, 4, 5, 6)).select(^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }).A;
  self.equal(evens.join(@", "), @"2, 4, 6", @"selected each even number");

  evens = _.chain(AI(1, 2, 3, 4, 5, 6)).filter(^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }).A;
  self.equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");

  /* NOT SUPPORTED: JavaScript-only because of 'this' context */
//  evens = _.filterWithContext(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ..., O* this){ return num.I % ((N*)this.get(@"factor")).I == 0; }, OKV({@"factor", N.I(2)})); // ADDED
//  self.equal(evens.join(@", "), @"2, 4, 6", @"aliased as 'filter'");
}

- (void)test_reject
{
  A* odds = _.chain(AI(1, 2, 3, 4, 5, 6)).reject(^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }).A;
  self.equal(odds.join(@", "), @"1, 3, 5", @"rejected each even number");
}

- (void)test_all
{
  self.ok(_.chain(A.new).all(/* SPECIALIZED */ _.identityTruthy).B, @"the empty set");
  self.ok(_.chain(AB(true, true, true)).all(/* SPECIALIZED */ _.identityTruthy).B, @"all true values");
  self.ok(!_.chain(AB(true, false, true)).all(/* SPECIALIZED */ _.identityTruthy).B, @"one false value");
  self.ok(_.chain(AI(0, 10, 28)).all(^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }).B, @"even numbers");
  self.ok(!_.chain(AI(0, 11, 28)).all(^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }).B, @"an odd number");
  self.ok(_.chain(AI(1)).all(/* SPECIALIZED */ _.identityTruthy).B == true, @"cast to boolean - true");
  self.ok(_.chain(AI(0)).all(/* SPECIALIZED */ _.identityTruthy).B == false, @"cast to boolean - false");
  self.ok(_.chain(AB(true, true, true)).every(/* SPECIALIZED */ _.identityTruthy).B, @"aliased as 'every'");
}

- (void)test_any
{
  self.ok(!_.chain(A.new).any(/* REQUIRED */ nil).B, @"the empty set");
  self.ok(!_.chain(AB(false, false, false)).any(/* REQUIRED */ nil).B, @"all false values");
  self.ok(_.chain(AB(false, false, true)).any(/* REQUIRED */ nil).B, @"one true value");
  self.ok(_.chain(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"yes", N.B(false))).any(/* REQUIRED */ nil).B, @"a string");
  self.ok(!_.chain(AO(/* NIL IS TERMINATOR */ NSNull.null, N.I(0), @"", N.B(false))).any(/* REQUIRED */ nil).B, @"falsy values");
  self.ok(!_.chain(AI(1, 11, 29)).any(^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }).B, @"all odd numbers");
  self.ok(_.chain(AI(1, 10, 29)).any(^B(N* num, ... /* KEY, COLLECTION */){ return num.I % 2 == 0; }).B, @"an even number");
  self.ok(_.chain(AI(1)).any(/* SPECIALIZED */ _.identityTruthy).B == true, @"cast to boolean - true");
  self.ok(_.chain(AI(0)).any(/* SPECIALIZED */ _.identityTruthy).B == false, @"cast to boolean - false");
  self.ok(_.chain(AB(false, false, true)).some(/* REQUIRED */ nil).B, @"aliased as 'some'");
}

- (void)test_include
{
  self.ok(_.chain(AI(1,2,3)).include(N.I(2)).B, @"two is in the array");
  self.ok(!_.chain(AI(1,3,9)).include(N.I(2)).B, @"two is not in the array");
  self.ok(_.chain(OKV({@"moe",N.I(1)}, {@"larry",N.I(3)}, {@"curly", N.I(9)})).contains(N.I(3)).B == true, @"_.include on objects checks their values");
  self.ok(_.chain(AI(1,2,3)).include(N.I(2)).B, @"OO-style include");
}

- (void)test_invoke
{
  NSA* list = AO(AI(5, 1, 7), AI(3, 2, 1));
  NSA* result = (NSA*) _.chain(list).invoke(@"sort", /* REQUIRED */ NSNull.null, /* NIL_TERMINATION */ nil).NSA;
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
  self.equal(_.chain(people).pluck(@"name").NSA.join(@", "), @"moe, curly", @"pulls names out of objects");
}

- (void)test_max
{
  self.equalI(3, _.chain(AI(1, 2, 3)).max(/* REQUIRED */ nil).I, @"can perform a regular Math.max");

  I neg = _.chain(AI(1, 2, 3)).max(^(N* num){ return N.I(-num.I); }).I;
  self.equalI(neg, 1, @"can perform a computation-based max");

  self.equal(NF_NEG_INFINITY, _.chain(O.new).max(/* REQUIRED */ nil).N, @"Maximum value of an empty object");
  self.equal(NF_NEG_INFINITY, _.chain(A.new).max(/* REQUIRED */ nil).N, @"Maximum value of an empty array");

  self.equalI(299999, _.chain(nil).range(1,300000, /* REQUIRED */ 1).max(/* REQUIRED */ nil).I, @"Maximum value of a too-big array");
}

- (void)test_min
{
  self.equalI(1, _.chain(AI(1, 2, 3)).min(/* REQUIRED */ nil).I, @"can perform a regular Math.min");

  I neg = _.chain(AI(1, 2, 3)).min(^(N* num){ return N.I(-num.I); }).I;
  self.equalI(neg, 3, @"can perform a computation-based min");

  self.equal(NF_POS_INFINITY, _.chain(O.new).min(/* REQUIRED */ nil).N, @"Minimum value of an empty object");
  self.equal(NF_POS_INFINITY, _.chain(A.new).min(/* REQUIRED */ nil).N, @"Minimum value of an empty array");

  Date* now = [Date distantFuture];
  Date* then = Date.new;
  self.equal(_.chain(AO(now, then)).min(/* REQUIRED */ nil).Date, then, @"the time is now");

  self.equalI(1, _.chain(nil).range(1,300000, /* REQUIRED */ 1).min(/* REQUIRED */ nil).I, @"Minimum value of a too-big array");
}

- (void)test_sortBy
{
  A* people = AO(OKV({@"name", @"curly"}, {@"age", N.I(50)}), OKV({@"name", @"moe"}, {@"age", N.I(30)}));
  people = _.chain(people).sortBy(^(O* person){ return person.get(@"age"); }).A;
  self.equal(_.chain(people).pluck(@"name").NSA.join(@", "), @"moe, curly", @"stooges sorted by age");

/* NOT SUPPORTED: JavaScript-only because of undefined */
//  A* list = [undefined, 4, 1, undefined, 3, 2];
//  self.equal(_.sortBy(list, _.identity).join(@","), @"1,2,3,4,,", @"sortBy with undefined values");

  A* list = AO(@"one", @"two", @"three", @"four", @"five");
  NSA* sorted = _.chain(list).sortBy(@"length").NSA;
  self.equal(sorted.join(@" "), @"one two four five three", @"sorted by length");
}

- (void)test_groupBy
{
  O* parity = _.chain(AI(1, 2, 3, 4, 5, 6)).groupBy(^(N* num, ... /* KEY, COLLECTION */){ return N.I(num.I % 2); }).O;
  
  self.ok(N.I(0).in(parity) && N.I(1).in(parity), @"created a group for each value");
  self.equal(parity.get(N.I(0)).join(@", "), @"2, 4, 6", @"put each even number in the right group");

  A* list = AO(@"one", @"two", @"three", @"four", @"five", @"six", @"seven", @"eight", @"nine", @"ten");
  O* grouped = _.chain(list).groupBy(@"length").O;
  self.equal(grouped.get(N.I(3)).join(@" "), @"one two six ten", @"");
  self.equal(grouped.get(N.I(4)).join(@" "), @"four five nine", @"");
  self.equal(grouped.get(N.I(5)).join(@" "), @"three seven eight", @"");
}

- (void)test_sortedIndex
{
  A* numbers = AI(10, 20, 30, 40, 50); N* num = N.I(35);
  I indexForNum = _.chain(numbers).sortedIndex(num, /* REQUIRED */ nil).I;
  self.equalI(indexForNum, 3, @"35 should be inserted at index 3");

  I indexFor30 = _.chain(numbers).sortedIndex(N.I(30), /* REQUIRED */ nil).I;
  self.equalI(indexFor30, 2, @"30 should be inserted at index 2");
}

- (void)test_shuffle
{
  A* numbers = _.chain(nil).rangeAuto(10).A; /* SPECIALIZED */
  NSA* shuffled = _.chain(numbers).shuffle().sort(/* REQUIRED */ nil).NSA;
  self.notStrictEqual(numbers, shuffled, @"original object is unmodified");
  self.equal(shuffled.join(@","), numbers.join(@","), @"contains the same members before and after shuffle");
}

- (void)test_toArray
{
  (^(id arg1, ...) {
    ARGS_AO(arguments, arg1);
    self.equalI(arguments.length, 2, @"argument passed");

//    self.ok(!_.isArray(arguments), @"arguments object is not an array"); /* NOT SUPPORTED: JavaScript-only because of arguments object */
    self.ok(_.isArray(_.chain(arguments).toArray().A), @"arguments object converted into array");
  })(N.I(0), S.new, nil);

  NSA* a = AI(1,2,3);
  self.ok(_.toArray(a) != a, @"array is cloned");
  self.equal(_.chain(a).toArray().A.join(@", "), @"1, 2, 3", @"cloned array contains same elements");

  NSA* numbers = _.chain(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)})).toArray().A;
  self.equal(numbers.join(@", "), @"1, 2, 3", @"object flattened into array");

  O* objectWithToArrayFunction = OKV({@"toArray", ^{
    return AI(1, 2, 3);
  }});
  self.equal(_.chain(objectWithToArrayFunction).toArray().A.join(@", "), @"1, 2, 3", @"toArray method used if present");

  O* objectWithToArrayValue = OKV({@"toArray", N.I(1)});
  self.equal(_.chain(objectWithToArrayValue).toArray().A.join(@", "), @"1", @"toArray property ignored if not a function");
}

- (void)test_size
{
  self.equalI(_.chain(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)})).size().I, 3, @"can compute the size of an object");
  self.equalI(_.chain(AI(1, 2, 3)).size().I, 3, @"can compute the size of an array");
}

@end
