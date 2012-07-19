//
//  _+Collections.m
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

#import "_+Collections.h"
#import "_+Objects.h"
#import "SubjectiveScript.h"

@implementation _ (Collections)

+ (void(^)(id obj, _IteratorBlock iterator))each
{
  return ^(id obj, _IteratorBlock iterator) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or nil");

    if (_.isNull(obj))
      return;

    else if (_.isArray(obj)) {
      NSArray* array = obj;
      if(!array.count) return;

      NSInteger count = [array count];
      for (NSInteger index=0; index<count; index++) {
        iterator([array objectAtIndex:index], [N numberWithInteger:index]);
      }
    }
    else {
      NSDictionary *dictionary = obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
          iterator(value, key);
      }];
    }
  };
}
+ (void(^)(id obj, _IteratorBlock iterator))forEach { return self.each; }  // ALIAS
+ (void(^)(id obj, _IteratorWithContextBlock iterator, id context))eachWithContext
{
  return ^(id obj, _IteratorWithContextBlock iterator, id context){
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or nil");

    if (_.isNull(obj))
      return;

    else if (_.isArray(obj)) {
      NSArray* array = obj;
      if(!array.count) return;

      NSInteger count = [array count];
      for (NSInteger index=0; index<count; index++) {
        iterator([array objectAtIndex:index], [N numberWithInteger:index], context);
      }
    }
    else {
      NSDictionary *dictionary = obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
          iterator(value, key, context);
      }];
    }
  };
}

+ (id(^)(id obj, _MapBlock iterator))map
{
  return ^(id obj, _MapBlock iterator) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or nil");

    if (_.isNull(obj))
      return A.new_;

    else if (_.isArray(obj)) {
      NSArray* array = obj;
      if(!array.count) return A.new_;

      A* result = [A arrayWithCapacity:array.count];
      NSInteger count = [array count];
      for (NSInteger index=0; index<count; index++) {
        id mapped = iterator([array objectAtIndex:index], [N numberWithInteger:index]);
        if (mapped)
          [result addObject:mapped];
      }

      return result;
    }
    else {
      NSDictionary *dictionary = obj;
      O* result = O.new_;

      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        id mapped = iterator(value, key);
        if (mapped)
          [result setObject:mapped forKey:key];
      }];
      
      return (id) result;
    }
    
    return nil;
  };
}
+ (id(^)(id obj, _MapBlock iterator))collect { return self.map; }
+ (id(^)(id obj, _MapWithContextBlock iterator, id context))mapWithContext
{
  return ^(id obj, _MapWithContextBlock iterator, id context) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or nil");

    if (_.isNull(obj))
      return A.new_;

    else if (_.isArray(obj)) {
      NSArray* array = obj;
      if(!array.count) return A.new_;

      A* result = [A arrayWithCapacity:array.count];
      NSInteger count = [array count];
      for (NSInteger index=0; index<count; index++) {
        id mapped = iterator([array objectAtIndex:index], [N numberWithInteger:index], context);
        if (mapped)
          [result addObject:mapped];
      }

      return result;
    }
    else {
      NSDictionary *dictionary = obj;
      O* result = O.new_;

      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        id mapped = iterator(value, key, context);
        if (mapped)
          [result setObject:mapped forKey:key];
      }];
      
      return (id) result;
    }
    
    return nil;
  };
}

//reduce
//reduceRight
//find

+ (A*(^)(id obj, _IteratorTestBlock iterator))filter
{
  return ^(id obj, _IteratorTestBlock iterator) {
    A* results = A.new_;
    if (obj == nil) return results;
    _.each(obj, ^(id value, id index) {
      if (iterator(value, index)) results.push(value);
    });
    return results;
  };
}
+ (A*(^)(id obj, _IteratorTestBlock iterator))select { return self.filter; } // ALIAS
+ (A*(^)(id obj, _IteratorTestWithContexBlock iterator, id context))filterWithContext
{
  return ^(id obj, _IteratorTestWithContexBlock iterator, id context) {
    A* results = A.new_;
    if (obj == nil) return results;
    _.each(obj, ^(id value, id index) {
      if (iterator(value, index, context)) results.push(value);
    });
    return results;
  };
}

//reject
//all
//any
//include
//invoke
//pluck
//max
//min
//sortBy
//groupBy
//sortedIndex
//shuffle
//toArray
//size

@end
