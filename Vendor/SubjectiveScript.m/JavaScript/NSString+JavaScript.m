//
//  NSString+JavaScript.m
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

#import "NSString+JavaScript.h"
#import "NSMutableArray+JavaScript.h"
#import "SSArguments.h"
#import "SS+Functions.h"

@implementation NSString (JavaScript)

- (NSS*(^)())toString { return ^{ return self; }; }

- (NSA*(^)(NSS* separator))split
{
  return ^NSA*(NSS* separator) {
    // split on nothing means get the characters
    if (!separator || !separator.length)
    {
      UI count = self.length;
      A *characters = A.newC(count);
      for (I index=0; index<count; index++) {
        unichar character = [self characterAtIndex:index];
        characters.push([NSString stringWithCharacters:&character length:1]);
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

- (id(^)(id target, id arg1, ... /* NIL_TERMINATED*/))call
{
  return ^id(id target, id arg1, ... /* NIL_TERMINATED*/) {
    ARGS_AO(arguments, arg1);
    
    id scriptFunction = SS.resolveFunction(target, self);
    if (!scriptFunction) {
      NSLog(@"function '%@' did not exist for call", self);
      return nil;
    }

    return SS.callFunction(scriptFunction, arguments);
  };
}

- (id(^)(id target, NSA* arguments))apply
{
  return ^id(id target, NSA* arguments) {
    id scriptFunction = SS.resolveFunction(target, self);
    if (!scriptFunction) {
      NSLog(@"function '%@' did not exist for apply", self);
      return nil;
    }

    return SS.callFunction(scriptFunction, arguments);
  };
}

@end
