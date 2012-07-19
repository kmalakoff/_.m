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
#import "SubjectiveScript.h"

@implementation _ (Arrays)

+ (id(^)(NSArray* array, N* n))first
{
  return ^id(NSArray* array, N* n) {
    return (n != nil) ? array.slice(0, n.i) : array.get(0);
  };
}

+ (id(^)(NSArray* array, N* n))head { return self.first; } // alias
+ (id(^)(NSArray* array, N* n))take { return self.first; } // alias

//+ (NSArray*(^)(NSArray* array, N* n))initial
//{
//  return ^(NSArray* array) {
//    return A.new_;
//  };
//}
//
//+ (id (^)(NSArray* array, NSUInteger n))last
//{
//  return ^(NSArray* array, NSUInteger n) {
//    return A.new_;
//  };
//}
//
+ (NSArray*(^)(NSArray* array, N* index))rest
{
  return ^(NSArray* array, N* index) {
    return array.slice((index == nil) ? 1 : index.i, array.length);
  };
}
+ (NSArray*(^)(NSArray* array, N* index))tail { return self.rest; } // alias
//
//
//+ (NSArray*(^)(NSArray* array))compact
//{
//  return ^(NSArray* array) {
//    return A.new_;
//  };
//}
//
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

//+ (NSArray*(^)(NSArray* array, id value1, ...))without
//{
//  return ^(NSArray* array, NSArray* values) {
//    return A.new_;
//  };
//}
//
//+ (NSArray*(^)(NSArray* array1, ...))union
//{
//  return ^(NSArray* arrays) {
//    return A.new_;
//  };
//}
//
//+ (NSArray*(^)(NSArray* array1, ...))intersection
//{
//  return ^(NSArray* arrays) {
//    return A.new_;
//  };
//}
//
//+ (NSArray*(^)(NSArray* array, NSArray* array1, ...))difference
//{
//  return ^(NSArray* array, NSArray* arrays) {
//    return A.new_;
//  };
//}
//
//+ (id (^)(NSArray* array, B isSorted, _MapBlock iterator))uniq
//{
//  return ^(NSArray* array, B isSorted, _MapBlock iterator) {
//    return A.new_;
//  };
//}
//+ (id (^)(NSArray* array, B isSorted, _MapBlock iterator))unique { return self.uniq; } // alias
//
//+ (NSArray*(^)(NSArray* array1, NSArray* array2, ...))zip
//{
//  return ^(NSArray* arrays) {
//    return A.new_;
//  };
//}
//
//+ (I (^)(NSArray* array, id value, B isSorted))indexOf
//{
//  return ^(NSArray* array, id value, B isSorted) {
//    return -1;
//  };
//}
//
//+ (I (^)(NSArray* array, id value))lastIndexOf
//{
//  return ^(NSArray* array, id value) {
//    return -1;
//  };
//}
//
//+ (NSArray* (^)(I start, I stop, I step))range
//{
//  return ^(I start, I stop, I step) {
//    return A.new_;
//  };
//}

@end
