//
//  SSSubjectiveScript.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SSSubjectiveScript.h"

@implementation SS

+ (BOOL(^)(id obj))isArray  { return ^(id obj) { return [obj isKindOfClass:[NSArray class]]; }; }
+ (BOOL(^)(id obj))isObject { return ^(id obj) { return [obj isKindOfClass:[NSDictionary class]]; }; }
+ (BOOL(^)(id obj))isString { return ^(id obj) { return [obj isKindOfClass:[NSString class]]; }; }
+ (BOOL(^)(id obj))isNumber { return ^(id obj) { return [obj isKindOfClass:[NSNumber class]]; }; }
+ (BOOL(^)(id obj))isNull   { return ^(id obj) { return [obj isKindOfClass:[NSNull class]]; }; }

@end
