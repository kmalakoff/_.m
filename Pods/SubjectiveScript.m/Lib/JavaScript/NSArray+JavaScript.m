//
//  NSArray+JavaScript.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/29/12.
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

#import "NSArray+JavaScript.h"
#import "NSArray+SS.h"
#import "NSMutableString+JavaScript.h"
#import "NSObject+JavaScript.h"
#import "NSString+SS.h"
#import "NSNumber+SS.h"
#import "SS+JavaScript.h"
#import "SS+Types.h"

@implementation NSArray (JavaScript)

- (NSS*(^)())toString { return ^{ return S.newFormatted(@"[%@]", self.join(@",")); }; }
- (UI)length { return self.count; }
- (B(^)(id key))hasOwnProperty
{
  return ^B(id key) {
    N* indexNumber = (N*)key;
  
    // requesting a property
    if ([key isKindOfClass:[NSString class]])
      indexNumber = SS.parseInt((NSS*)key);
    if (!indexNumber) return false;

    I index = indexNumber.I;
    return (index >=0) && (index < self.count);
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
    NSRange range = self.resolveRange(start, count);
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

+ (A*)flatten:(NSA*)array shallow:(B)shallow output:(A*)output
{
  for (id value in array) {
    if (SS.isArray(value)) {
      shallow ? [output addObjectsFromArray:value] : (void) [self flatten:value shallow:shallow output:output];
    } else {
      output.push(value);
    }
  }
  
  return output;
}

- (A*(^)(B shallow))flatten
{
  return ^(B shallow){
    A* output = A.new;
    [NSArray flatten:self shallow:shallow output:output];
    return output;
  };
}

@end
