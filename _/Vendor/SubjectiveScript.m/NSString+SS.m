//
//  NSString+SS.m
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

#import "NSString+SS.h"
#import "NSMutableString+SS.h"
#import "NSMutableArray+SS.h"
#import "SS+JavaScript.h"
#import "SubjectiveScript.h"

const NSS* SSTypeString = @"string";

@implementation NSString (SS)

+ (NSS*(^)(NSS* value))newS
{
  return ^(NSS* value) {
    return [NSString stringWithString:value];
  };
}

+ (NSS*(^)(NSA* array))newA
{
  return ^(NSA* array) {
    // JavaScript flattens the arrays and then joins them
    A* flattened = array.flatten();
    return flattened.join(@",");
  };
}

+ (NSS*(^)(NSS* format, ...))newFormatted
{
  return ^(NSS* format, ...) {
    va_list args;
    va_start(args, format);
    NSString *result = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return result;
  };
}

- (const NSS*)typeof { return SSTypeString; }
- (NSS*(^)())toString { return ^{ return self; }; }

- (NSO*(^)(I index))getAt
{
  return ^(I index) {
    return [self substringWithRange:NSMakeRange(index, 1)];
  };
}

- (NSA*(^)(NSS* separator))split
{
  return ^NSA*(NSS* separator) {
    // split on nothing means get the characters
    if (!separator || !separator.length)
    {
      UI count = self.length;
      A *characters = A.newC(count);
      for (I index=0; index<count; index++) {
        characters.push([self substringWithRange:NSMakeRange(index, 1)]);
      }
      return characters;
    }
    else
      return [self componentsSeparatedByString:separator];
  };
}
- (S*(^)(NSS* value))add
{
  return ^(NSS* value) {
    S* result = self.mutableCopy;
    [result appendString:value];
    return result;
  };
}

@end
