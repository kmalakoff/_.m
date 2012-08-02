//
//  SS+Functions.m
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

#import "SS+Functions.h"
#import "SSArguments.h"
#import "SS+Types.h"
#import "NSArray+SS.h"
#import <objc/message.h>

typedef id(^SSBlock0)();
typedef id(^SSBlock1)(id arg1, ...);
typedef id(^SSBlock2)(id arg1, id arg2, ...);
typedef id(^SSBlock3)(id arg1, id arg2, id arg3, ...);
typedef id(^SSBlock4)(id arg1, id arg2, id arg3, id arg4, ...);
typedef id(^SSBlock5)(id arg1, id arg2, id arg3, id arg4, id arg5, ...);
typedef id(^SSBlock6)(id arg1, id arg2, id arg3, id arg4, id arg5, id arg6, ...);

@implementation SS (Functions)

+ (A*(^)(NSO* obj))functionNames
{
  return ^(NSO* obj){
    __block A* results = A.new;
    
    // check the dictionary
    if (SS.isObject(obj))
    {
      NSD* dictionary = (NSD*) obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, B *stop) {
        if (SS.isBlock(value))
          [results addObject:key];
      }];
    }
    
    // REVIEW: should I support properties?
    
    // REVIEW: should I support functions? (some internal methods crash)
//    Method* methodlist = class_copyMethodList(object_getClass(self), &count);
//
//    UI count = 0;
//    for(I index=0;index<count;index++) {
//      // only JavaScript-style properties
//      if (method_getNumberOfArguments(methodlist[index]) != 2) continue;
//      char* returnType = method_copyReturnType(methodlist[index]);
//      SEL methodSelector = method_getName(methodlist[index]);
//      NSString *name = NSStringFromSelector(methodSelector);
//      if ([name hasPrefix:@"_"]) continue; // skip internal
//      @try {
//        id propertyOrBlock = objc_msgSend(self, methodSelector);
//        if (SS.isBlock(propertyOrBlock)) results.push(NSStringFromSelector(methodSelector));
//      }
//      @catch (NSException* e) {
//      }
//    }
    return results;
  };
}

+ (id(^)(id target, NSS* functionName))resolveFunction
{
  return ^id(id target, NSS* functionName) {
    // assume only JavaScript-style block methods or properties are used
    id propertyOrBlock;
    SEL methodSelector = NSSelectorFromString(functionName);
    if ([target respondsToSelector:methodSelector])
      propertyOrBlock = objc_msgSend(target, methodSelector);
    else
      propertyOrBlock = [target valueForKey:functionName];
    
    return SS.isBlock(propertyOrBlock) ? propertyOrBlock : nil;
  };
}

+ (id(^)(id block, NSA* arguments))callFunction
{
  return ^id(id block, NSA* arguments) {
    // REVIEW: is there a safer and more flexible way to call blocks by signature?
    switch(arguments.count) {
      case 0: return ((SSBlock0)block)();
      case 1: return ((SSBlock1)block)(arguments.getArgAt(0), nil);
      case 2: return ((SSBlock2)block)(arguments.getArgAt(0), arguments.getArgAt(1), nil);
      case 3: return ((SSBlock3)block)(arguments.getArgAt(0), arguments.getArgAt(1), arguments.getArgAt(2), nil);
      case 4: return ((SSBlock4)block)(arguments.getArgAt(0), arguments.getArgAt(1), arguments.getArgAt(2), arguments.getArgAt(3), nil);
      case 5: return ((SSBlock5)block)(arguments.getArgAt(0), arguments.getArgAt(1), arguments.getArgAt(2), arguments.getArgAt(3), arguments.getArgAt(4), nil);
      case 6: return ((SSBlock6)block)(arguments.getArgAt(0), arguments.getArgAt(1), arguments.getArgAt(2), arguments.getArgAt(3), arguments.getArgAt(4), arguments.getArgAt(5), nil);
      default:
#ifdef DEBUG
        NSAssert(nil, @"number of parameters not yet supported for apply");
#endif 

        return nil;
    }
  };
}

@end
