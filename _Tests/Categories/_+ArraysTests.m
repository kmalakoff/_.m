//
//  _+ArraysTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_+ArraysTests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation __ArraysTests

- (void)test_first
{
  self.equal(_.first(IA(1, 2, 3), nil), N.i(1), @"can pull out the first element of an array");
  // TODO: chaining - can I overload a define?
//  self.equal(_([1, 2, 3]).first(), 1, @"can perform OO-style "first()"");
  self.equal(((A*)_.first(IA(1,2,3), N.i(0))).join(@", "), @"", @"can pass an index to first");
  self.equal(((A*)_.first(IA(1,2,3), N.i(2))).join(@", "), @"1, 2", @"can pass an index to first");
  self.equal(((A*)_.first(IA(1,2,3), N.i(5))).join(@", "), @"1, 2, 3", @"can pass an index to first");
//  NSInteger iResult = (^(){ return _.first(arguments); })(4, 3, 2, 1);
//  self.equal(iResult, 4, @"works on an arguments object.");
//  A* result = _.map(IA(1,2,3),IA(1,2,3)), _.first);
//  self.equal(result.join(@","), @"1,1", @"works well with _.map");
  A* result = (^() { return _.take(IA(1,2,3), N.i(2)); })();
  self.equal(result.join(@","), @"1,2", @"aliased as take");
  result = (^() { return _.head(IA(1,2,3), N.i(2)); })();
  self.equal(result.join(@","), @"1,2", @"aliased as head");
}

- (void)test_rest
{
  A* numbers = IA(1, 2, 3, 4);
  self.equal(_.rest(numbers, nil).join(@", "), @"2, 3, 4", @"working rest()");
  self.equal(_.rest(numbers, N.i(0)).join(@", "), @"1, 2, 3, 4", @"working rest(0)");
  self.equal(_.rest(numbers, N.i(2)).join(@", "), @"3, 4", @"rest can take an index");
//  A* result = (^(){ return _(arguments).tail(); })(1, 2, 3, 4);
//  self.equal(result.join(@", "), @"2, 3, 4", @"aliased as tail and works on arguments object");
//  A* result = _.map(OA(IA(1,2,3),IA(1,2,3)), _.rest); // TODO: guard
//  self.equal(_.flatten(result, nil).join(@","), @"2,3,2,3", @"works well with _.map"); // UPDATE
}

//- (void)test_initial
//{
//  self.equal(_.initial([1,2,3,4,5]).join(@", "), @"1, 2, 3, 4", @"working initial()");
//  self.equal(_.initial([1,2,3,4],2).join(@", "), @"1, 2", @"initial can take an index");
//  A* result = (^(){ return _(arguments).initial(); })(1, 2, 3, 4);
//  self.equal(result.join(@", "), @"1, 2, 3", @"initial works on arguments object");
//  result = _.map([[1,2,3],[1,2,3]], _.initial);
//  self.equal(_.flatten(result).join(@","), @"1,2,1,2", @"initial works with _.map");
//}
//
//- (void)test_last
//{
//  self.equal(_.last([1,2,3]), 3, @"can pull out the last element of an array");
//  self.equal(_.last([1,2,3], 0).join(@", "), @"", @"can pass an index to last");
//  self.equal(_.last([1,2,3], 2).join(@", "), @"2, 3", @"can pass an index to last");
//  self.equal(_.last([1,2,3], 5).join(@", "), @"1, 2, 3", @"can pass an index to last");
//  NSInteger iResult = (^(){ return _(arguments).last(); })(1, 2, 3, 4);
//  self.equal(iResult, 4, @"works on an arguments object");
//  A* result = _.map([[1,2,3],[1,2,3]], _.last);
//  self.equal(result.join(@","), @"3,3", @"works well with _.map");
//}
//
//- (void)test_compact
//{
//  self.equal(_.compact([0, 1, false, 2, false, 3]).length, 3, @"can trim out all falsy values");
//  NSInteger result = (^(){ return _(arguments).compact().length; })(0, 1, false, 2, false, 3);
//  self.equal(result, 3, @"works on an arguments object");
//};
//
//- (void)test_flatten
//{
//  if (window.JSON) {
//    A* list = [1, [2], [3, [[[4]]]]];
//    self.equal(JSON.stringify(_.flatten(list)), @"[1,2,3,4]", @"can flatten nested arrays");
//    self.equal(JSON.stringify(_.flatten(list, true)), @"[1,2,3,[[[4]]]]", @"can shallowly flatten nested arrays");
//    A* result = (^(){ return _.flatten(arguments); })(1, [2], [3, [[[4]]]]);
//    self.equal(JSON.stringify(result), @"[1,2,3,4]", @"works on an arguments object");
//  }
//}
//
//- (void)test_without
//{
//  A* list = [1, 2, 1, 0, 3, 1, 4];
//  self.equal(_.without(list, 0, 1).join(@", "), @"2, 3, 4", @"can remove all instances of an object");
//  A* result = (^(){ return _.without(arguments, 0, 1); })(1, 2, 1, 0, 3, 1, 4);
//  self.equal(result.join(@", "), @"2, 3, 4", @"works on an arguments object");
//
//  list = [{one : 1}, {two : 2}];
//  ok(_.without(list, {one : 1}).length == 2, @"uses real object identity for comparisons.");
//  ok(_.without(list, list[0]).length == 1, @"ditto.");
//}
//
//- (void)test_uniq
//{
//  A* list = [1, 2, 1, 3, 1, 4];
//  self.equal(_.uniq(list).join(@", "), @"1, 2, 3, 4", @"can find the unique values of an unsorted array");
//
//  list = [1, 1, 1, 2, 2, 3];
//  self.equal(_.uniq(list, true).join(@", "), @"1, 2, 3", @"can find the unique values of a sorted array faster");
//
//  list = [{name:"moe"}, {name:"curly"}, {name:"larry"}, {name:"curly"}];
//  var iterator = ^(value) { return value.name; };
//  self.equal(_.map(_.uniq(list, false, iterator), iterator).join(@", "), @"moe, curly, larry", @"can find the unique values of an array using a custom iterator");
//
//  var iterator = ^(value) { return value +1; };
//  list = [1, 2, 2, 3, 4, 4];
//  self.equal(_.uniq(list, true, iterator).join(@", "), @"1, 2, 3, 4", @"iterator works with sorted array");
//
//  A* result = (^(){ return _.uniq(arguments); })(1, 2, 1, 3, 1, 4);
//  self.equal(result.join(@", "), @"1, 2, 3, 4", @"works on an arguments object");
//}
//
//- (void)test_intersection
//{
//  A* stooges = ["moe", @"curly", @"larry"]; A* leaders = ["moe", @"groucho"];
//  self.equal(_.intersection(stooges, leaders).join(@""), @"moe", @"can take the set intersection of two arrays");
//  self.equal(_(stooges).intersection(leaders).join(@""), @"moe", @"can perform an OO-style intersection");
//  var result = (^(){ return _.intersection(arguments, leaders); })(@"moe", @"curly", @"larry");
//  self.equal(result.join(@""), @"moe", @"works on an arguments object");
//}
//
//- (void)test_union
//{
//  A* result = _.union([1, 2, 3], [2, 30, 1], [1, 40]);
//  self.equal(result.join(@" "), @"1 2 3 30 40", @"takes the union of a list of arrays");
//
//  result = _.union([1, 2, 3], [2, 30, 1], [1, 40, [1]]);
//  self.equal(result.join(@" "), @"1 2 3 30 40 1", @"takes the union of a list of nested arrays");
//}
//
//- (void)test_difference
//{
//  A* result = _.difference([1, 2, 3], [2, 30, 40]);
//  self.equal(result.join(@" "), @"1 3", @"takes the difference of two arrays");
//
//  result = _.difference([1, 2, 3, 4], [2, 30, 40], [1, 11, 111]);
//  self.equal(result.join(@" "), @"3 4", @"takes the difference of three arrays");
//}
//
//- (void)test_zip
//{
//  A* names = ["moe", @"larry", @"curly"]; A* ages = [30, 40, 50], leaders = [true];
//  A* stooges = _.zip(names, ages, leaders);
//  self.equal(String(stooges), @"moe,30,true,larry,40,,curly,50,", @"zipped together arrays of different lengths");
//}
//
//- (void)test_zipObject
//{
//  O* result = _.zipObject(["moe", @"larry", @"curly"], [30, 40, 50]);
//  O* shouldBe = {moe: 30, larry: 40, curly: 50};
//  ok(_.isEqual(result, shouldBe), @"two arrays zipped together into an object");
//}
//
//- (void)test_indexOf
//{
//  A* numbers = [1, 2, 3];
//  numbers.indexOf = null;
//  self.equal(_.indexOf(numbers, 2), 1, @"can compute indexOf, even without the native ^");
//  NSInteger result = (^(){ return _.indexOf(arguments, 2); })(1, 2, 3);
//  self.equal(result, 1, @"works on an arguments object");
//  self.equal(_.indexOf(null, 2), -1, @"handles nulls properly");
//
//  A* numbers = [10, 20, 30, 40, 50], num = 35;
//  NSInteger index = _.indexOf(numbers, num, true);
//  self.equal(index, -1, @"35 is not in the list");
//
//  numbers = [10, 20, 30, 40, 50]; num = 40;
//  index = _.indexOf(numbers, num, true);
//  self.equal(index, 3, @"40 is in the list");
//
//  numbers = [1, 40, 40, 40, 40, 40, 40, 40, 50, 60, 70]; num = 40;
//  index = _.indexOf(numbers, num, true);
//  self.equal(index, 1, @"40 is in the list");
//}
//
//- (void)test_lastIndexOf
//{
//  A* numbers = [1, 0, 1, 0, 0, 1, 0, 0, 0];
//  numbers.lastIndexOf = null;
//  self.equal(_.lastIndexOf(numbers, 1), 5, @"can compute lastIndexOf, even without the native ^");
//  self.equal(_.lastIndexOf(numbers, 0), 8, @"lastIndexOf the other element");
//  NSInteger result = (^(){ return _.lastIndexOf(arguments, 1); })(1, 0, 1, 0, 0, 1, 0, 0, 0);
//  self.equal(result, 5, @"works on an arguments object");
//  self.equal(_.indexOf(null, 2), -1, @"handles nulls properly");
//}
//
//- (void)test_range
//{
//  self.equal(_.range(0).join(@""), @"", @"range with 0 as a first argument generates an empty array");
//  self.equal(_.range(4).join(@" "), @"0 1 2 3", @"range with a single positive argument generates an array of elements 0,1,2,...,n-1");
//  self.equal(_.range(5, 8).join(@" "), @"5 6 7", @"range with two arguments a &amp; b, a&lt;b generates an array of elements a,a+1,a+2,...,b-2,b-1");
//  self.equal(_.range(8, 5).join(@""), @"", @"range with two arguments a &amp; b, b&lt;a generates an empty array");
//  self.equal(_.range(3, 10, 3).join(@" "), @"3 6 9", @"range with three arguments a &amp; b &amp; c, c &lt; b-a, a &lt; b generates an array of elements a,a+c,a+2c,...,b - (multiplier of a) &lt; c");
//  self.equal(_.range(3, 10, 15).join(@""), @"3", @"range with three arguments a &amp; b &amp; c, c &gt; b-a, a &lt; b generates an array with a single element, equal to a");
//  self.equal(_.range(12, 7, -2).join(@" "), @"12 10 8", @"range with three arguments a &amp; b &amp; c, a &gt; b, c &lt; 0 generates an array of elements a,a-c,a-2c and ends with the number not less than b");
//  self.equal(_.range(0, -10, -1).join(@" "), @"0 -1 -2 -3 -4 -5 -6 -7 -8 -9", @"final example in the Python docs");
//}

@end
