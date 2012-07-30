//
//  _+ArraysTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_+ArraysTests.h"
#import "QUnit.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation __ArraysTests

- (void)test_first
{
  equal(_.first(AI(1,2,3), /* REQUIRED */ -1), N.I(1), @"can pull out the first element of an array");
  equal(_.first(AI(1,2,3), /* REQUIRED */ AI_END), N.I(1), @"can pull out the first element of an array (AI_END)");
  equal(__(AI(1,2,3)).first(/* REQUIRED */ -1).I, 1, @"can perform OO-style 'first()'");
  equal(_.first(AI(1,2,3), 0).join(@", "), @"", @"can pass an index to first");
  equal(_.first(AI(1,2,3), 2).join(@", "), @"1, 2", @"can pass an index to first");
  equal(_.first(AI(1,2,3), 5).join(@", "), @"1, 2, 3", @"can pass an index to first");
  N* resultNumber = (N*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return _.first(arguments, /* REQUIRED */ -1); })(4, 3, 2, 1, /* AI_END_TERMINATION */ AI_END);
  equal(resultNumber, N.I(4), @"works on an arguments object.");
  NSA* result = _.map(AO(AI(1,2,3),AI(1,2,3)), /* SPECIALIZED */ _.firstIterator);
  equal(result.join(@","), @"1,1", @"works well with _.map");
  result = (NSA*) (^{ return _.take(AI(1,2,3), 2); })();
  equal(result.join(@","), @"1,2", @"aliased as take");
  result = (NSA*) (^{ return _.head(AI(1,2,3), 2); })();
  equal(result.join(@","), @"1,2", @"aliased as head");
}

- (void)test_initial
{
  equal(_.initial(AI(1,2,3,4,5), /* REQUIRED */ -1).join(@", "), @"1, 2, 3, 4", @"working initial()");
  equal(_.initial(AI(1,2,3,4,5), /* REQUIRED */ AI_END).join(@", "), @"1, 2, 3, 4", @"working initial() (AI_END)");
  equal(_.initial(AI(1,2,3,4), 2).join(@", "), @"1, 2", @"initial can take an index");
  NSA* result = (NSA*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return  __(arguments).initial(/* REQUIRED */ -1).NSA; })(1, 2, 3, 4, /* AI_END_TERMINATION */ AI_END);
  equal(result.join(@", "), @"1, 2, 3", @"initial works on arguments object");
  result = _.map(AO(AI(1,2,3),AI(1,2,3)), /* SPECIALIZED */ _.initialIterator);
  equal(_.flatten(result, /* REQUIRED */ true).join(@","), @"1,2,1,2", @"initial works with _.map");
}

- (void)test_last
{
  equal(_.last(AI(1,2,3), /* REQUIRED */ -1), N.I(3), @"can pull out the last element of an array");
  equal(_.last(AI(1,2,3), /* REQUIRED */ AI_END), N.I(3), @"can pull out the last element of an array (AI_END)");
  equal(_.last(AI(1,2,3), 0).join(@", "), @"", @"can pass an index to last");
  equal(_.last(AI(1,2,3), 2).join(@", "), @"2, 3", @"can pass an index to last");
  equal(_.last(AI(1,2,3), 5).join(@", "), @"1, 2, 3", @"can pass an index to last");
  NSA* resultNumber = (NSA*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return   __(arguments).last(/* REQUIRED */ -1).N; })(1, 2, 3, 4, /* AI_END_TERMINATION */ AI_END);
  equal(resultNumber, N.I(4), @"works on an arguments object");
  A* result = _.map(AO(AI(1,2,3),AI(1,2,3)), /* SPECIALIZED */ _.lastIterator);
  equal(result.join(@","), @"3,3", @"works well with _.map");
}

- (void)test_rest
{
  A* numbers = AI(1, 2, 3, 4);
  equal(_.rest(numbers, /* REQUIRED */ -1).join(@", "), @"2, 3, 4", @"working rest()");
  equal(_.rest(numbers, /* REQUIRED */ AI_END).join(@", "), @"2, 3, 4", @"working rest() (AI_END)");
  equal(_.rest(numbers, 0).join(@", "), @"1, 2, 3, 4", @"working rest(0)");
  equal(_.rest(numbers, 2).join(@", "), @"3, 4", @"rest can take an index");
  NSA* result = (NSA*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return  __(arguments).tail(/* REQUIRED */ -1).NSA; })(1, 2, 3, 4, /* AI_END_TERMINATION */ AI_END);
  equal(result.join(@", "), @"2, 3, 4", @"aliased as tail and works on arguments object");
  result = _.map(AO(AI(1,2,3),AI(1,2,3)), /* SPECIALIZED */ _.restIterator);
  equal(_.flatten(result, /* REQUIRED */  true).join(@","), @"2,3,2,3", @"works well with _.map");
}

- (void)test_compact
{
  equal(_.compact(AO(N.I(0), N.I(1), N.B(false), N.I(2), N.B(false), N.I(3))).length, 3, @"can trim out all falsy values");
  I result = (^(id arg1, ... /* NIL_TERMINATION */){ ARGS_AO(arguments, arg1); return __(arguments).compact().length.UI; })(N.I(0), N.I(1), N.B(false), N.I(2), N.B(false), N.I(3), /* NIL_TERMINATION */ nil);
  equal(result, 3, @"works on an arguments object");
};

- (void)test_flatten
{
//  if (window.JSON) {
    A* list = AO(N.I(1), AI(2), AO(N.I(3), AO(AO(AI(4)))));
    equal(SS.stringify(_.flatten(list, /* REQUIRED */ false)), @"[1,2,3,4]", @"can flatten nested arrays");
    equal(SS.stringify(_.flatten(list, /* REQUIRED */ true)), @"[1,2,3,[[[4]]]]", @"can shallowly flatten nested arrays");
    A* result = (A*) (^(id arg1, ...  /* NIL_TERMINATION */){ ARGS_AO(arguments, arg1); return _.flatten(arguments, /* REQUIRED */ false); })(N.I(1), AI(2), AO(N.I(3), AO(AO(AI(4)))), /* NIL_TERMINATION */ nil);
    equal(SS.stringify(result), @"[1,2,3,4]", @"works on an arguments object");
//  }
}

- (void)test_without
{
  A* list = AI(1, 2, 1, 0, 3, 1, 4);
  equal(_.without(list, N.I(0), N.I(1), /* NIL_TERMINATION */ nil).join(@", "), @"2, 3, 4", @"can remove all instances of an object");
  A* result = (A*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return _.without(arguments, N.I(0), N.I(1), /* NIL_TERMINATION */ nil); })(1, 2, 1, 0, 3, 1, 4, /* AI_END_TERMINATION */ AI_END);
  equal(result.join(@", "), @"2, 3, 4", @"works on an arguments object");

  list = AO(OKV({@"one", N.I(1)}), OKV({@"two", N.I(2)}));
  ok(_.without(list, OKV({@"one", N.I(1)}), /* NIL_TERMINATION */ nil).length == 2, @"uses real object identity for comparisons.");
  ok(_.without(list, list.get(0), /* NIL_TERMINATION */ nil).length == 1, @"ditto.");
}

- (void)test_uniq
{
  A* list = AI(1, 2, 1, 3, 1, 4);
  equal(_.uniq(list).join(@", "), @"1, 2, 3, 4", @"can find the unique values of an unsorted array"); 

  list = AI(1, 1, 1, 2, 2, 3);
  equal(_.uniqAdvanced(list, true, /* REQUIRED */ nil).join(@", "), @"1, 2, 3", @"can find the unique values of a sorted array faster"); /* SPECIALIZED */

  list = AO(OKV({@"name", @"moe"}), OKV({@"name", @"curly"}), OKV({@"name", @"larry"}), OKV({@"name", @"curly"}));
  _MapBlock iterator = ^(O* value, ... /* KEY, COLLECTION */) { return value.get(@"name"); };
  equal(_.map(/* SPECIALIZED */ _.uniqAdvanced(list, false, iterator), iterator).join(@", "), @"moe, curly, larry", @"can find the unique values of an array using a custom iterator");

  iterator = ^(N* value, ... /* KEY, COLLECTION */) { return N.I(value.I + 1); };
  list = AI(1, 2, 2, 3, 4, 4);
  equal(_.uniqAdvanced(list, true, iterator).join(@", "), @"1, 2, 3, 4", @"iterator works with sorted array");

  A* result = (A*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return _.uniq(arguments); })(1, 2, 1, 3, 1, 4, /* AI_END_TERMINATION */ AI_END);
  equal(result.join(@", "), @"1, 2, 3, 4", @"works on an arguments object");
}

- (void)test_intersection
{
  A* stooges = AO(@"moe", @"curly", @"larry"); A* leaders = AO(@"moe", @"groucho");
  equal(_.intersection(stooges, leaders, /* NIL_TERMINATION */ nil).join(@""), @"moe", @"can take the set intersection of two arrays");
  equal(__(stooges).intersection(leaders, /* NIL_TERMINATION */ nil).NSA.join(@""), @"moe", @"can perform an OO-style intersection");
  A* result = (A*) (^(id arg1, ... /* NIL_TERMINATION */){ ARGS_AO(arguments, arg1); return _.intersection(arguments, leaders, /* NIL_TERMINATION */ nil); })(@"moe", @"curly", @"larry", /* NIL_TERMINATION */ nil);
  equal(result.join(@""), @"moe", @"works on an arguments object");
}

- (void)test_union
{
  NSA* result = /* RESERVED KEYWORD */ _.union_(AI(1, 2, 3), AI(2, 30, 1), AI(1, 40), /* NIL_TERMINATION */ nil);
  equal(result.join(@" "), @"1 2 3 30 40", @"takes the union of a list of arrays");

  result = /* RESERVED KEYWORD */  _.union_(AI(1, 2, 3), AI(2, 30, 1), AO(N.I(1), N.I(40), AI(1)), /* NIL_TERMINATION */ nil);
  equal(result.join(@" "), @"1 2 3 30 40 1", @"takes the union of a list of nested arrays");
}

- (void)test_difference
{
  NSA* result = _.difference(AI(1, 2, 3), AI(2, 30, 40), /* NIL_TERMINATION */ nil);
  equal(result.join(@" "), @"1 3", @"takes the difference of two arrays");

  result = _.difference(AI(1, 2, 3, 4), AI(2, 30, 40), AI(1, 11, 111), /* NIL_TERMINATION */ nil);
  equal(result.join(@" "), @"3 4", @"takes the difference of three arrays");
}

- (void)test_zip
{
  A* names = AO(@"moe", @"larry", @"curly"); A* ages = AI(30, 40, 50); A* leaders = AB(true);
  NSA* stooges = _.zip(names, ages, leaders, /* NIL_TERMINATION */ nil);
  equal(S.newA(stooges), @"moe,30,true,larry,40,,curly,50,", @"zipped together arrays of different lengths");
}

- (void)test_zipObject
{
  O* result = _.zipObject(AO(@"moe", @"larry", @"curly"), AI(30, 40, 50));
  O* shouldBe = OKV({@"moe", N.I(30)}, {@"larry", N.I(40)}, {@"curly", N.I(50)});
  ok(_.isEqual(result, shouldBe), @"two arrays zipped together into an object");
}

- (void)test_indexOf
{
  A* numbers = AI(1, 2, 3);
//  numbers.indexOf = null; /* NOT SUPPORTED: JavaScript-only because of native function */
  equal(_.indexOf(numbers, N.I(2)), 1, @"can compute indexOf, even without the native function");
  I result = (^(I arg1, ...  /* NIL_TERMINATION */){ ARGS_AI(arguments, arg1); return _.indexOf(arguments, N.I(2)); })(1, 2, 3, /* AI_END_TERMINATION */ AI_END);
  equal(result, 1, @"works on an arguments object");
  equal(_.indexOf(nil, N.I(2)), -1, @"handles nulls properly");

  numbers = AI(10, 20, 30, 40, 50); N* num = N.I(35);
  I index = /* SPECIALIZED */ _.indexOfSorted(numbers, num);
  equal(index, -1, @"35 is not in the list");

  numbers = AI(10, 20, 30, 40, 50); num = N.I(40);
  index = /* SPECIALIZED */ _.indexOfSorted(numbers, num);
  equal(index, 3, @"40 is in the list");

  numbers = AI(1, 40, 40, 40, 40, 40, 40, 40, 50, 60, 70); num = N.I(40);
  index = /* SPECIALIZED */ _.indexOfSorted(numbers, num);
  equal(index, 1, @"40 is in the list");
}

- (void)test_lastIndexOf
{
  A* numbers = AI(1, 0, 1, 0, 0, 1, 0, 0, 0);
//  numbers.lastIndexOf = null; /* NOT SUPPORTED: JavaScript-only because of native function */
  equal(_.lastIndexOf(numbers, N.I(1)), 5, @"can compute lastIndexOf, even without the native function");
  equal(_.lastIndexOf(numbers, N.I(0)), 8, @"lastIndexOf the other element");
  I result = (^(I arg1, ...  /* NIL_TERMINATION */){ ARGS_AI(arguments, arg1); return _.lastIndexOf(arguments, N.I(1)); })(1, 0, 1, 0, 0, 1, 0, 0, 0, /* AI_END_TERMINATION */ AI_END);
  equal(result, 5, @"works on an arguments object");
  equal(_.indexOf(nil, N.I(2)), -1, @"handles nulls properly");
}

- (void)test_range
{
  equal(/* SPECIALIZED */ _.rangeAuto(0).join(@""), @"", @"range with 0 as a first argument generates an empty array");
  equal(/* SPECIALIZED */ _.rangeAuto(4).join(@" "), @"0 1 2 3", @"range with a single positive argument generates an array of elements 0,1,2,...,n-1");
  equal(_.range(5, 8, /* REQUIRED */ 1).join(@" "), @"5 6 7", @"range with two arguments a &amp; b, a&lt;b generates an array of elements a,a+1,a+2,...,b-2,b-1");
  equal(_.range(8, 5, /* REQUIRED */ 1).join(@""), @"", @"range with two arguments a &amp; b, b&lt;a generates an empty array");
  equal(_.range(3, 10, 3).join(@" "), @"3 6 9", @"range with three arguments a &amp; b &amp; c, c &lt; b-a, a &lt; b generates an array of elements a,a+c,a+2c,...,b - (multiplier of a) &lt; c");
  equal(_.range(3, 10, 15).join(@""), @"3", @"range with three arguments a &amp; b &amp; c, c &gt; b-a, a &lt; b generates an array with a single element, equal to a");
  equal(_.range(12, 7, -2).join(@" "), @"12 10 8", @"range with three arguments a &amp; b &amp; c, a &gt; b, c &lt; 0 generates an array of elements a,a-c,a-2c and ends with the number not less than b");
  equal(_.range(0, -10, -1).join(@" "), @"0 -1 -2 -3 -4 -5 -6 -7 -8 -9", @"final example in the Python docs");
}

@end
