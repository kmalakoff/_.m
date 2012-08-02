//
//  _+ExtensionsTests.m
//  _.m
//
//  Created by Kevin Malakoff on 8/2/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_+ExtensionsTests.h"
#import "QUnit.h"
#import "Underscore.h"

@interface ValueOwner : NSObject
@end
@implementation ValueOwner
@end

@implementation __ExtensionsTests

- (void)test_isTruthy
{
  ok(_.isTruthy(N.B(true)), @"true isTruthy")
  ok(!_.isTruthy(N.B(false)), @"false is not isTruthy")
  ok(_.isTruthy(@"hello"), @"hello isTruthy")
  ok(!_.isTruthy(@""), @"empty string isTruthy")
}

- (void)test_isFalsy
{
  ok(!_.isFalsy(N.B(true)), @"true is not isFalsy")
  ok(_.isFalsy(N.B(false)), @"false is isFalsy")
  ok(!_.isFalsy(@"hello"), @"hello not isFalsy")
  ok(_.isFalsy(@""), @"empty string isFalsy")
}

- (void)test_isDictionary
{
  ok(_.isDictionary(NSD.new), @"NSDictionary isDictionary")
  ok(_.isDictionary(O.new), @"NSMutableDictionary isDictionary")
  ok(!_.isDictionary(N.B(true)), @"true is not isDictionary")
}

- (void)test_isBlock
{
  ok(_.isBlock(^{}), @"a block isBlock")
  ok(!_.isBlock(N.B(true)), @"true is not isBlock")
}

- (void)test_valueTester
{
  ValueOwner* owner1 = ValueOwner.new;
  ValueOwner* owner2 = ValueOwner.new;
  A* objects = AO(OKV({@"name", @"bob"}, {@"owner", owner1}), OKV({@"name", @"george"}, {@"owner", owner2}), OKV({@"name", @"fred"}, {@"owner", owner1}));
  equal(_.pluck(_.filter(objects, _.valueTester(@"owner", owner1)), @"name").toString(), @"[bob,fred]", @"valueTester: select by owner1")
}

- (void)test_valueString
{
  A* objects = AO(OKV({@"name", @"bob"}, {@"owner", @"this guy"}), OKV({@"name", @"george"}, {@"owner", @"that guy"}), OKV({@"name", @"fred"}, {@"owner", @"this guy"}));
  equal(_.pluck(_.filter(objects, _.valueStringTester(@"owner", @"this guy")), @"name").toString(), @"[bob,fred]", @"valueTester: select by 'this guy'")
}

- (void)test_setProps
{
  ValueOwner* owner1 = ValueOwner.new;
  ValueOwner* owner2 = ValueOwner.new;
  A* objects = AO(OKV({@"name", @"bob"}, {@"owner", owner1}), OKV({@"name", @"george"}, {@"owner", owner2}), OKV({@"name", @"fred"}, {@"owner", owner1}));
  _.setProps(objects, @"owner", nil);
  equal(SS.stringify(_.pluck(objects, @"owner")), @"[null,null,null]", @"setProps: clear owners")
}

- (void)test_classNames
{
  A* objects = AO(ValueOwner.new, ValueOwner.new);
  equal(_.classNames(objects).join(@","), @"ValueOwner,ValueOwner", @"classNames: clear owners")
}

@end
