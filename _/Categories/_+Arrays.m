//
//  _+Arrays.m
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

#import "_+Arrays.h"
#import "_+Objects.h"
#import "_+Collections.h"
#import "_+Extensions.h"
#import "SubjectiveScript.h"

@implementation _ (Arrays)

+ (NSO*(^)(NSA* array, I n))first
{
  return ^id(NSA* array, I n) {
    return (n>=0) ? array.slice(0, n) : array.get(0);
  };
}
+ (NSO*(^)(NSA* array, I n))head { return self.first; } // ALIAS
+ (NSO*(^)(NSA* array, I n))take { return self.first; } // ALIAS
+ (NSO*(^)(id array, id key))firstIterator
{
  return ^id(NSA* array, id key) {
    return array.get(0);
  };
}

+ (NSA*(^)(NSA* array, I n))initial
{
  return ^(NSA* array, I n) {
    return array.slice(0, array.length - ((n<0) ? 1 : n));
  };
}
+ (NSA*(^)(id array, id key))initialIterator
{
  return ^(NSA* array, id key) {
    return array.slice(0, array.length - 1);
  };
}

+ (NSO*(^)(NSA* array, I n))last
{
  return ^(NSA* array, I n) {
    if (!array.length) return [NSArray array];
    if (n>=0) {
      return array.slice(MAX((I)array.length - n, 0), array.length);
    } else {
      return array.getAt(array.length - 1);
    }
  };
}
+ (NSO*(^)(id array, id key))lastIterator
{
  return ^(NSA* array, id key) {
    return array.getAt(array.length - 1);
  };
}

+ (NSA*(^)(NSA* array, I index))rest
{
  return ^(NSA* array, I index) {
    return array.slice((index<0) ? 1 : index, array.length);
  };
}
+ (NSA*(^)(NSA* array, I index))tail { return self.rest; } // ALIAS
+ (NSA*(^)(id array, id key))restIterator
{
  return ^(NSA* array, id key) {
    if (!array.length) return [NSArray array];
    return array.slice(1, array.length);
  };
}

+ (A*(^)(NSA* array))compact
{
  return ^(NSA* array) {
    return _.filter(array, ^B(id value, id key){ return _.isTruthy(value); });
  };
}

+ (A*)flatten:(NSA*)array shallow:(BOOL)shallow output:(A*)output
{
  for (id value in array) {
    if (_.isArray(value)) {
      shallow ? [output addObjectsFromArray:value] : (void) [self flatten:value shallow:shallow output:output];
    } else {
      output.push(value);
    }
  }
  
  return output;
}

+ (A*(^)(NSA* array, BOOL shallow))flatten
{
  return ^(NSA* array, BOOL shallow) {
    A* output = A.new;
    [self flatten:array shallow:shallow output:output];
    return output;
  };
}

+ (A*(^)(NSA* array, id value1, ...))without
{
  return ^(NSA* array, id value1, ...) {
    ARGS_AO(items, value1);
    return _.difference(array, items, /* NIL TERMINATED */ nil);
  };
}

+ (A*(^)(NSA* array, ...))union_
{
  return ^(NSA* array, ...) {
    ARGS_AO(arguments, array);

    return _.uniq([self flatten:arguments shallow:YES output:A.new]);
  };
}

+ (A*(^)(NSA* array, NSA* array1, ...))intersection
{
  return ^(NSA* array, NSA* array1, ...) {
    ARGS_AO(rest, array1);

    return _.filter(_.uniq(array), ^(id item, id key) {
      return _.every(rest, ^B(id other, id key) {
        return _.indexOf(other, item) >= 0;
      });
    });
  };
}

+ (A*(^)(NSA* array, NSA* array1, ...))difference
{
  return ^(NSA* array, NSA* array1, ...) {
    ARGS_AO(rest, array1);

    rest = _.flatten(rest, YES);
    return _.filter(array, ^B(id value, id key) { return !_.include(rest, value); });
  };
}

+ (A*(^)(NSA* array))uniq
{
  return ^(NSA* array) {
    NSA* initial = array;
    A* results = A.new;
    _.reduce(initial, ^(A* memo, NSO* value, id key) {
      if (!_.include(memo, value)) {
        memo.push(value);
        results.push(array.get(key));
      }
      return memo;
    }, A.new);
    return results;
  };
}
+ (A*(^)(NSA* array, B isSorted, _ValueKeyMapBlock iterator))uniq3
{
  return ^(NSA* array, B isSorted, _ValueKeyMapBlock iterator) {
    NSA* initial = iterator ? _.map(array, iterator) : array;
    A* results = A.new;
    _.reduce(initial, ^(A* memo, NSO* value, id key) {
      if (isSorted ? (_.last(memo, -1) != value || !memo.length) : !_.include(memo, value)) {
        memo.push(value);
        results.push(array.get(key));
      }
      return memo;
    }, A.new);
    return results;
  };
}
+ (A*(^)(NSA* array, B isSorted, _ValueKeyMapBlock iterator))unique { return self.uniq3; } // ALIAS

+ (A*(^)(NSA* array, ...))zip
{
  return ^(NSA* array, ...) {
    ARGS_AO(arguments, array);

    N* lengthNumber = (N*) _.max(_.pluck(arguments, @"length"), /* MANDATORY */ nil);
    I length = lengthNumber.I;
    A* results = A.newC(length);
    for (I i = 0; i < length; i++) {
      results.setAt(i, _.pluck(arguments, S.newFormatted(@"%d", i)));
    }
    return results;
  };
}

+ (O*(^)(NSA* keys, NSA* values))zipObject
{
  return ^(NSA* keys, NSA* values) {
    O* result = O.new;
    for (I i = 0, l = keys.length; i < l; i++) {
      result.set(keys.getAt(i), values.getAt(i));
    }
    return result;
  };
}

+ (I(^)(NSA* array, id item))indexOf
{
  return ^I(NSA* array, id item) {
    if (!array) return -1;
    UI index = [array indexOfObject:item];
    return (index == NSNotFound) ? -1 : index;
  };
}

+ (I(^)(NSA* array, id item))indexOfSorted
{
  return ^I(NSA* array, id item) {
    I i = _.sortedIndex(array, item, /* MANDATORY */ nil);
    return [array.getAt(i) isEqual:item] ? i : -1;
  };
}

+ (I(^)(NSA* array, id value))lastIndexOf
{
  return ^I(NSA* array, id value) {
    for(I index=array.length-1; index>=0; index--) {
      id obj = [array objectAtIndex:index];
      if ([obj isEqual:value]) return index;
    }
    return -1;
  };
}

+ (A*(^)(I count))range1 /* SPECIALIZED */
{
  return ^(I count) {
    return _.range(0, count, 1);
  };
}

+ (A*(^)(I start, I stop, I step))range
{
  return ^(I start, I stop, I step) {
    NSAssert(step!=0, @"step should not be zero");
    I len = MAX(ceil((float)(stop - start) / step), 0);
    I idx = 0;
    A* range = A.newC(len);

    while(idx < len) {
      range.push(N.I(start)); idx++;
      start += step;
    }

    return range;
  };
}

@end
