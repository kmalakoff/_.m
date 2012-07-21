//
//  _Wrapper+Arrays.m
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

#import "_Wrapper+Arrays.h"
#import "_Wrapper+Private.h"
#import "_+Arrays.h"
#import "_+Collections.h"
#import "SubjectiveScript.h"

#define _array ((A*)self._wrapped)

@implementation _Wrapper (Arrays)

- (NSO*(^)(I n))first
{
  return ^id(I n) {
    return (n>=0) ? _array.slice(0, n) : _array.get(0);
  };
}
- (NSO*(^)(I n))head { return self.first; } // ALIAS
- (NSO*(^)(I n))take { return self.first; } // ALIAS
- (NSO*(^)(KH kh))firstIterator
{
  return ^id(KH kh) {
    return _array.get(0);
  };
}

- (NSA*(^)(I n))initial
{
  return ^(I n) {
    return _array.slice(0, _array.length - ((n<0) ? 1 : n));
  };
}
- (NSA*(^)(KH kh))initialIterator
{
  return ^(KH kh) {
    return _array.slice(0, _array.length - 1);
  };
}

- (NSO*(^)(I n))last
{
  return ^(I n) {
    return _.last(_array, n);
  };
}
- (NSO*(^)(KH kh))lastIterator
{
  return ^(KH kh) {
    return _array.get(_array.length - 1);
  };
}

- (NSA*(^)(I index))rest
{
  return ^(I index) {
    return _array.slice((index<0) ? 1 : index, _array.length);
  };
}
- (NSA*(^)(I index))tail { return self.rest; } // ALIAS
- (NSA*(^)(KH kh))restIterator
{
  return ^(KH kh) {
    if (!_array.length) return [NSArray array];
    return _array.slice(1, _array.length);
  };
}

- (A*(^)())compact
{
  return ^() {
    return _.compact(_array);
  };
}

- (A*(^)(BOOL shallow))flatten
{
  return ^(BOOL shallow) {
    return _.flatten(_array, shallow);
  };
}

- (A*(^)(id value1, ...))without
{
  return ^(id value1, ...) {
    AO_ARGS(items, value1);

    return _.difference(_array, items, /* NIL TERMINATED */ nil);
  };
}

- (A*(^)(NSA* array1, ...))union_
{
  return ^(NSA* array1, ...) {
    AO_ARGS(arguments, array1)

    return _.uniq(_.flatten(arguments, YES));
  };
}

- (A*(^)(NSA* array1, ...))intersection
{
  return ^(NSA* array1, ...) {
    AO_ARGS(rest, array1)

    return _.filter(_.uniq(_array), ^(id item, KH kh) {
      return _.every(rest, ^B(id other, KH kh) {
        return _.indexOf(other, item) >= 0;
      });
    });
  };
}

- (A*(^)(NSA* array1, ...))difference
{
  return ^(NSA* array1, ...) {
    AO_ARGS(rest, array1)

    rest = _.flatten(rest, YES);
    return _.filter(_array, ^B(id value, KH kh) { return !_.include(rest, value); });
  };
}

- (A*(^)())uniq
{
  return ^() {
    return _.uniq(_array);
  };
}
- (A*(^)(B isSorted, _MapBlock iterator))uniq3
{
  return ^(B isSorted, _MapBlock iterator) {
    return _.uniq3(_array, isSorted, iterator);
  };
}
- (A*(^)(B isSorted, _MapBlock iterator))unique { return self.uniq3; } // ALIAS

- (A*(^)(NSA* array1, ...))zip
{
  return ^(NSA* array1, ...) {
    AO_ARGS(arguments, array1)

    N* lengthNumber = _.max(_.pluck(arguments, @"length"), /* MANDATORY */ nil);
    I length = lengthNumber.I;
    A* results = A.newWithCapacity(length);
    for (I i = 0; i < length; i++) {
      results.set(i, _.pluck(arguments, S.newFormatted(@"%d", i)));
    }
    return results;
  };
}

// zipObject /* NO WRAP */

- (I(^)(id item))indexOf
{
  return ^I(id item) {
    return _.indexOf(_array, item);
  };
}

- (I(^)(id item))indexOfSorted
{
  return ^I(id item) {
    return _.indexOfSorted(_array, item);
  };
}

- (I(^)(id value))lastIndexOf
{
  return ^I(id value) {
    return _.lastIndexOf(_array, value);
  };
}

// range /* NO WRAP */

@end
