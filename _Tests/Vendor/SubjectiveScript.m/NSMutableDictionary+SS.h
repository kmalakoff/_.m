//
//  NSMutableDictionary+SS.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSTypes.h"

@interface NSMutableDictionary (SS)

+ (NSMutableDictionary*)new_;
+ (NSMutableDictionary*(^)(const KVA values))kva; // TODO: NS_REQUIRES_NIL_TERMINATION
+ (NSMutableDictionary*(^)(id key, id value))set;

@end

#define _O(...) O.kva((KVA){__VA_ARGS__, nil})