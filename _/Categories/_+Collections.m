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
#import "_+Arrays.h"
#import "SubjectiveScript.h"

@implementation _ (Collections)

+ (void(^)(id obj, _IteratorBlock iterator))each
{
  return ^(id obj, _IteratorBlock iterator) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or nil");

    if (_.isNull(obj))
      return;

    else if (_.isArray(obj)) {
      NSA* array = obj;
      if(!array.length) return;

      I count = [array count];
      for (I index=0; index<count; index++) {
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
+ (B(^)(id obj, _IteratorTestBlock iterator))eachWithStop
{
  return ^B(id obj, _IteratorTestBlock iterator) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or nil");

    if (_.isNull(obj)) return NO;

    else if (_.isArray(obj)) {
      NSA* array = obj;
      if(!array.length) return NO;

      I count = [array count];
      for (I index=0; index<count; index++) {
        if (!iterator([array objectAtIndex:index], [N numberWithInteger:index])) return YES;
      }

      return NO;
    }
    else {
      __block B wasStopped = NO;
      NSDictionary *dictionary = obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if (!iterator(value, key)) {
          wasStopped = YES;
          *stop = YES;
        }
      }];
      return wasStopped;
    }
  };
}


+ (A*(^)(id obj, _MapBlock iterator))map
{
  return ^(id obj, _MapBlock iterator) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or nil");

    if (_.isNull(obj))
      return A.new_;

    else if (_.isArray(obj)) {
      NSA* array = obj;
      if(!array.length) return A.new_;

      A* result = [A arrayWithCapacity:array.length];
      I count = [array count];
      for (I index=0; index<count; index++) {
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
+ (A*(^)(id obj, _MapBlock iterator))collect { return self.map; }

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

+ (A*(^)(id obj, _IteratorTestBlock iterator))reject
{
  return ^(id obj, _IteratorTestBlock iterator) {
    A* results = A.new;
    if (obj == nil) return results;
    _.each(obj, ^(id value, id index) {
      if (!iterator(value, index)) results.push(value);
    });
    return results;
  };
}

+ (B(^)(id obj, _IteratorTestBlock iterator))all
{
  return ^B(id obj, _IteratorTestBlock iterator) {
    if (obj == nil) return NO;
    return _.eachWithStop(obj, iterator);
  };
}
+ (B(^)(id obj, _IteratorTestBlock iterator))every {return self.all; } // ALIAS

//any

+ (B(^)(id obj, id target))include
{
  return ^B(id obj, id target) {
    if (obj == nil) return NO;
    return _.indexOf(obj, target) != -1;
  };
}
+ (B(^)(id obj, id target))contains { return self.include; } // ALIAS

//invoke

+ (NSO*(^)(id obj, NSS* keyPath))pluck
{
  return ^(id obj, NSString *keyPath) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj), @"each expecting NSArray or NSDictionary");

    if (_.isArray(obj)) {
      return _.map(obj, ^(id value, id key) {
        return [value valueForKeyPath:keyPath];
      });
    }
    
    else {
      NSDictionary *dictionary = obj;
      return [dictionary valueForKey:keyPath];
    }
  };
}

+ (N*(^)(id obj, _MapBlock iterator))max
{
  return ^(id obj, _MapBlock iterator) {
    return N.I(65535);
    // TODO
//    if (!iterator && _.isArray(obj) && obj[0] === +obj[0] && obj.length < 65535) {
//      return Math.max.apply(Math, obj);
//    }
//    if (!iterator && _.isEmpty(obj)) return -Infinity;
//    var result = {computed : -Infinity};
//    each(obj, function(value, index, list) {
//      var computed = iterator ? iterator.call(context, value, index, list) : value;
//      computed >= result.computed && (result = {value : value, computed : computed});
//    });
//    return result.value;
  };
}

//min
//sortBy
//groupBy
//sortedIndex
//shuffle
//toArray
//size

@end
