//
//  SS+JavaScript.h
//  _.m
//
//  Created by Kevin Malakoff on 7/22/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SS.h"
#import "SSJSON.h"

@interface SS (JavaScript)

+ (SSJSON*)JSON;

+ (id(^)(id block, id arg1, ...))call;
+ (id(^)(id block, NSA* arguments))apply;

@end

@interface NSObject (JavaScript)

- (A*(^)())functionNames;

@end

@interface NSString (JavaScript)

- (id(^)(id target, id arg1, ...))call;
- (id(^)(id target, NSA* arguments))apply;
- (id(^)(id target))getScriptFunctionBlock;

@end