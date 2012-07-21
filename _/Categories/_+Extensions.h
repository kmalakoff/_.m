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

// object
+ (_TestBlock(^)(NSS* key, id match))propTester;
+ (_TestBlock(^)(NSS* key, NSS* match))propStringTester;

// array
+ (void(^)(NSA* array, NSS* key, id value))setProps;
+ (A*(^)(NSA* array))classNames;

@end
