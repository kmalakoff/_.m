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
#import "NSArray+SS.h"
#import "NSNumber+SS.h"
#import "SSArguments.h"
#import "SS+Types.h"

@implementation NSMutableArray (SS)

+ (A*)newArguments
{
  A* result = A.new;
  result.markAsArguments();
  return result;
}

+ (A*(^)(UI capacity))newC
{
  return ^(UI capacity) {
    return [A arrayWithCapacity:capacity];
  };
}

+ (A*(^)(id obj))newNSO
{
  return ^(id obj) {
    return [A arrayWithObject:obj];
  };
}

- (A*(^)())toMutable { return ^{ return self; }; }

- (A*(^)(id indexNumber, id value))set
{
  return ^(N* indexNumber, id value) {
    if (!value) value = NSNull.null;
    return self.setAt(indexNumber.I, value);
  };
}
- (A*(^)(I index, id value))setAt
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

@end
