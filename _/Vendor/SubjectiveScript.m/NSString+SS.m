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
#import "SubjectiveScript.h"
#import <objc/message.h>

typedef id(^SSBlock0)();
typedef id(^SSBlock1)(id arg1);
typedef id(^SSBlock2)(id arg1, id arg2);
typedef id(^SSBlock3)(id arg1, id arg2, id arg3);
typedef id(^SSBlock4)(id arg1, id arg2, id arg3, id arg4);
typedef id(^SSBlock5)(id arg1, id arg2, id arg3, id arg4, id arg5);
typedef id(^SSBlock6)(id arg1, id arg2, id arg3, id arg4, id arg5, id arg6);

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
- (NSS*(^)())toString { return ^() { return self; }; }

- (NSO*(^)(I index))getAt
{
  return ^(I index) {
    return [self substringWithRange:NSMakeRange(index, 1)];
  };
}

- (id(^)(id target, id arg1, ...))call
{
  return ^(id target, id arg1, ...) {
    AO_ARGS(arguments, arg1);
    return self.apply(target, arguments);
  };
}

- (id(^)(id target, NSA* arguments))apply
{
  return ^id(id target, NSA* arguments) {
    id scriptFunction = self.getScriptFunctionBlock(target);
    if (!scriptFunction) {
      NSLog(@"function '%@' did not exist for call or apply", self);
      return nil;
    }

    // TODO: figure out a safe way to call blocks by signature
    switch(arguments.length) {
      case 0: return ((SSBlock0)scriptFunction)();
      case 1: return ((SSBlock1)scriptFunction)(arguments.getAt(0));
      case 2: return ((SSBlock2)scriptFunction)(arguments.getAt(0), arguments.getAt(1));
      case 3: return ((SSBlock3)scriptFunction)(arguments.getAt(0), arguments.getAt(1), arguments.getAt(2));
      case 4: return ((SSBlock4)scriptFunction)(arguments.getAt(0), arguments.getAt(1), arguments.getAt(2), arguments.getAt(3));
      case 5: return ((SSBlock5)scriptFunction)(arguments.getAt(0), arguments.getAt(1), arguments.getAt(2), arguments.getAt(3), arguments.getAt(4));
      case 6: return ((SSBlock6)scriptFunction)(arguments.getAt(0), arguments.getAt(1), arguments.getAt(2), arguments.getAt(3), arguments.getAt(4), arguments.getAt(5));
      default:
        NSAssert(nil, @"number of parameters not yet supported for apply");
        return nil;
    }
  };
}
- (id(^)(id target))getScriptFunctionBlock
{
  return ^id(id target) {
    // assume only JavaScript-style block methods or properties are used
    id propertyOrBlock;
    SEL methodSelector = NSSelectorFromString(self);
    if ([target respondsToSelector:methodSelector])
      propertyOrBlock = objc_msgSend(target, methodSelector);
    else
      propertyOrBlock = [target valueForKey:self];
    
    return SS.isBlock(propertyOrBlock) ? propertyOrBlock : nil;
  };
}


@end
