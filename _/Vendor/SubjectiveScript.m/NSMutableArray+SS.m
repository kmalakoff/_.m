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
  result.setIsArguments();
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

// accessor Array functions
- (A*(^)(NSA* other))concat
{
  return ^(NSA* other) {
    A* result = self.mutableCopy;
    [result addObjectsFromArray:other];
    return result;
  };
}

// mutator Array functions
- (A*(^)(id))push
{
  return ^(id value) {
    [self addObject:value];
    return self;
  };
}

- (NSO*(^)())pop
{
  return ^() {
    id value = [self lastObject];
    [self removeLastObject];
    return value;
  };
}

- (A*(^)())reverse
{
  return ^{
    A* result = A.newC(self.count); 
    for (id item in self.reverseObjectEnumerator) {
      [result addObject:item];
    }
    return result;
  };
}

- (A*(^)(SSSortBlock iterator))sort
{
  return ^(SSSortBlock block) {
    if (SS.isBlock(block))
      [self sortUsingComparator:block];
    else
      [self sortUsingSelector:@selector(compare:)];
    return self;
  };
}

- (NSA*(^)(I start, I count, id item1, ... /* NIL_TERMINATED */))splice
{
  return ^(I start, I count, id item1, ... /* NIL_TERMINATED */) {
    ARGS_AO(items, item1);

    NSA* results;
    NSRange range = self.makeRange(start, count);
    if (range.length>0)
    {
      results = [self subarrayWithRange:range];
      [self removeObjectsInRange:range];
    }
    else
      results = NSA.new;

    for (id item in items.reverseObjectEnumerator)
      [self insertObject:item atIndex:0];

    return results;
  };
}

- (A*(^)(id item1, ...))unshift
{
  return ^(id item1, ...) {
    ARGS_AO(items, item1);
    for (id item in items.reverseObjectEnumerator)
      [self insertObject:item atIndex:0];

    return self;
  };
}

@end
