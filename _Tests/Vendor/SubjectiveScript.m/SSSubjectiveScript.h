//
//  SSSubjectiveScript.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SS

+ (BOOL(^)(id obj))isArray;
+ (BOOL(^)(id obj))isObject;
+ (BOOL(^)(id obj))isString;
+ (BOOL(^)(id obj))isNumber;
+ (BOOL(^)(id obj))isNull;

@end
