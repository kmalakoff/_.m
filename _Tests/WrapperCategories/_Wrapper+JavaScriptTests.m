//
//  _Wrapper+JavaScriptTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Wrapper+JavaScriptTests.h"
#import "QUnit.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation _Wrapper_JavaScriptTests

- (void)test_length
{
  equal(_.chain(AI(1,2,3)).length.UI, 3, @"length works");
}

- (void)test_hasOwnProperty
{
  ok(_.chain(AI(1,2,3)).hasOwnProperty(@"2").B, @"hasOwnProperty by index string");
  equal(AI(1,2,3).get(@"2"), N.I(3), @"accessing by index string");
}

- (void)test_concat
{
  equal(_.chain(AI(1,2,3)).concat(AI(1,2,4)).join(@",").NSS, @"1,2,3,1,2,4", @"concat (and join) works");
}

- (void)test_slice
{
  equal(_.chain(AO(@"Banana", @"Orange", @"Lemon", @"Apple", @"Mango")).slice(-3,-1).join(@",").NSS, @"Lemon,Apple", @"slice works");
}

- (void)test_reverse
{
  equal(_.chain(AI(1,2,3)).reverse().join(@",").NSS, @"3,2,1", @"reverse works");
}

- (void)test_flatten
{
  equal(_.chain(AO(N.I(1),AI(2,3))).flatten(true).join(@",").NSS, @"1,2,3", @"flatten works");
}

- (void)test_pop
{
  _Wrapper* array = _.chain(AI(1,2,3));
  array.pop();
//  equal(array.pop().N, N.I(3), @"pop works"); // UnderscoreJS pop on wrapper returns the array, not the popped item
  equal(array.join(@",").NSS, @"1,2", @"pop works");
}

- (void)test_push
{
  equal(_.chain(AI(1,2,3)).push(N.I(4)).push(@"out the door").join(@",").NSS, @"1,2,3,4,out the door", @"push with chaining works");
}

- (void)test_sort
{
  equal(_.chain(AI(3,2,1,2)).sort(nil).join(@",").NSS, @"1,2,2,3", @"sort works");
}

- (void)test_splice
{
  A* fruit = AO(@"Banana", @"Orange", @"Apple", @"Lemon");
  _Wrapper* fruitWrapper = _.chain(fruit);
  equal(fruitWrapper.splice(2,1, @"Kiwi", @"Mango", nil).join(@",").NSS, @"Apple", @"splice return works");
  equal(fruit.join(@","), @"Banana,Orange,Kiwi,Mango,Lemon", @"splice works");
}

- (void)test_unshift
{
  equal(_.chain(AI(3,4,5)).unshift(N.I(1),N.I(2),nil).join(@",").NSS, @"1,2,3,4,5", @"unshift works");
}

- (void)test_shift
{
  _Wrapper* array = _.chain(AI(1,2,3,4,5));
  equal(array.shift().N, N.I(1), @"shift works");
  equal(array.join(@",").NSS, @"2,3,4,5", @"shift works");
}

@end
