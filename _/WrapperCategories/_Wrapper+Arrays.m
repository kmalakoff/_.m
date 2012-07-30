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
    return _.chain(_.first(self.NSA, n));
  };
}
- (_Wrapper*(^)(I n))head { return self.first; } // ALIAS
- (_Wrapper*(^)(I n))take { return self.first; } // ALIAS

- (_Wrapper*(^)(I n))initial
{
  return ^(I n) {
    return _.chain(_.initial(self.NSA, n));
  };
}

- (_Wrapper*(^)(I n))last
{
  return ^(I n) {
    return _.chain(_.last(self.NSA, n));
  };
}

- (_Wrapper*(^)(I index))rest
{
  return ^(I index) {
    return _.chain(_.rest(self.NSA, index));
  };
}
- (_Wrapper*(^)(I index))tail { return self.rest; } // ALIAS

- (_Wrapper*(^)())compact
{
  return ^{
    return _.chain(_.compact(self.NSA));
  };
}

- (_Wrapper*(^)(B shallow))flatten
{
  return ^(B shallow) {
    return _.chain(self.NSA.flatten(shallow));
  };
}

- (_Wrapper*(^)(id value1, ... /* NIL_TERMINATION */))without
{
  return ^(id value1, ... /* NIL_TERMINATION */) {
    ARGS_AO(items, value1);

    return _.chain(_.difference(self.NSA, items, /* NIL_TERMINATION */ nil));
  };
}

- (_Wrapper*(^)(NSA* array2, ... /* NIL_TERMINATION */))union_
{
  return ^(NSA* array2, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, array2);
    arguments.unshift(self.NSA, nil);
    return _.chain(_.uniq(_.flatten(arguments, YES)));
  };
}

- (_Wrapper*(^)(NSA* array1, ... /* NIL_TERMINATION */))intersection
{
  return ^(NSA* array1, ... /* NIL_TERMINATION */) {
    ARGS_AO(rest, array1);

    return _.chain(_.filter(_.uniq(self.NSA), ^(id item, ... /* KEY, COLLECTION */) {
      return _.every(rest, ^B(id other, ... /* KEY, COLLECTION */) {
        return _.indexOf(other, item) >= 0;
      });
    }));
  };
}

- (_Wrapper*(^)(NSA* array1, ... /* NIL_TERMINATION */))difference
{
  return ^(NSA* array1, ... /* NIL_TERMINATION */) {
    ARGS_AO(rest, array1);

    rest = _.flatten(rest, YES);
    return _.chain(_.filter(self.NSA, ^B(id value, ... /* KEY, COLLECTION */) { return !_.include(rest, value); }));
  };
}

- (_Wrapper*(^)())uniq
{
  return ^{
    return _.chain(_.uniq(self.NSA));
  };
}
- (_Wrapper*(^)())unique { return self.uniq; } // ALIAS
- (_Wrapper*(^)(B isSorted, _MapBlock iterator))uniqAdvanced //
{
  return ^(B isSorted, _MapBlock iterator) {
    return _.chain(_.uniqAdvanced(self.NSA, isSorted, iterator));
  };
}
- (_Wrapper*(^)(B isSorted, _MapBlock iterator))uniqueAdvanced { return self.uniqAdvanced; } // ALIAS

- (_Wrapper*(^)(NSA* array1, ... /* NIL_TERMINATION */))zip
{
  return ^(NSA* array1, ... /* NIL_TERMINATION */) {
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

- (_Wrapper*(^)(NSA* keys, NSA* values))zipObject
{
  return ^(NSA* keys, NSA* values) {
    return _.chain(_.zipObject(keys, values));
  };
}

- (_Wrapper*(^)(id item))indexOf
{
  return ^(id item) {
    return _.chain(N.I(_.indexOf(self.NSA, item)));
  };
}

- (_Wrapper*(^)(id item))indexOfSorted
{
  return ^(id item) {
    return _.chain(N.I(_.indexOfSorted(self.NSA, item)));
  };
}

- (_Wrapper*(^)(id value))lastIndexOf
{
  return ^(id value) {
    return _.chain(N.I(_.lastIndexOf(self.NSA, value)));
  };
}

- (_Wrapper*(^)(UI count))rangeAuto /* SPECIALIZED */
{
  return ^(UI count) {
    return _.chain(_.range(0, count, 1));
  };
}
- (_Wrapper*(^)(I start, I stop, I step))range
{
  return ^(I start, I stop, I step) {
    return _.chain(_.range(start, stop, step));
  };
}

@end
