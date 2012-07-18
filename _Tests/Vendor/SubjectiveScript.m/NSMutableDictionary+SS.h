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
+ (NSMutableDictionary*(^)(const KVA values, I count))kva;
+ (NSMutableDictionary*(^)(id key, id value))set;

@end

#define KV(...) {__VA_ARGS__}
#define _O(...) O.kva((KVA){__VA_ARGS__}, sizeof((KVA){__VA_ARGS__})/sizeof(id[2]))