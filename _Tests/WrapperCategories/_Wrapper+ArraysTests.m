//
//  _Wrapper+ArraysTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Wrapper+ArraysTests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation _Wrapper_ArraysTests

- (void)test_first
{
  self.equal(_.chain(AI(1,2,3)).first(/* REQUIRED */ -1).valueN(), N.I(1), @"can pull out the first element of an array");
  self.equal(_.chain(AI(1,2,3)).first(/* REQUIRED */ AI_END).valueN(), N.I(1), @"can pull out the first element of an array (AI_END)");
  self.equal(_.chain(AI(1,2,3)).first(/* REQUIRED */ -1).valueN(), N.I(1), @"can perform OO-style 'first()'");
  self.equal(_.chain(AI(1,2,3)).first(0).valueNSA().join(@", "), @"", @"can pass an index to first");
  self.equal(_.chain(AI(1,2,3)).first(2).valueNSA().join(@", "), @"1, 2", @"can pass an index to first");
  self.equal(_.chain(AI(1,2,3)).first(5).valueNSA().join(@", "), @"1, 2, 3", @"can pass an index to first");
  N* resultNumber = (N*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).first(/* REQUIRED */ -1).valueN(); })(4, 3, 2, 1, /* AI_END_TERMINATION */ AI_END);
  self.equal(resultNumber, N.I(4), @"works on an arguments object.");
  NSA* result = _.chain(AO(AI(1,2,3),AI(1,2,3))).map(/* SPECIALIZED */ _.firstIterator).valueNSA();
  self.equal(result.join(@","), @"1,1", @"works well with _.map");
  result = (A*) (^{ return _.chain(AI(1,2,3)).take(2).valueNSA(); })();
  self.equal(result.join(@","), @"1,2", @"aliased as take");
  result = (A*) (^{ return _.chain(AI(1,2,3)).head(2).valueNSA(); })();
  self.equal(result.join(@","), @"1,2", @"aliased as head");
}

- (void)test_initial
{
  self.equal(_.chain(AI(1,2,3,4,5)).initial(/* REQUIRED */ -1).valueNSA().join(@", "), @"1, 2, 3, 4", @"working initial()");
  self.equal(_.chain(AI(1,2,3,4,5)).initial(/* REQUIRED */ AI_END).valueNSA().join(@", "), @"1, 2, 3, 4", @"working initial() (AI_END)");
  self.equal(_.chain(AI(1,2,3,4)).initial(2).valueNSA().join(@", "), @"1, 2", @"initial can take an index");
  NSA* result = (NSA*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return  _.chain(arguments).initial(/* REQUIRED */ -1).valueNSA(); })(1, 2, 3, 4, /* AI_END_TERMINATION */ AI_END);
  self.equal(result.join(@", "), @"1, 2, 3", @"initial works on arguments object");
  result = _.chain(AO(AI(1,2,3),AI(1,2,3))).map(/* SPECIALIZED */ _.initialIterator).valueNSA();
  self.equal(_.chain(result).flatten(/* REQUIRED */ YES).valueNSA().join(@","), @"1,2,1,2", @"initial works with _.map");
}

- (void)test_last
{
  self.equal(_.chain(AI(1,2,3)).last(/* REQUIRED */ -1).valueN(), N.I(3), @"can pull out the last element of an array");
  self.equal(_.chain(AI(1,2,3)).last(/* REQUIRED */ AI_END).valueN(), N.I(3), @"can pull out the last element of an array (AI_END)");
  self.equal(_.chain(AI(1,2,3)).last(0).valueNSA().join(@", "), @"", @"can pass an index to last");
  self.equal(_.chain(AI(1,2,3)).last(2).valueNSA().join(@", "), @"2, 3", @"can pass an index to last");
  self.equal(_.chain(AI(1,2,3)).last(5).valueNSA().join(@", "), @"1, 2, 3", @"can pass an index to last");
  N* resultNumber = (N*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return   _.chain(arguments).last(/* REQUIRED */ -1).valueN(); })(1, 2, 3, 4, /* AI_END_TERMINATION */ AI_END);
  self.equal(resultNumber, N.I(4), @"works on an arguments object");
  NSA* result = _.chain(AO(AI(1,2,3),AI(1,2,3))).map(/* SPECIALIZED */ _.lastIterator).valueNSA();
  self.equal(result.join(@","), @"3,3", @"works well with _.map");
}

- (void)test_rest
{
  A* numbers = AI(1, 2, 3, 4);
  self.equal(_.chain(numbers).rest(/* REQUIRED */ -1).valueNSA().join(@", "), @"2, 3, 4", @"working rest()");
  self.equal(_.chain(numbers).rest(/* REQUIRED */ AI_END).valueNSA().join(@", "), @"2, 3, 4", @"working rest() (AI_END)");
  self.equal(_.chain(numbers).rest(0).valueNSA().join(@", "), @"1, 2, 3, 4", @"working rest(0)");
  self.equal(_.chain(numbers).rest(2).valueNSA().join(@", "), @"3, 4", @"rest can take an index");
  NSA* result = (NSA*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return  _.chain(arguments).tail(/* REQUIRED */ -1).valueNSA(); })(1, 2, 3, 4, /* AI_END_TERMINATION */ AI_END);
  self.equal(result.join(@", "), @"2, 3, 4", @"aliased as tail and works on arguments object");
  result = _.chain(AO(AI(1,2,3),AI(1,2,3))).map(/* SPECIALIZED */ _.restIterator).valueNSA();
  self.equal(_.chain(result).flatten(/* REQUIRED */  YES).valueNSA().join(@","), @"2,3,2,3", @"works well with _.map");
}

- (void)test_compact
{
  self.equalI(_.chain(AO(N.I(0), N.I(1), N.B(NO), N.I(2), N.B(NO), N.I(3))).compact().valueNSA().length, 3, @"can trim out all falsy values");
  I result = (^(id arg1, ... /* NIL_TERMINATION */){ ARGS_AO(arguments, arg1); return _.chain(arguments).compact().valueNSA().length; })(N.I(0), N.I(1), N.B(false), N.I(2), N.B(false), N.I(3), /* NIL_TERMINATION */ nil);
  self.equalI(result, 3, @"works on an arguments object");
};

- (void)test_flatten
{
  if (SS.JSON) {
    SSJSON* JSON = SS.JSON;
  
    A* list = AO(N.I(1), AI(2), AO(N.I(3), AO(AO(AI(4)))));
    self.equal(JSON.stringify(_.chain(list).flatten(/* REQUIRED */ NO).valueNSA()), @"[1,2,3,4]", @"can flatten nested arrays");
    self.equal(JSON.stringify(_.chain(list).flatten(/* REQUIRED */ YES).valueNSA()), @"[1,2,3,[[[4]]]]", @"can shallowly flatten nested arrays");
    A* result = (A*) (^(id arg1, ...  /* NIL_TERMINATION */){ ARGS_AO(arguments, arg1); return _.chain(arguments).flatten(/* REQUIRED */ NO).valueA(); })(N.I(1), AI(2), AO(N.I(3), AO(AO(AI(4)))), /* NIL_TERMINATION */ nil);
    self.equal(JSON.stringify(result), @"[1,2,3,4]", @"works on an arguments object");
  }
}

- (void)test_without
{
  A* list = AI(1, 2, 1, 0, 3, 1, 4);
  self.equal(_.chain(list).without(N.I(0), N.I(1), /* NIL_TERMINATION */ nil).valueNSA().join(@", "), @"2, 3, 4", @"can remove all instances of an object");
  A* result = (A*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).without(N.I(0), N.I(1), /* NIL_TERMINATION */ nil).valueA(); })(1, 2, 1, 0, 3, 1, 4, /* AI_END_TERMINATION */ AI_END);
  self.equal(result.join(@", "), @"2, 3, 4", @"works on an arguments object");

  list = AO(OKV({@"one", N.I(1)}), OKV({@"two", N.I(2)}));
  self.ok(_.chain(list).without(OKV({@"one", N.I(1)}, /* NIL_TERMINATION */ nil)).valueNSA().length == 2, @"uses real object identity for comparisons.");
  self.ok(_.chain(list).without(list.get(0), /* NIL_TERMINATION */ nil).valueNSA().length == 1, @"ditto.");
}

- (void)test_uniq
{
  A* list = AI(1, 2, 1, 3, 1, 4);
  self.equal(_.chain(list).uniq().valueNSA().join(@", "), @"1, 2, 3, 4", @"can find the unique values of an unsorted array");

  list = AI(1, 1, 1, 2, 2, 3);
  self.equal(_.chain(list).uniqAdvanced(YES, /* REQUIRED */ nil).valueNSA().join(@", "), @"1, 2, 3", @"can find the unique values of a sorted array faster"); /* SPECIALIZED */

  list = AO(OKV({@"name", @"moe"}), OKV({@"name", @"curly"}), OKV({@"name", @"larry"}), OKV({@"name", @"curly"}));
  _MapBlock iterator = ^(O* value, ... /* KEY, COLLECTION */) { return value.get(@"name"); };
  self.equal(_.chain(list)./* SPECIALIZED */ uniqAdvanced(NO, iterator).map(iterator).valueNSA().join(@", "), @"moe, curly, larry", @"can find the unique values of an array using a custom iterator");

  iterator = ^(N* value, ... /* KEY, COLLECTION */) { return N.I(value.I + 1); };
  list = AI(1, 2, 2, 3, 4, 4);
  self.equal(_.chain(list).uniqAdvanced(YES, iterator).valueNSA().join(@", "), @"1, 2, 3, 4", @"iterator works with sorted array");

  A* result = (A*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).uniq().valueA(); })(1, 2, 1, 3, 1, 4, /* AI_END_TERMINATION */ AI_END);
  self.equal(result.join(@", "), @"1, 2, 3, 4", @"works on an arguments object");
}

- (void)test_intersection
{
  A* stooges = AO(@"moe", @"curly", @"larry"); A* leaders = AO(@"moe", @"groucho");
  self.equal(_.chain(stooges).intersection(leaders, /* NIL_TERMINATION */ nil).valueNSA().join(@""), @"moe", @"can take the set intersection of two arrays");
  self.equal(_.chain(stooges).intersection(leaders, /* NIL_TERMINATION */ nil).valueNSA().join(@""), @"moe", @"can perform an OO-style intersection");
  A* result = (A*) (^(id arg1, ... /* NIL_TERMINATION */){ ARGS_AO(arguments, arg1); return _.chain(arguments).intersection(leaders, /* NIL_TERMINATION */ nil).valueA(); })(@"moe", @"curly", @"larry", /* NIL_TERMINATION */ nil);
  self.equal(result.join(@""), @"moe", @"works on an arguments object");
}

- (void)test_union
{
  NSA* result = /* RESERVED KEYWORD */ _.chain(AI(1, 2, 3)).union_(AI(2, 30, 1), AI(1, 40), /* NIL_TERMINATION */ nil).valueNSA();
  self.equal(result.join(@" "), @"1 2 3 30 40", @"takes the union of a list of arrays");

  result = /* RESERVED KEYWORD */  _.chain(AI(1, 2, 3)).union_(AI(2, 30, 1), AO(N.I(1), N.I(40), AI(1)), /* NIL_TERMINATION */ nil).valueNSA();
  self.equal(result.join(@" "), @"1 2 3 30 40 1", @"takes the union of a list of nested arrays");
}

- (void)test_difference
{
  NSA* result = _.chain(AI(1, 2, 3)).difference(AI(2, 30, 40), /* NIL_TERMINATION */ nil).valueNSA();
  self.equal(result.join(@" "), @"1 3", @"takes the difference of two arrays");

  result = _.chain(AI(1, 2, 3, 4)).difference(AI(2, 30, 40), AI(1, 11, 111), /* NIL_TERMINATION */ nil).valueNSA();
  self.equal(result.join(@" "), @"3 4", @"takes the difference of three arrays");
}

- (void)test_zip
{
  A* names = AO(@"moe", @"larry", @"curly"); A* ages = AI(30, 40, 50); A* leaders = AB(YES);
  NSA* stooges = _.chain(nil).zip(names, ages, leaders, /* NIL_TERMINATION */ nil).valueNSA();
  self.equal(S.newA(stooges), @"moe,30,true,larry,40,,curly,50,", @"zipped together arrays of different lengths");
}

- (void)test_zipObject
{
  O* result = _.chain(nil).zipObject(AO(@"moe", @"larry", @"curly"), AI(30, 40, 50)).valueO();
  O* shouldBe = OKV({@"moe", N.I(30)}, {@"larry", N.I(40)}, {@"curly", N.I(50)});
  self.ok(_.chain(result).isEqual(shouldBe).valueB(), @"two arrays zipped together into an object");
}

- (void)test_indexOf
{
  A* numbers = AI(1, 2, 3);
//  numbers.indexOf = null; /* NOT SUPPORTED: JavaScript-only because of native function */
  self.equalI(_.chain(numbers).indexOf(N.I(2)).valueI(), 1, @"can compute indexOf, even without the native function");
  I result = (^(I arg1, ...  /* NIL_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).indexOf(N.I(2)).valueI(); })(1, 2, 3, /* AI_END_TERMINATION */ AI_END);
  self.equalI(result, 1, @"works on an arguments object");
  self.equalI(_.chain(nil).indexOf(N.I(2)).valueI(), -1, @"handles nulls properly");

  numbers = AI(10, 20, 30, 40, 50); N* num = N.I(35);
  I index = /* SPECIALIZED */ _.chain(numbers).indexOfSorted(num).valueI();
  self.equalI(index, -1, @"35 is not in the list");

  numbers = AI(10, 20, 30, 40, 50); num = N.I(40);
  index = /* SPECIALIZED */ _.chain(numbers).indexOfSorted(num).valueI();
  self.equalI(index, 3, @"40 is in the list");

  numbers = AI(1, 40, 40, 40, 40, 40, 40, 40, 50, 60, 70); num = N.I(40);
  index = /* SPECIALIZED */ _.chain(numbers).indexOfSorted(num).valueI();
  self.equalI(index, 1, @"40 is in the list");
}

- (void)test_lastIndexOf
{
  A* numbers = AI(1, 0, 1, 0, 0, 1, 0, 0, 0);
//  numbers.lastIndexOf = null; /* NOT SUPPORTED: JavaScript-only because of native function */
  self.equalI(_.chain(numbers).lastIndexOf(N.I(1)).valueI(), 5, @"can compute lastIndexOf, even without the native function");
  self.equalI(_.chain(numbers).lastIndexOf(N.I(0)).valueI(), 8, @"lastIndexOf the other element");
  I result = (^(I arg1, ...  /* NIL_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).lastIndexOf(N.I(1)).valueI(); })(1, 0, 1, 0, 0, 1, 0, 0, 0, /* AI_END_TERMINATION */ AI_END);
  self.equalI(result, 5, @"works on an arguments object");
  self.equalI(_.chain(nil).indexOf(N.I(2)).valueI(), -1, @"handles nulls properly");
}

- (void)test_range
{
  self.equal(/* SPECIALIZED */ _.chain(nil).rangeAuto(0).valueNSA().join(@""), @"", @"range with 0 as a first argument generates an empty array");
  self.equal(/* SPECIALIZED */ _.chain(nil).rangeAuto(4).valueNSA().join(@" "), @"0 1 2 3", @"range with a single positive argument generates an array of elements 0,1,2,...,n-1");
  self.equal(_.chain(nil).range(5, 8, /* REQUIRED */ 1).valueNSA().join(@" "), @"5 6 7", @"range with two arguments a &amp; b, a&lt;b generates an array of elements a,a+1,a+2,...,b-2,b-1");
  self.equal(_.chain(nil).range(8, 5, /* REQUIRED */ 1).valueNSA().join(@""), @"", @"range with two arguments a &amp; b, b&lt;a generates an empty array");
  self.equal(_.chain(nil).range(3, 10, 3).valueNSA().join(@" "), @"3 6 9", @"range with three arguments a &amp; b &amp; c, c &lt; b-a, a &lt; b generates an array of elements a,a+c,a+2c,...,b - (multiplier of a) &lt; c");
  self.equal(_.chain(nil).range(3, 10, 15).valueNSA().join(@""), @"3", @"range with three arguments a &amp; b &amp; c, c &gt; b-a, a &lt; b generates an array with a single element, equal to a");
  self.equal(_.chain(nil).range(12, 7, -2).valueNSA().join(@" "), @"12 10 8", @"range with three arguments a &amp; b &amp; c, a &gt; b, c &lt; 0 generates an array of elements a,a-c,a-2c and ends with the number not less than b");
  self.equal(_.chain(nil).range(0, -10, -1).valueNSA().join(@" "), @"0 -1 -2 -3 -4 -5 -6 -7 -8 -9", @"final example in the Python docs");
}

@end
