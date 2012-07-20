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
  self.equal(_.first(AI(1, 2, 3), nil), N.I(1), @"can pull out the first element of an array");
  // TODO: chaining - can I overload a define?
//  self.equal(_(AI(1, 2, 3)).first(), 1, @"can perform OO-style "first()"");
  self.equal(_.first(AI(1,2,3), N.I(0)).join(@", "), @"", @"can pass an index to first");
  self.equal(_.first(AI(1,2,3), N.I(2)).join(@", "), @"1, 2", @"can pass an index to first");
  self.equal(_.first(AI(1,2,3), N.I(5)).join(@", "), @"1, 2, 3", @"can pass an index to first");
//  I iResult = (^(){ return _.first(arguments); })(4, 3, 2, 1);
//  self.equal(iResult, 4, @"works on an arguments object.");
  A* result = _.map(AO(AI(1,2,3),AI(1,2,3)), _.firstIterator); // CHANGED
  self.equal(result.join(@","), @"1,1", @"works well with _.map");
  result = (A*) (^() { return _.take(AI(1,2,3), N.I(2)); })();
  self.equal(result.join(@","), @"1,2", @"aliased as take");
  result = (A*) (^() { return _.head(AI(1,2,3), N.I(2)); })();
  self.equal(result.join(@","), @"1,2", @"aliased as head");
}

- (void)test_initial
{
  self.equal(_.initial(AI(1,2,3,4,5), nil).join(@", "), @"1, 2, 3, 4", @"working initial()");
  self.equal(_.initial(AI(1,2,3,4), N.I(2)).join(@", "), @"1, 2", @"initial can take an index");
//  A* result = (^(){ return _(arguments).initial(); })(1, 2, 3, 4);
//  self.equal(result.join(@", "), @"1, 2, 3", @"initial works on arguments object");
  A* result = _.map(AO(AI(1,2,3),AI(1,2,3)), _.initialIterator); // CHANGED
  self.equal(_.flatten(result, YES).join(@","), @"1,2,1,2", @"initial works with _.map"); // CHANGED: no optional parameters to flatten
}

- (void)test_last
{
  self.equal(_.last(AI(1,2,3), nil), N.I(3), @"can pull out the last element of an array");
  self.equal(_.last(AI(1,2,3), N.I(0)).join(@", "), @"", @"can pass an index to last");
  self.equal(_.last(AI(1,2,3), N.I(2)).join(@", "), @"2, 3", @"can pass an index to last");
  self.equal(_.last(AI(1,2,3), N.I(5)).join(@", "), @"1, 2, 3", @"can pass an index to last");
//  I iResult = (^(){ return _(arguments).last(); })(1, 2, 3, 4);
//  self.equal(iResult, 4, @"works on an arguments object");
  A* result = _.map(AO(AI(1,2,3),AI(1,2,3)), _.lastIterator); // CHANGED
  self.equal(result.join(@","), @"3,3", @"works well with _.map");
}

- (void)test_rest
{
  A* numbers = AI(1, 2, 3, 4);
  self.equal(_.rest(numbers, nil).join(@", "), @"2, 3, 4", @"working rest()");
  self.equal(_.rest(numbers, N.I(0)).join(@", "), @"1, 2, 3, 4", @"working rest(0)");
  self.equal(_.rest(numbers, N.I(2)).join(@", "), @"3, 4", @"rest can take an index");
//  A* result = (^(){ return _(arguments).tail(); })(1, 2, 3, 4);
//  self.equal(result.join(@", "), @"2, 3, 4", @"aliased as tail and works on arguments object");
  A* result = _.map(AO(AI(1,2,3),AI(1,2,3)), _.restIterator); // CHANGED
  self.equal(_.flatten(result, YES).join(@","), @"2,3,2,3", @"works well with _.map"); // CHANGED: no optional parameters to flatten
}

- (void)test_compact
{
  self.equalI(_.compact(AO(N.I(0), N.I(1), N.B(false), N.I(2), N.B(false), N.I(3))).length, 3, @"can trim out all falsy values");
//  I result = (^(){ return _(arguments).compact().length; })(0, 1, false, 2, false, 3);
//  self.equal(result, 3, @"works on an arguments object");
};

- (void)test_flatten
{
//  if (window.JSON) {
    A* list = AO(N.I(1), AI(2), AO(N.I(3), AO(AO(AI(4)))));
    self.equal(JSON.stringify(_.flatten(list, false)), @"[1,2,3,4]", @"can flatten nested arrays"); // CHANGE: mandatory parameter
    self.equal(JSON.stringify(_.flatten(list, YES)), @"[1,2,3,[[[4]]]]", @"can shallowly flatten nested arrays"); // CHANGED: no optional parameters to flatten
//    A* result = (^(){ return _.flatten(arguments); })(1, AI(2), AI(3, AI(AI(AI(4)))));
//    self.equal(JSON.stringify(result), @"[1,2,3,4]", @"works on an arguments object");
//  }
}

- (void)test_without
{
  A* list = AI(1, 2, 1, 0, 3, 1, 4);
  self.equal(_.without(list, 0, 1).join(@", "), @"2, 3, 4", @"can remove all instances of an object");
//  A* result = (^(){ return _.without(arguments, 0, 1); })(1, 2, 1, 0, 3, 1, 4);
//  self.equal(result.join(@", "), @"2, 3, 4", @"works on an arguments object");

  list = AO(OAKV({@"one", N.I(1)}, {@"two", N.I(2)}));
  self.ok(_.without(list, OAKV({@"one", N.I(1)})).length == 2, @"uses real object identity for comparisons.");
  self.ok(_.without(list, list.get(0)).length == 1, @"ditto.");
}

- (void)test_uniq
{
  A* list = AI(1, 2, 1, 3, 1, 4);
  self.equal(_.uniq(list).join(@", "), @"1, 2, 3, 4", @"can find the unique values of an unsorted array"); 

  list = AI(1, 1, 1, 2, 2, 3);
  self.equal(_.uniq3(list, true, nil).join(@", "), @"1, 2, 3", @"can find the unique values of a sorted array faster"); // CHANGE: manadatory 3rd parameter

  list = AO(OAKV({@"name", @"moe"}, {@"name", @"curly"}, {@"name", @"larry"}, {@"name", @"curly"}));
  _MapBlock iterator = ^(O* value, id key) { return value.get(@"name"); };
  self.equal(_.map(_.uniq3(list, false, iterator), iterator).join(@", "), @"moe, curly, larry", @"can find the unique values of an array using a custom iterator"); // CHANGE: uniq3 method to allow more customization

  iterator = ^(N* value, N* index) { return N.I(value.I + 1); };
  list = AI(1, 2, 2, 3, 4, 4);
  self.equal(_.uniq3(list, true, iterator).join(@", "), @"1, 2, 3, 4", @"iterator works with sorted array");

//  A* result = (^(){ return _.uniq(arguments); })(1, 2, 1, 3, 1, 4);
//  self.equal(result.join(@", "), @"1, 2, 3, 4", @"works on an arguments object");
}

- (void)test_intersection
{
  A* stooges = AO(@"moe", @"curly", @"larry"); A* leaders = AO(@"moe", @"groucho");
  self.equal(_.intersection(stooges, leaders).join(@""), @"moe", @"can take the set intersection of two arrays");
//  self.equal(_(stooges).intersection(leaders).join(@""), @"moe", @"can perform an OO-style intersection");
//  A* result = (^(){ return _.intersection(arguments, leaders); })(@"moe", @"curly", @"larry");
//  self.equal(result.join(@""), @"moe", @"works on an arguments object");
}

- (void)test_union
{
  NSA* result = _.union_(AI(1, 2, 3), AI(2, 30, 1), AI(1, 40)); // CHANGE: reserved keyword
  self.equal(result.join(@" "), @"1 2 3 30 40", @"takes the union of a list of arrays");

  result = _.union_(AI(1, 2, 3), AI(2, 30, 1), AO(N.I(1), N.I(40), AI(1))); // CHANGE: reserved keyword
  self.equal(result.join(@" "), @"1 2 3 30 40 1", @"takes the union of a list of nested arrays");
}

- (void)test_difference
{
  NSA* result = _.difference(AI(1, 2, 3), AI(2, 30, 40));
  self.equal(result.join(@" "), @"1 3", @"takes the difference of two arrays");

  result = _.difference(AI(1, 2, 3, 4), AI(2, 30, 40), AI(1, 11, 111));
  self.equal(result.join(@" "), @"3 4", @"takes the difference of three arrays");
}

- (void)test_zip
{
  A* names = AO(@"moe", @"larry", @"curly"); A* ages = AI(30, 40, 50); A* leaders = AB(true);
  NSA* stooges = _.zip(names, ages, leaders);
  self.equal(S.newA(stooges), @"moe,30,true,larry,40,,curly,50,", @"zipped together arrays of different lengths");
}

- (void)test_zipObject
{
  O* result = _.zipObject(AO(@"moe", @"larry", @"curly"), AI(30, 40, 50));
  O* shouldBe = OAKV({@"moe", N.I(30)}, {@"larry", N.I(40)}, {@"curly", N.I(50)});
  self.ok(_.isEqual(result, shouldBe), @"two arrays zipped together into an object");
}

- (void)test_indexOf
{
//  A* numbers = AI(1, 2, 3);
//  numbers.indexOf = null;
//  self.equal(_.indexOf(numbers, 2), 1, @"can compute indexOf, even without the native ^");
//  I result = (^(){ return _.indexOf(arguments, 2); })(1, 2, 3);
//  self.equal(result, N.I(1), @"works on an arguments object");
  self.equalI(_.indexOf(nil, N.I(2)), -1, @"handles nulls properly");

  A* numbers = AI(10, 20, 30, 40, 50); N* num = N.I(35);
  I index = _.indexOfSorted(numbers, num); // CHANGED: Specialized a sorted method
  self.equalI(index, -1, @"35 is not in the list");

  numbers = AI(10, 20, 30, 40, 50); num = N.I(40);
  index = _.indexOfSorted(numbers, num); // CHANGED: Specialized a sorted method
  self.equalI(index, 3, @"40 is in the list");

  numbers = AI(1, 40, 40, 40, 40, 40, 40, 40, 50, 60, 70); num = N.I(40);
  index = _.indexOfSorted(numbers, num); // CHANGED: Specialized a sorted method
  self.equalI(index, 1, @"40 is in the list");
}

- (void)test_lastIndexOf
{
  A* numbers = AI(1, 0, 1, 0, 0, 1, 0, 0, 0);
//  numbers.lastIndexOf = null;
//  self.equal(_.lastIndexOf(numbers, 1), 5, @"can compute lastIndexOf, even without the native ^");
  self.equalI(_.lastIndexOf(numbers, N.I(0)), 8, @"lastIndexOf the other element");
//  I result = (^(){ return _.lastIndexOf(arguments, 1); })(1, 0, 1, 0, 0, 1, 0, 0, 0);
//  self.equalI(result, 5, @"works on an arguments object");
  self.equalI(_.indexOf(nil, N.I(2)), -1, @"handles nulls properly");
}

- (void)test_range
{
//  self.equal(_.range(0).join(@""), @"", @"range with 0 as a first argument generates an empty array");
//  self.equal(_.range(4).join(@" "), @"0 1 2 3", @"range with a single positive argument generates an array of elements 0,1,2,...,n-1");
  self.equal(_.range(5, 8, 1).join(@" "), @"5 6 7", @"range with two arguments a &amp; b, a&lt;b generates an array of elements a,a+1,a+2,...,b-2,b-1"); // CHANGE: mandatory third argument
  self.equal(_.range(8, 5, 1).join(@""), @"", @"range with two arguments a &amp; b, b&lt;a generates an empty array"); // CHANGE: mandatory third argument
  self.equal(_.range(3, 10, 3).join(@" "), @"3 6 9", @"range with three arguments a &amp; b &amp; c, c &lt; b-a, a &lt; b generates an array of elements a,a+c,a+2c,...,b - (multiplier of a) &lt; c");
  self.equal(_.range(3, 10, 15).join(@""), @"3", @"range with three arguments a &amp; b &amp; c, c &gt; b-a, a &lt; b generates an array with a single element, equal to a");
  self.equal(_.range(12, 7, -2).join(@" "), @"12 10 8", @"range with three arguments a &amp; b &amp; c, a &gt; b, c &lt; 0 generates an array of elements a,a-c,a-2c and ends with the number not less than b");
  self.equal(_.range(0, -10, -1).join(@" "), @"0 -1 -2 -3 -4 -5 -6 -7 -8 -9", @"final example in the Python docs");
}

@end
