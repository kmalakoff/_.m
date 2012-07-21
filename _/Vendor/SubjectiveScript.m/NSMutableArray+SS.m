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

+ (A*(^)(UI capacity))newWithCapacity
{
  return ^(UI capacity) {
    return [A arrayWithCapacity:capacity];
  };
}

+ (A*(^)(const B* values, I count))newB
{
  return ^(const B* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.B(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const I* values, I count))newI
{
  return ^(const I* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.I(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const UI* values, I count))newUI
{
  return ^(const UI* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.UI(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const F* values, I count))newF
{
  return ^(const F* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.F(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const id* values))newO
{
  return ^(const id* values) {
    A* result = A.new;
    for (const id* value=values; *value != nil; value++) {
      [result addObject:*value];
    }
    return result;
  };
}

- (A*(^)(I index, id value))set
{
  return ^(I index, id value) {
    // need to expand and fill the array
    if (index >= self.count) {
      for (I addIndex=self.count; addIndex<index; addIndex++)
        [self addObject:NSNull.null];
      [self addObject:value];
    }
    else
      [self replaceObjectAtIndex:index withObject:value];
    return self;
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
