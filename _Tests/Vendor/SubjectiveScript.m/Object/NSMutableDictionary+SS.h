//
//  NSMutableDictionary+SS.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSObjectCreateWrapper.h"

@interface NSDictionary (SS)

- (BOOL (^)(id key))has;
- (id (^)(id key))get;

@end

@interface NSMutableDictionary (Object)

+ (NSMutableDictionary*)new_;
+ (SSObjectCreateWrapper*(^)(id key, id value))o_;

- (NSMutableDictionary* (^)(id key, id value))set;

@end

// alias
#define Object NSMutableDictionary
#define O NSMutableDictionary