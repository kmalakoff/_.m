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
#import "_Constants.h"
#import "SubjectiveScript.h"

@implementation _ (Arrays)

+ (id(^)(NSArray *array, NSInteger n))first
{
  return ^id(NSArray *array, NSInteger n) {
    if (n==_NoneInt)
      return array.count? [array objectAtIndex:0] : nil; 
    else
      return array.count? [array subarrayWithRange:NSMakeRange(0, MIN(n, array.count))] : [NSArray array];
  };
}

+ (id(^)(NSArray *array, NSInteger n))head { return self.first; } // alias
+ (id(^)(NSArray *array, NSInteger n))take { return self.first; } // alias

//+ (NSArray*(^)(NSArray *array))initial
//{
//  return ^(NSArray *array) {
//    return A.new_;
//  };
//}
//
//+ (id (^)(NSArray *array, NSUInteger n))last
//{
//  return ^(NSArray *array, NSUInteger n) {
//    return A.new_;
//  };
//}
//
//+ (NSArray*(^)(NSArray *array, NSUInteger n))rest
//{
//  return ^(NSArray *array, NSUInteger n) {
//    return A.new_;
//  };
//}
//+ (NSArray*(^)(NSArray *array, NSUInteger n))tail { return self.rest; } // alias
//
//
//+ (NSArray*(^)(NSArray *array))compact
//{
//  return ^(NSArray *array) {
//    return A.new_;
//  };
//}
//
//+ (NSArray*(^)(NSArray *array, BOOL shallow))flatten
//{
//  return ^(NSArray *array, BOOL shallow) {
//    return A.new_;
//  };
//}
//
//+ (NSArray*(^)(NSArray *array, NSArray *values))without
//{
//  return ^(NSArray *array, NSArray *values) {
//    return A.new_;
//  };
//}
//
//+ (NSArray*(^)(NSArray *arrays))union
//{
//  return ^(NSArray *arrays) {
//    return A.new_;
//  };
//}
//
//+ (NSArray*(^)(NSArray *arrays))intersection
//{
//  return ^(NSArray *arrays) {
//    return A.new_;
//  };
//}
//
//+ (NSArray*(^)(NSArray *array, NSArray *arrays))difference
//{
//  return ^(NSArray *array, NSArray *arrays) {
//    return A.new_;
//  };
//}
//
//+ (id (^)(NSArray *array, BOOL isSorted, _MapBlock iterator))uniq
//{
//  return ^(NSArray *array, BOOL isSorted, _MapBlock iterator) {
//    return A.new_;
//  };
//}
//+ (id (^)(NSArray *array, BOOL isSorted, _MapBlock iterator))unique { return self.uniq; } // alias
//
//+ (NSArray*(^)(NSArray *arrays))zip
//{
//  return ^(NSArray *arrays) {
//    return A.new_;
//  };
//}
//
//+ (NSInteger (^)(NSArray *array, id value, BOOL isSorted))indexOf
//{
//  return ^(NSArray *array, id value, BOOL isSorted) {
//    return -1;
//  };
//}
//
//+ (NSInteger (^)(NSArray *array, id value))lastIndexOf
//{
//  return ^(NSArray *array, id value) {
//    return -1;
//  };
//}
//
//+ (NSArray* (^)(NSInteger start, NSInteger stop, NSInteger step))range
//{
//  return ^(NSInteger start, NSInteger stop, NSInteger step) {
//    return A.new_;
//  };
//}

@end
