//
//  _Wrapper+JavaScript.m
//  _.m
//
//  Created by Kevin Malakoff on 7/29/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Wrapper+JavaScript.h"
#import "_Wrapper+Private.h"
#import "_+Objects.h"
#import "SubjectiveScript.h"

@implementation _Wrapper (JavaScript)

// Add all mutator Array functions to the wrapper.
- (_Wrapper*(^)())pop
{
  return ^() {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif
    A* array = self.valueA();
    if (!array) return self;

    array.pop();
    return self; // chining doesn't return the popped element but the array
  };
}

- (_Wrapper*(^)(id value))push
{
  return ^(id value) {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif
    A* array = self.valueA();
    if (!array) return self;

    array.push(value);
    return self; // chining doesn't return the popped element but the array
  };
}

- (_Wrapper*(^)())reverse
{
  return ^() {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif
    A* array = self.valueA();
    if (!array) return self;

    return _.chain(array.reverse());
  };
}

- (_Wrapper*(^)(_SortBlock iterator))sort
{
  return ^(_SortBlock iterator) {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif
    A* array = self.valueA();
    if (!array) return self;

    return _.chain(array.sort(iterator));
  };
}

- (_Wrapper*(^)(I start, I count, id item1, ... /* NIL_TERMINATED */))splice
{
  return ^(I start, I count, id item1, ... /* NIL_TERMINATED */) {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif
    A* array = self.valueA();
    if (!array) return self;

    NSA* results = array.splice(start, count, nil);

    ARGS_AO(items, item1);
    for (id item in items.reverseObjectEnumerator)
      [array insertObject:item atIndex:0];

    return _.chain(results);
  };
}

- (_Wrapper*(^)(id item1, ... /* NIL_TERMINATED */))unshift
{
  return ^(id item1, ... /* NIL_TERMINATED */) {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif
    A* array = self.valueA();
    if (!array) return self;

    ARGS_AO(items, item1);
    for (id item in items.reverseObjectEnumerator) {
      [array insertObject:item atIndex:0];
    }
    return self;
  };
}

// Add all accessor Array functions to the wrapper.
- (_Wrapper*(^)(NSA* other))concat
{
  return ^(NSA* other) {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif
    A* array = self.valueA();
    if (!array) return self;

    return _.chain(array.concat(other));
  };
}

- (_Wrapper*(^)(NSS* separator))join
{
  return ^(NSS* separator) {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif
    A* array = self.valueA();
    if (!array) return self;

    return _.chain(array.join(separator));
  };
}

- (_Wrapper*(^)(I start, I count))slice
{
  return ^(I start, I count) {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif
    A* array = self.valueA();
    if (!array) return self;

    return _.chain(array.slice(start, count));
  };
}

@end
