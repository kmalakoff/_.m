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

@implementation _Wrapper (Arrays)

- (_Wrapper*(^)(I n))first
{
  return ^id(I n) {
    return (n>=0) ? self.valueNSA().slice(0, n) : self.valueNSA().get(0);
  };
}
- (_Wrapper*(^)(I n))head { return self.first; } // ALIAS
- (_Wrapper*(^)(I n))take { return self.first; } // ALIAS

- (_Wrapper*(^)(I n))initial
{
  return ^(I n) {
    return _.chain(self.valueNSA().slice(0, self.valueNSA().length - ((n<0) ? 1 : n)));
  };
}

- (_Wrapper*(^)(I n))last
{
  return ^(I n) {
    return _.chain(_.last(self.valueNSA(), n));
  };
}

- (_Wrapper*(^)(I index))rest
{
  return ^(I index) {
    return _.chain(self.valueNSA().slice((index<0) ? 1 : index, self.valueNSA().length));
  };
}
- (_Wrapper*(^)(I index))tail { return self.rest; } // ALIAS

- (_Wrapper*(^)())compact
{
  return ^{
    return _.chain(_.compact(self.valueNSA()));
  };
}

- (_Wrapper*(^)(BOOL shallow))flatten
{
  return ^(BOOL shallow) {
    return _.chain(_.flatten(self.valueNSA(), shallow));
  };
}

- (_Wrapper*(^)(id value1, ...))without
{
  return ^(id value1, ...) {
    ARGS_AO(items, value1);

    return _.chain(_.difference(self.valueNSA(), items, /* NIL TERMINATED */ nil));
  };
}

- (_Wrapper*(^)(NSA* array1, ...))union_
{
  return ^(NSA* array1, ...) {
    ARGS_AO(arguments, array1);

    return _.chain(_.uniq(_.flatten(arguments, YES)));
  };
}

- (_Wrapper*(^)(NSA* array1, ...))intersection
{
  return ^(NSA* array1, ...) {
    ARGS_AO(rest, array1);

    return _.chain(_.filter(_.uniq(self.valueNSA()), ^(id item, id key) {
      return _.every(rest, ^B(id other, id key) {
        return _.indexOf(other, item) >= 0;
      });
    }));
  };
}

- (_Wrapper*(^)(NSA* array1, ...))difference
{
  return ^(NSA* array1, ...) {
    ARGS_AO(rest, array1);

    rest = _.flatten(rest, YES);
    return _.chain(_.filter(self.valueNSA(), ^B(id value, id key) { return !_.include(rest, value); }));
  };
}

- (_Wrapper*(^)())uniq
{
  return ^{
    return _.chain(_.uniq(self.valueNSA()));
  };
}
- (_Wrapper*(^)(B isSorted, _ValueKeyMapBlock iterator))uniq3
{
  return ^(B isSorted, _ValueKeyMapBlock iterator) {
    return _.chain(_.uniq3(self.valueNSA(), isSorted, iterator));
  };
}
- (_Wrapper*(^)(B isSorted, _ValueKeyMapBlock iterator))unique { return self.uniq3; } // ALIAS

- (_Wrapper*(^)(NSA* array1, ...))zip
{
  return ^(NSA* array1, ...) {
    ARGS_AO(arguments, array1);

    N* lengthNumber = (N*) _.max(_.pluck(arguments, @"length"), /* MANDATORY */ nil);
    I length = lengthNumber.I;
    A* results = A.newC(length);
    for (I i = 0; i < length; i++) {
      results.setAt(i, _.pluck(arguments, S.newFormatted(@"%d", i)));
    }
    return _.chain(results);
  };
}

// zipObject /* NO OO-STYLE WRAPPER VERSION */

- (_Wrapper*(^)(id item))indexOf
{
  return ^(id item) {
    return _.chain(N.I(_.indexOf(self.valueNSA(), item)));
  };
}

- (_Wrapper*(^)(id item))indexOfSorted
{
  return ^(id item) {
    return _.chain(N.I(_.indexOfSorted(self.valueNSA(), item)));
  };
}

- (_Wrapper*(^)(id value))lastIndexOf
{
  return ^(id value) {
    return _.chain(N.I(_.lastIndexOf(self.valueNSA(), value)));
  };
}

// range /* NO OO-STYLE WRAPPER VERSION */

@end
