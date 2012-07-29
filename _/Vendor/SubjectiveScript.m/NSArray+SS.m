//
//  NSArray+SS.m
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

#import "NSArray+SS.h"
#import "NSMutableArray+SS.h"
#import "NSNumber+SS.h"
#import "NSMutableString+SS.h"
#import "NSObject+SS.h"
#import "SS+Types.h"
#import "SS+Number.h"
#import <objc/runtime.h>

static const NSS* SSTypeArguments = @"arguments";
static char* const SSIsArgumentsKey = "IsArguments";

@implementation NSArray (SS)

+ (A*(^)(UI count))newSparse
{
  return ^(UI count) {
    A* result = [A arrayWithCapacity:count];
    id value = NSNull.null;
    for (UI index=0; index<count; index++) {
      [result addObject:value];
    }
    return result;
  };
}

+ (A*(^)(const B* values, UI count))newB
{
  return ^(const B* values, UI count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.B(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const I* values, UI count))newI
{
  return ^(const I* values, UI count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.I(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const UI* values, UI count))newUI
{
  return ^(const UI* values, UI count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.UI(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const F* values, UI count))newF
{
  return ^(const F* values, UI count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.F(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const id* values /* NIL_TERMINATION */))newO
{
  return ^(const id* values) {
    A* result = A.new;
    for (const id* value=values; *value != nil; value++) {
      [result addObject:*value];
    }
    return result;
  };
}

- (NSS*)mutableClassName { return NSStringFromClass([S class]); }
- (A*(^)())toMutable { return ^{ return self.mutableCopy; }; }
- (NSS*(^)())toString { return ^{ return S.newFormatted(@"[%@]", self.join(@",")); }; }
- (UI)length { return self.count; }

- (B)isArguments { return objc_getAssociatedObject(self, SSIsArgumentsKey) != nil; } 
- (void(^)())setIsArguments { return ^{ objc_setAssociatedObject(self, SSIsArgumentsKey, SSTypeArguments, OBJC_ASSOCIATION_ASSIGN); }; } // set the stored key

- (B(^)(id key))hasOwnProperty
{
  return ^B(id key) {
    N* indexNumber = ((N*)key);
  
    // requesting a property
    if ([key isKindOfClass:[NSString class]])
      indexNumber = SS.parseInt((NSS*)key);
    if (!indexNumber) return false;

    I index = indexNumber.I;
    return (index >=0) && (index < self.count);
  };
}

- (NSO*(^)(UI index))getAt
{
  return ^NSO*(UI index) {
    return index>=self.count ? nil : [self objectAtIndex:index];
  };
}

- (NSO*(^)(UI index))getArgAt
{
  return ^NSO*(UI index) {
    if (index>=self.count) return nil;
    id value = [self objectAtIndex:index];
    if ([value isKindOfClass:[NSNull class]]) return nil;
    return value;
  };
}

// accessor Array functions
- (A*(^)(NSA* other))concat
{
  return ^(NSA* other) {
    return ((A*)self.mutableCopy).concat(other);
  };  
}

- (S*(^)(NSS* separator))join
{ 
  return ^(NSS* separator) { 
    S* result = S.new;
    UI count = self.count;
    
    for (I index=0; index<count; index++) {
      NSO* item = [self objectAtIndex:index];
      if (index>0) result.append(separator);

      // JavaScript collapses arrays on join only if they do not contain other arrays and there are multiple elements. A bit quirky, but supported.
      if ((index>0) && SS.isArray(item) && (((NSA*)item).count==1)) {
        B hasArrays = NO;
        for (NSO* subitem in (NSA*)item) {
          if (SS.isArray(subitem)) {
            hasArrays = YES;
            break;
          }
        }
        if(hasArrays)
          result.append(item.toString());
        else
          result.append(item.join(separator));
      }
      else
        result.append(item.toString());
    }
    return result;
  }; 
}

- (NSA*(^)(I start, I count))slice
{
  return ^(I start, I count) {
    NSRange range = self.makeRange(start, count);
    if (range.length<=0) return NSA.new;
    return [self subarrayWithRange:range];
  };
}

- (A*(^)())reverse
{
  return ^{
    return ((A*)self.mutableCopy).reverse();
  };
}

- (A*(^)())flatten
{
  return ^{
    A* output = A.new;
    for (id value in self) {
      if (SS.isArray(value))
        [output addObjectsFromArray:((NSA*)value).flatten()];
      else
        output.push(value);
    }
    return output;
  };
}

- (NSRange(^)(I start, I count))makeRange
{
  return ^(I start, I count) {
    if ((start + count)>self.length-1) count = self.length - start; // clamp to end of array
    return NSMakeRange(start, count);
  };
}

@end