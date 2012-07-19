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

+ (void(^)(id obj, _IteratorBlock block))each
{
  return ^(id obj, _IteratorBlock block) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or null");

    if (_.isNull(obj))
      return;

    else if (_.isArray(obj)) {
      NSArray* array = obj;
      if(!array.count) return;

      NSInteger count = [array count];
      for (NSInteger index=0; index<count; index++) {
        block([array objectAtIndex:index], [N numberWithInteger:index]);
      }
    }
    else {
      NSDictionary *dictionary = obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
          block(value, key);
      }];
    }
  };
}
+ (void(^)(id obj, _IteratorBlock block))forEach { return self.each; }  // alias
+ (void(^)(id obj, _IteratorWithContextBlock block, id context))eachWithContext
{
  return ^(id obj, _IteratorWithContextBlock block, id context){
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or null");

    if (_.isNull(obj))
      return;

    else if (_.isArray(obj)) {
      NSArray* array = obj;
      if(!array.count) return;

      NSInteger count = [array count];
      for (NSInteger index=0; index<count; index++) {
        block([array objectAtIndex:index], [N numberWithInteger:index], context);
      }
    }
    else {
      NSDictionary *dictionary = obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
          block(value, key, context);
      }];
    }
  };
}

+ (id(^)(id obj, _MapBlock block))map
{
  return ^(id obj, _MapBlock block) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or null");

    if (_.isNull(obj))
      return A.new_;

    else if (_.isArray(obj)) {
      NSArray* array = obj;
      if(!array.count) return A.new_;

      A* result = [A arrayWithCapacity:array.count];
      NSInteger count = [array count];
      for (NSInteger index=0; index<count; index++) {
        id mapped = block([array objectAtIndex:index], [N numberWithInteger:index]);
        if (mapped)
          [result addObject:mapped];
      }

      return result;
    }
    else {
      NSDictionary *dictionary = obj;
      O* result = O.new_;

      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        id mapped = block(value, key);
        if (mapped)
          [result setObject:mapped forKey:key];
      }];
      
      return (id) result;
    }
    
    return nil;
  };
}
+ (id(^)(id obj, _MapBlock block))collect { return self.map; }
+ (id(^)(id obj, _MapWithContextBlock block, id context))mapWithContext
{
  return ^(id obj, _MapWithContextBlock block, id context) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or null");

    if (_.isNull(obj))
      return A.new_;

    else if (_.isArray(obj)) {
      NSArray* array = obj;
      if(!array.count) return A.new_;

      A* result = [A arrayWithCapacity:array.count];
      NSInteger count = [array count];
      for (NSInteger index=0; index<count; index++) {
        id mapped = block([array objectAtIndex:index], [N numberWithInteger:index], context);
        if (mapped)
          [result addObject:mapped];
      }

      return result;
    }
    else {
      NSDictionary *dictionary = obj;
      O* result = O.new_;

      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        id mapped = block(value, key, context);
        if (mapped)
          [result setObject:mapped forKey:key];
      }];
      
      return (id) result;
    }
    
    return nil;
  };
}

@end
