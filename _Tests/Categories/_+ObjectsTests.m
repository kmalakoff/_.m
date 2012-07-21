//
//  _+ObjectsTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_+ObjectsTests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation _OAKVbjectsTests

//keys
//values
//functions
//extend
//pick
//defaults
//clone
//tap
//has
//isEqual

- (void)test_isEmpty
{
  // TODO: wrapper
self.ok(!_.isEmpty(AI(1)), @"[1] is not empty"); //  self.ok(!__(AI(1)).isEmpty(), @"[1] is not empty");
  self.ok(_.isEmpty(A.new), @"[] is empty");
  self.ok(!_.isEmpty(OAKV({@"one", N.I(1)})), @"{one : 1} is not empty");
  self.ok(_.isEmpty(O.new), @"{} is empty");
//  self.ok(_.isEmpty(new RegExp('")), @"objects with prototype properties are empty");
  self.ok(_.isEmpty(nil), @"null is empty");
//  self.ok(_.isEmpty(), @"undefined is empty");
  self.ok(_.isEmpty(@""), @"the empty string is empty");
  self.ok(!_.isEmpty(@"moe"), @"but other strings are not");

  O* obj = OAKV({@"one", N.I(1)});
  obj.delete_(@"one");
  self.ok(_.isEmpty(obj), @"deleting all the keys from an object empties it");
}

//isElement

- (void)test_isArray
{
//  self.ok(!_.isArray(arguments), @"the arguments object is not an array");
  self.ok(_.isArray(AI(1, 2, 3)), @"but arrays are");
//  self.ok(_.isArray(iArray), @"even from another frame");
}

- (void)test_isObject
{
//  self.ok(_.isObject(arguments), @"the arguments object is object");
  self.ok(_.isObject(AI(1, 2, 3)), @"and arrays");
//  self.ok(_.isObject($("html")[0]), @"and DOM element");
//  self.ok(_.isObject(iElement), @"even from another frame");
//  self.ok(_.isObject(function () {}), @"and functions");
//  self.ok(_.isObject(iFunction), @"even from another frame");
  self.ok(!_.isObject(nil), @"but not null");
//  self.ok(!_.isObject(undefined), @"and not undefined");
//  self.ok(!_.isObject(@"string"), @"and not string");
  self.ok(!_.isObject(N.I(12)), @"and not number");
  self.ok(!_.isObject(N.B(YES)), @"and not boolean");
  self.ok(_.isObject(S.newS(@"string")), @"but new String()");
}

//isArguments
//isFunction

- (void)test_isString
{
//  self.ok(!_.isString(document.body), @"the document body is not a string");
  self.ok(_.isString(AI(1, 2, 3).join(@", ")), @"but strings are");
//  self.ok(_.isString(iString), @"even from another frame");
}

- (void)test_isNumber
{
  self.ok(!_.isNumber(@"string"), @"a string is not a number");
//  self.ok(!_.isNumber(arguments), @"the arguments object is not a number");
//  self.ok(!_.isNumber(undefined), @"undefined is not a number");
  self.ok(_.isNumber(N.F(3 * 4 - 7 / 10)), @"but numbers are");
//  self.ok(_.isNumber(NaN), @"NaN *is* a number");
//  self.ok(_.isNumber(Infinity), @"Infinity is a number");
//  self.ok(_.isNumber(iNumber), @"even from another frame");
  self.ok(!_.isNumber(@"1"), @"numeric strings are not numbers");
}

//isFinite
//isBoolean

- (void)test_isDate
{
  self.ok(!_.isDate(N.I(100)), @"numbers are not dates");
  self.ok(!_.isDate(O.new), @"objects are not dates");
  self.ok(_.isDate(D.new), @"but dates are");
//  self.ok(_.isDate(iDate), @"even from another frame");
}

//isRegExp
//isNaN

- (void)test_isNull
{
//  self.ok(!_.isNull(undefined), @"undefined is not null");
//  self.ok(!_.isNull(NaN), @"NaN is not null");
  self.ok(_.isNull(NSNull.null), @"but null is"); // ADDED
  self.ok(_.isNull(nil), @"but null is");
//  self.ok(_.isNull(iNull), @"even from another frame");
}

//isUndefined

@end
