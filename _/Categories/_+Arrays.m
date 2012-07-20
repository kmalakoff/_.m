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

+ (NSO*(^)(NSA* array, N* n))first
{
  return ^id(NSA* array, N* n) {
    return (n != nil) ? array.slice(0, n.I) : array.get(0);
  };
}
+ (NSO*(^)(NSA* array, N* n))head { return self.first; } // ALIAS
+ (NSO*(^)(NSA* array, N* n))take { return self.first; } // ALIAS
+ (NSO*(^)(NSA* array, N* unused))firstIterator
{
  return ^id(NSA* array, N* unused) {
    return array.get(0);
  };
}

+ (A*(^)(NSA* array, N* n))initial
{
  return ^(NSA* array, N* n) {
    return array.slice(0, array.length - ((n == nil) ? 1 : n.I));
  };
}
+ (A*(^)(NSA* array, N* unused))initialIterator
{
  return ^(NSA* array, N* unused) {
    return array.slice(0, array.length - 1);
  };
}

+ (NSO*(^)(NSA* array, N* n))last
{
  return ^(NSA* array, N* n) {
    if (!array.length) return [NSArray array];
    if (n != nil) {
      return array.slice(MAX(array.length - n.I, 0), array.length);
    } else {
      return array.get(array.length - 1);
    }
  };
}
+ (NSO*(^)(NSA* array, N* unused))lastIterator
{
  return ^(NSA* array, N* unused) {
    return array.get(array.length - 1);
  };
}

+ (A*(^)(NSA* array, N* index))rest
{
  return ^(NSA* array, N* index) {
    return array.slice((index == nil) ? 1 : index.I, array.length);
  };
}
+ (A*(^)(NSA* array, N* index))tail { return self.rest; } // ALIAS
+ (A*(^)(NSA* array, N* unused))restIterator
{
  return ^(NSA* array, N* unused) {
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

+ (A*(^)(NSA* array, BOOL shallow))flatten
{
  return ^(NSA* array, BOOL shallow) {
    A* output = A.new_;

    for (id value in array) {
      if (_.isArray(value) && !shallow) {
        [output addObjectsFromArray:_.flatten(value, shallow)];
      } else {
        output.push(value);
      }
    }

    return output;
  };
}

+ (A*(^)(NSA* array, id value1, ...))without
{
  return ^(NSA* array, id value1, ...) {
    SS_ARGUMENTS(value1)

    return _.reject(array, ^(id value, id index) { return _.include(arguments, value); });
  };
}

+ (A*(^)(NSA* array1, ...))union_
{
  return ^(NSA* array1, ...) {
    SS_ARGUMENTS(array1)

    return _.uniq(_.flatten(arguments, true));
  };
}

+ (A*(^)(NSA* array1, ...))intersection
{
  return ^(NSA* array1, ...) {
    SS_ARGUMENTS(array1)
    
    A* rest = arguments.slice(1, arguments.length);
    return _.filter(_.uniq(array1), ^(id item, id index) {
      return _.every(rest, ^B(id other, id index) {
        return _.indexOf(other, item) >= 0;
      });
    });
  };
}

+ (A*(^)(NSA* array, NSA* array1, ...))difference
{
  return ^(NSA* array, NSA* array1, ...) {
    SS_ARGUMENTS(array1)

    A* rest = _.flatten(arguments, true);
    return _.filter(array, ^B(id value, id index) { return !_.include(rest, value); });
  };
}

+ (A*(^)(NSA* array))uniq
{
  return ^(NSA* array) {
    return [NSArray array];
  };
}
+ (A*(^)(NSA* array, B isSorted, _MapBlock iterator))uniq3
{
  return ^(NSA* array, B isSorted, _MapBlock iterator) {
    return [NSArray array];
  };
}
+ (A*(^)(NSA* array, B isSorted, _MapBlock iterator))unique { return self.uniq3; } // ALIAS

+ (A*(^)(NSA* array1, ...))zip
{
  return ^(NSA* array1, ...) {
    // TODO: can I generalize this into: var args = slice.call(arguments);
    A* args = A.new_;
    va_list arrays;
    va_start(arrays, array1);
    for (NSArray *arg = array1; arg != nil; arg = va_arg(arrays, NSA*))
    {
      args.push(arg);
    }
    va_end(arrays);
    
    N* lengthNumber = _.max(_.pluck(args, @"length"), nil); // CHANGE: mandatory parameters
    I length = lengthNumber.I;
    A* results = A.newWithCapacity(length);
    for (I i = 0; i < length; i++) {
      results.set(i, _.pluck(args, S.formatted(@"%d", i)));
    }
    return results;
  };
}

+ (O*(^)(NSA* keys, NSA* values))zipObject
{
  return ^(NSA* keys, NSA* values) {
    O* result = O.new_;
    for (I i = 0, l = keys.length; i < l; i++) {
      result.set(keys.get(i), values.get(i));
    }
    return result;
  };
}

+ (I(^)(NSA* array, id value))indexOf
{
  return ^I(NSA* array, id value) {
    UI index = [array indexOfObject:value];
    return (index == NSNotFound) ? -1 : index;
  };
}

+ (I(^)(NSA* array, id value))indexOfSorted
{
  // TODO: sorted optimization
  return self.indexOf;
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

+ (A*(^)(I start, I stop, I step))range
{
  return ^(I start, I stop, I step) {
    NSAssert(step!=0, @"step should not be zero");
    I len = MAX(ceil((float)(stop - start) / step), 0);
    I idx = 0;
    A* range = A.newWithCapacity(len);

    while(idx < len) {
      range.push(N.I(start)); idx++;
      start += step;
    }

    return range;
  };
}

@end
