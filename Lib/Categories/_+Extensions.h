//
//  _+Extensions.h
//  _.m
//
//  Created by Kevin Malakoff on 7/19/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_.h"

@interface _ (Extensions)

// value
+ (B(^)(id obj))isTruthy;
+ (B(^)(id obj))isFalsy;
+ (B(^)(id obj))isDictionary;
+ (B(^)(id obj))isBlock;

// object
+ (_ItemTestBlock(^)(NSS* key, id match))valueTester;
+ (_ItemTestBlock(^)(NSS* key, NSS* match))valueStringTester;

// array
+ (void(^)(NSA* array, NSS* key, id value))setProps;
+ (A*(^)(NSA* array))classNames;

@end
