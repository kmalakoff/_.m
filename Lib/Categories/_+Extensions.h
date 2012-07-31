//
//  _+Extensions.h
//  _.m
//
//  Created by Kevin Malakoff on 7/19/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_.h"

@interface _ (Extensions)

// TODO: add tests

// value
+ (B(^)(id obj))isTruthy;
+ (B(^)(id obj))isFalsy;
+ (B(^)(id obj))isDictionary;
+ (B(^)(id obj))isBlock;

// object
+ (_FindBlock(^)(NSS* key, id match))propTester;
+ (_FindBlock(^)(NSS* key, NSS* match))propStringTester;

// array
+ (void(^)(NSA* array, NSS* key, id value))setProps;
+ (A*(^)(NSA* array))classNames;

@end
