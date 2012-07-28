//
//  SS+JavaScript.m
//  _.m
//
//  Created by Kevin Malakoff on 7/22/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SS+JavaScript.h"
#import "SSJSON.h"
#import "SSArguments.h"
#import "SS+Types.h"
#import "NSArray+SS.h"
#import "NSMutableArray+SS.h"
#import <objc/message.h>

typedef id(^SSBlock0)();
typedef id(^SSBlock1)(id arg1, ...);
typedef id(^SSBlock2)(id arg1, id arg2, ...);
typedef id(^SSBlock3)(id arg1, id arg2, id arg3, ...);
typedef id(^SSBlock4)(id arg1, id arg2, id arg3, id arg4, ...);
typedef id(^SSBlock5)(id arg1, id arg2, id arg3, id arg4, id arg5, ...);
typedef id(^SSBlock6)(id arg1, id arg2, id arg3, id arg4, id arg5, id arg6, ...);

@implementation SS (JavaScript)

+ (SSJSON*)JSON
{
  static SSJSON* json = nil;
  if(!json) json = [SSJSON sharedInstance]; 

  return json;
}

+ (id(^)(id block, id arg1, ... /* NIL_TERMINATED*/))call
{
  return ^(id block, id arg1, ... /* NIL_TERMINATED*/) {
    ARGS_AO(arguments, arg1);

    return SS.apply(block, arguments);
  };
}

+ (id(^)(id block, NSA* arguments))apply
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

@implementation NSObject (JavaScript)

// modified from: http://stackoverflow.com/questions/330030/list-selectors-for-obj-c-object
- (A*(^)())functionNames
{
  return ^{
    __block A* results = A.new;
    
    // check the dictionary
    if (SS.isObject(self))
    {
      NSD* dictionary = (NSD*) self;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if (SS.isBlock(value))
          results.push(key);
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

@end

@implementation NSString (JavaScript)

- (id(^)(id target, id arg1, ... /* NIL_TERMINATED*/))call
{
  return ^id(id target, id arg1, ... /* NIL_TERMINATED*/) {
    ARGS_AO(arguments, arg1);
    
    id scriptFunction = self.getScriptFunctionBlock(target);
    if (!scriptFunction) {
      NSLog(@"function '%@' did not exist for call", self);
      return nil;
    }

    return SS.apply(scriptFunction, arguments);
  };
}

- (id(^)(id target, NSA* arguments))apply
{
  return ^id(id target, NSA* arguments) {
    id scriptFunction = self.getScriptFunctionBlock(target);
    if (!scriptFunction) {
      NSLog(@"function '%@' did not exist for apply", self);
      return nil;
    }

    return SS.apply(scriptFunction, arguments);
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
