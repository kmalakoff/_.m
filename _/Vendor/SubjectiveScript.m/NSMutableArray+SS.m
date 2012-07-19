//
//  NSMutableArray+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
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

#import "NSMutableArray+SS.h"
#import "NSNumber+SS.h"

@implementation NSMutableArray (SS)

+ (A*)new_
{
  return [A array];
}

+ (A*(^)(const B* values, I count))ba
{
  return ^(const B* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.b(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const I* values, I count))ia
{
  return ^(const I* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.i(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const UI* values, I count))uia
{
  return ^(const UI* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.ui(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const F* values, I count))fa
{
  return ^(const F* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.f(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const id* values))oa
{
  return ^(const id* values) {
    A* result = A.new_;
    
    for (const id* value=values; *value != nil; value+=2) {
      [result addObject:*value];
    }
    return result;
  };
}

- (A*(^)(id))push
{
  return ^(id value) {
    [self addObject:value];
    return self;
  };
}

@end
