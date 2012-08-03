//
//  _Wrapper+ArraysTests.m
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

#import "_Wrapper+ArraysTests.h"
#import "QUnit.h"
#import "Underscore.h"

@implementation _Wrapper_ArraysTests

- (void)test_first
{
  equal(_.chain(AI(1,2,3)).first(/* REQUIRED */ -1).N, N.I(1), @"can perform OO-style 'first()'");
  equal(_.chain(AI(1,2,3)).first(0).NSA.join(@", "), @"", @"can pass an index to first");
  equal(_.chain(AI(1,2,3)).first(2).NSA.join(@", "), @"1, 2", @"can pass an index to first");
  equal(_.chain(AI(1,2,3)).first(5).NSA.join(@", "), @"1, 2, 3", @"can pass an index to first");
  N* resultNumber = (N*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).first(/* REQUIRED */ -1).N; })(4, 3, 2, 1, /* AI_END_TERMINATION */ AI_END);
  equal(resultNumber, N.I(4), @"works on an arguments object.");
  NSA* result = _.chain(AO(AI(1,2,3),AI(1,2,3))).map(/* SPECIALIZED */ _.firstIterator).NSA;
  equal(result.join(@","), @"1,1", @"works well with _.map");
  result = (A*) (^{ return _.chain(AI(1,2,3)).take(2).NSA; })();
  equal(result.join(@","), @"1,2", @"aliased as take");
  result = (A*) (^{ return _.chain(AI(1,2,3)).head(2).NSA; })();
  equal(result.join(@","), @"1,2", @"aliased as head");
}

- (void)test_initial
{
  equal(_.chain(AI(1,2,3,4,5)).initial(/* REQUIRED */ -1).NSA.join(@", "), @"1, 2, 3, 4", @"working initial()");
  equal(_.chain(AI(1,2,3,4)).initial(2).NSA.join(@", "), @"1, 2", @"initial can take an index");
  NSA* result = (NSA*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return  _.chain(arguments).initial(/* REQUIRED */ -1).NSA; })(1, 2, 3, 4, /* AI_END_TERMINATION */ AI_END);
  equal(result.join(@", "), @"1, 2, 3", @"initial works on arguments object");
  result = _.chain(AO(AI(1,2,3),AI(1,2,3))).map(/* SPECIALIZED */ _.initialIterator).NSA;
  equal(_.chain(result).flatten(/* REQUIRED */ true).NSA.join(@","), @"1,2,1,2", @"initial works with _.map");
}

- (void)test_last
{
  equal(_.chain(AI(1,2,3)).last(/* REQUIRED */ -1).N, N.I(3), @"can pull out the last element of an array");
  equal(_.chain(AI(1,2,3)).last(0).NSA.join(@", "), @"", @"can pass an index to last");
  equal(_.chain(AI(1,2,3)).last(2).NSA.join(@", "), @"2, 3", @"can pass an index to last");
  equal(_.chain(AI(1,2,3)).last(5).NSA.join(@", "), @"1, 2, 3", @"can pass an index to last");
  N* resultNumber = (N*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return   _.chain(arguments).last(/* REQUIRED */ -1).N; })(1, 2, 3, 4, /* AI_END_TERMINATION */ AI_END);
  equal(resultNumber, N.I(4), @"works on an arguments object");
  NSA* result = _.chain(AO(AI(1,2,3),AI(1,2,3))).map(/* SPECIALIZED */ _.lastIterator).NSA;
  equal(result.join(@","), @"3,3", @"works well with _.map");
}

- (void)test_rest
{
  A* numbers = AI(1, 2, 3, 4);
  equal(_.chain(numbers).rest(/* REQUIRED */ -1).NSA.join(@", "), @"2, 3, 4", @"working rest()");
  equal(_.chain(numbers).rest(0).NSA.join(@", "), @"1, 2, 3, 4", @"working rest(0)");
  equal(_.chain(numbers).rest(2).NSA.join(@", "), @"3, 4", @"rest can take an index");
  NSA* result = (NSA*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return  _.chain(arguments).tail(/* REQUIRED */ -1).NSA; })(1, 2, 3, 4, /* AI_END_TERMINATION */ AI_END);
  equal(result.join(@", "), @"2, 3, 4", @"aliased as tail and works on arguments object");
  result = _.chain(AO(AI(1,2,3),AI(1,2,3))).map(/* SPECIALIZED */ _.restIterator).NSA;
  equal(_.chain(result).flatten(/* REQUIRED */  true).NSA.join(@","), @"2,3,2,3", @"works well with _.map");
}

- (void)test_compact
{
  equal(_.chain(AO(N.I(0), N.I(1), N.B(false), N.I(2), N.B(false), N.I(3))).compact().length.UI, 3, @"can trim out all falsy values");
  I result = (^(id arg1, ... /* NIL_TERMINATION */){ ARGS_AO(arguments, arg1); return _.chain(arguments).compact().length.UI; })(N.I(0), N.I(1), N.B(false), N.I(2), N.B(false), N.I(3), /* NIL_TERMINATION */ nil);
  equal(result, 3, @"works on an arguments object");
};

- (void)test_flatten
{
//  if (window.JSON) {
    A* list = AO(N.I(1), AI(2), AO(N.I(3), AO(AO(AI(4)))));
    equal(SS.stringify(_.chain(list).flatten(/* REQUIRED */ false).NSA), @"[1,2,3,4]", @"can flatten nested arrays");
    equal(SS.stringify(_.chain(list).flatten(/* REQUIRED */ true).NSA), @"[1,2,3,[[[4]]]]", @"can shallowly flatten nested arrays");
    A* result = (A*) (^(id arg1, ...  /* NIL_TERMINATION */){ ARGS_AO(arguments, arg1); return _.chain(arguments).flatten(/* REQUIRED */ false).A; })(N.I(1), AI(2), AO(N.I(3), AO(AO(AI(4)))), /* NIL_TERMINATION */ nil);
    equal(SS.stringify(result), @"[1,2,3,4]", @"works on an arguments object");
//  }
}

- (void)test_without
{
  A* list = AI(1, 2, 1, 0, 3, 1, 4);
  equal(_.chain(list).without(N.I(0), N.I(1), /* NIL_TERMINATION */ nil).NSA.join(@", "), @"2, 3, 4", @"can remove all instances of an object");
  A* result = (A*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).without(N.I(0), N.I(1), /* NIL_TERMINATION */ nil).A; })(1, 2, 1, 0, 3, 1, 4, /* AI_END_TERMINATION */ AI_END);
  equal(result.join(@", "), @"2, 3, 4", @"works on an arguments object");

  list = AO(OKV({@"one", N.I(1)}), OKV({@"two", N.I(2)}));
  ok(_.chain(list).without(OKV({@"one", N.I(1)}), /* NIL_TERMINATION */ nil).length.UI == 2, @"uses real object identity for comparisons.");
  ok(_.chain(list).without(list.get(0), /* NIL_TERMINATION */ nil).length.UI == 1, @"ditto.");
}

- (void)test_uniq
{
  A* list = AI(1, 2, 1, 3, 1, 4);
  equal(_.chain(list).uniq().NSA.join(@", "), @"1, 2, 3, 4", @"can find the unique values of an unsorted array");

  list = AI(1, 1, 1, 2, 2, 3);
  equal(_.chain(list).uniqAdvanced(true, /* REQUIRED */ nil).NSA.join(@", "), @"1, 2, 3", @"can find the unique values of a sorted array faster"); /* SPECIALIZED */

  list = AO(OKV({@"name", @"moe"}), OKV({@"name", @"curly"}), OKV({@"name", @"larry"}), OKV({@"name", @"curly"}));
  _MapBlock iterator = ^(O* value, ... /* KEY, LIST */) { return value.get(@"name"); };
  equal(_.chain(list)./* SPECIALIZED */ uniqAdvanced(false, iterator).map(iterator).NSA.join(@", "), @"moe, curly, larry", @"can find the unique values of an array using a custom iterator");

  iterator = ^(N* value, ... /* KEY, LIST */) { return N.I(value.I + 1); };
  list = AI(1, 2, 2, 3, 4, 4);
  equal(_.chain(list).uniqAdvanced(true, iterator).NSA.join(@", "), @"1, 2, 3, 4", @"iterator works with sorted array");

  A* result = (A*) (^(I arg1, ... /* AI_END_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).uniq().A; })(1, 2, 1, 3, 1, 4, /* AI_END_TERMINATION */ AI_END);
  equal(result.join(@", "), @"1, 2, 3, 4", @"works on an arguments object");
}

- (void)test_intersection
{
  A* stooges = AO(@"moe", @"curly", @"larry"); A* leaders = AO(@"moe", @"groucho");
  equal(_.chain(stooges).intersection(leaders, /* NIL_TERMINATION */ nil).NSA.join(@""), @"moe", @"can take the set intersection of two arrays");
  equal(_.chain(stooges).intersection(leaders, /* NIL_TERMINATION */ nil).NSA.join(@""), @"moe", @"can perform an OO-style intersection");
  A* result = (A*) (^(id arg1, ... /* NIL_TERMINATION */){ ARGS_AO(arguments, arg1); return _.chain(arguments).intersection(leaders, /* NIL_TERMINATION */ nil).A; })(@"moe", @"curly", @"larry", /* NIL_TERMINATION */ nil);
  equal(result.join(@""), @"moe", @"works on an arguments object");
}

- (void)test_union
{
  NSA* result = /* RESERVED KEYWORD */ _.chain(AI(1, 2, 3)).union_(AI(2, 30, 1), AI(1, 40), /* NIL_TERMINATION */ nil).NSA;
  equal(result.join(@" "), @"1 2 3 30 40", @"takes the union of a list of arrays");

  result = /* RESERVED KEYWORD */  _.chain(AI(1, 2, 3)).union_(AI(2, 30, 1), AO(N.I(1), N.I(40), AI(1)), /* NIL_TERMINATION */ nil).NSA;
  equal(result.join(@" "), @"1 2 3 30 40 1", @"takes the union of a list of nested arrays");
}

- (void)test_difference
{
  NSA* result = _.chain(AI(1, 2, 3)).difference(AI(2, 30, 40), /* NIL_TERMINATION */ nil).NSA;
  equal(result.join(@" "), @"1 3", @"takes the difference of two arrays");

  result = _.chain(AI(1, 2, 3, 4)).difference(AI(2, 30, 40), AI(1, 11, 111), /* NIL_TERMINATION */ nil).NSA;
  equal(result.join(@" "), @"3 4", @"takes the difference of three arrays");
}

- (void)test_zip
{
  A* names = AO(@"moe", @"larry", @"curly"); A* ages = AI(30, 40, 50); A* leaders = AB(true);
  NSA* stooges = _.chain(nil).zip(names, ages, leaders, /* NIL_TERMINATION */ nil).NSA;
  equal(S.newA(stooges), @"moe,30,true,larry,40,,curly,50,", @"zipped together arrays of different lengths");
}

- (void)test_zipObject
{
  O* result = _.chain(nil).zipObject(AO(@"moe", @"larry", @"curly"), AI(30, 40, 50)).O;
  O* shouldBe = OKV({@"moe", N.I(30)}, {@"larry", N.I(40)}, {@"curly", N.I(50)});
  ok(_.chain(result).isEqual(shouldBe).B, @"two arrays zipped together into an object");
}

- (void)test_indexOf
{
  A* numbers = AI(1, 2, 3);
//  numbers.indexOf = null; /* NOT SUPPORTED: JavaScript-only because of native function */
  equal(_.chain(numbers).indexOf(N.I(2)).I, 1, @"can compute indexOf, even without the native function");
  I result = (^(I arg1, ...  /* NIL_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).indexOf(N.I(2)).I; })(1, 2, 3, /* AI_END_TERMINATION */ AI_END);
  equal(result, 1, @"works on an arguments object");
  equal(_.chain(nil).indexOf(N.I(2)).I, -1, @"handles nulls properly");

  numbers = AI(10, 20, 30, 40, 50); N* num = N.I(35);
  I index = /* SPECIALIZED */ _.chain(numbers).indexOfSorted(num).I;
  equal(index, -1, @"35 is not in the list");

  numbers = AI(10, 20, 30, 40, 50); num = N.I(40);
  index = /* SPECIALIZED */ _.chain(numbers).indexOfSorted(num).I;
  equal(index, 3, @"40 is in the list");

  numbers = AI(1, 40, 40, 40, 40, 40, 40, 40, 50, 60, 70); num = N.I(40);
  index = /* SPECIALIZED */ _.chain(numbers).indexOfSorted(num).I;
  equal(index, 1, @"40 is in the list");
}

- (void)test_lastIndexOf
{
  A* numbers = AI(1, 0, 1, 0, 0, 1, 0, 0, 0);
//  numbers.lastIndexOf = null; /* NOT SUPPORTED: JavaScript-only because of native function */
  equal(_.chain(numbers).lastIndexOf(N.I(1)).I, 5, @"can compute lastIndexOf, even without the native function");
  equal(_.chain(numbers).lastIndexOf(N.I(0)).I, 8, @"lastIndexOf the other element");
  I result = (^(I arg1, ...  /* NIL_TERMINATION */){ ARGS_AI(arguments, arg1); return _.chain(arguments).lastIndexOf(N.I(1)).I; })(1, 0, 1, 0, 0, 1, 0, 0, 0, /* AI_END_TERMINATION */ AI_END);
  equal(result, 5, @"works on an arguments object");
  equal(_.chain(nil).indexOf(N.I(2)).I, -1, @"handles nulls properly");
}

- (void)test_range
{
  equal(/* SPECIALIZED */ _.chain(nil).rangeSimple(0).NSA.join(@""), @"", @"range with 0 as a first argument generates an empty array");
  equal(/* SPECIALIZED */ _.chain(nil).rangeSimple(4).NSA.join(@" "), @"0 1 2 3", @"range with a single positive argument generates an array of elements 0,1,2,...,n-1");
  equal(_.chain(nil).range(5, 8, /* REQUIRED */ 1).NSA.join(@" "), @"5 6 7", @"range with two arguments a &amp; b, a&lt;b generates an array of elements a,a+1,a+2,...,b-2,b-1");
  equal(_.chain(nil).range(8, 5, /* REQUIRED */ 1).NSA.join(@""), @"", @"range with two arguments a &amp; b, b&lt;a generates an empty array");
  equal(_.chain(nil).range(3, 10, 3).NSA.join(@" "), @"3 6 9", @"range with three arguments a &amp; b &amp; c, c &lt; b-a, a &lt; b generates an array of elements a,a+c,a+2c,...,b - (multiplier of a) &lt; c");
  equal(_.chain(nil).range(3, 10, 15).NSA.join(@""), @"3", @"range with three arguments a &amp; b &amp; c, c &gt; b-a, a &lt; b generates an array with a single element, equal to a");
  equal(_.chain(nil).range(12, 7, -2).NSA.join(@" "), @"12 10 8", @"range with three arguments a &amp; b &amp; c, a &gt; b, c &lt; 0 generates an array of elements a,a-c,a-2c and ends with the number not less than b");
  equal(_.chain(nil).range(0, -10, -1).NSA.join(@" "), @"0 -1 -2 -3 -4 -5 -6 -7 -8 -9", @"final example in the Python docs");
}

@end
