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
#import "SubjectiveScript.h"

@implementation _ (Arrays)

+ (id(^)(NSArray* array, N* n))first
{
  return ^id(NSArray* array, N* n) {
    return (n != nil) ? array.slice(0, n.I) : array.get(0);
  };
}
+ (id(^)(NSArray* array, N* n))head { return self.first; } // ALIAS
+ (id(^)(NSArray* array, N* n))take { return self.first; } // ALIAS
+ (id(^)(NSArray* array, N* unused))firstIterator
{
  return ^id(NSArray* array, N* unused) {
    return array.get(0);
  };
}

+ (NSArray*(^)(NSArray* array, N* n))initial
{
  return ^(NSArray* array, N* n) {
    return array.slice(0, array.length - ((n == nil) ? 1 : n.I));
  };
}
+ (NSArray*(^)(NSArray* array, N* unused))initialIterator
{
  return ^(NSArray* array, N* unused) {
    return array.slice(0, array.length - 1);
  };
}

+ (id(^)(NSArray* array, N* n))last
{
  return ^(NSArray* array, N* n) {
    if (!array.count) return [NSArray array];
    if (n != nil) {
      return array.slice(MAX(array.length - n.I, 0), array.length);
    } else {
      return array.get(array.length - 1);
    }
  };
}
+ (id(^)(NSArray* array, N* unused))lastIterator
{
  return ^(NSArray* array, N* unused) {
    return array.get(array.length - 1);
  };
}

+ (NSArray*(^)(NSArray* array, N* index))rest
{
  return ^(NSArray* array, N* index) {
    return array.slice((index == nil) ? 1 : index.I, array.length);
  };
}
+ (NSArray*(^)(NSArray* array, N* index))tail { return self.rest; } // ALIAS
+ (NSArray*(^)(NSArray* array, N* unused))restIterator
{
  return ^(NSArray* array, N* unused) {
    if (!array.count) return [NSArray array];
    return array.slice(1, array.length);
  };
}

+ (NSArray*(^)(NSArray* array))compact
{
  return ^(NSArray* array) {
    return _.filter(array, ^(id value, id key){ return _.isTruthy(value); });
  };
}

+ (A*(^)(NSArray* array, N* shallow))flatten
{
  return ^(NSArray* array, N* shallow) {
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

+ (NSArray*(^)(NSArray* array, id value1, ...))without
{
  return ^(NSArray* array, id value1, ...) {
    return [NSArray array];
  };
}

+ (NSArray*(^)(NSArray* array1, ...))union_
{
  return ^(NSArray* array1, ...) {
    return [NSArray array];
  };
}

+ (NSArray*(^)(NSArray* array1, ...))intersection
{
  return ^(NSArray* array1, ...) {
    return [NSArray array];
  };
}

+ (NSArray*(^)(NSArray* array, NSArray* array1, ...))difference
{
  return ^(NSArray* array, NSArray* array1, ...) {
    return [NSArray array];
  };
}

+ (id(^)(NSArray* array))uniq
{
  return ^(NSArray* array) {
    return [NSArray array];
  };
}
+ (id(^)(NSArray* array, B isSorted, _MapBlock iterator))uniqCustomized
{
  return ^(NSArray* array, B isSorted, _MapBlock iterator) {
    return [NSArray array];
  };
}
+ (id(^)(NSArray* array, B isSorted, _MapBlock iterator))unique { return self.uniqCustomized; } // ALIAS

+ (NSArray*(^)(NSArray* array1, ...))zip
{
  return ^(NSArray* array1, ...) {
    // TODO: can I generalize this into: var args = slice.call(arguments);
    A* args = A.new_;
    va_list arrays;
    va_start(arrays, array1);
    for (NSArray *arg = array1; arg != nil; arg = va_arg(arrays, NSArray*))
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

+ (O*(^)(NSArray* keys, NSArray* values))zipObject
{
  return ^(NSArray* keys, NSArray* values) {
    O* result = O.new_;
    for (I i = 0, l = keys.length; i < l; i++) {
      result.set(keys.get(i), values.get(i));
    }
    return result;
  };
}

+ (I(^)(NSArray* array, id value))indexOf
{
  return ^I(NSArray* array, id value) {
    UI index = [array indexOfObject:value];
    return (index == NSNotFound) ? -1 : index;
  };
}

+ (I(^)(NSArray* array, id value))indexOfSorted
{
  // TODO: sorted optimization
  return self.indexOf;
}

+ (I(^)(NSArray* array, id value))lastIndexOf
{
  return ^I(NSArray* array, id value) {
    for(I index=array.length-1; index>=0; index--) {
      id obj = [array objectAtIndex:index];
      if ([obj isEqual:value]) return index;
    }
    return -1;
  };
}

+ (NSArray* (^)(I start, I stop, I step))range
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
