//
//  NSNumber+SS.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (SS)

+ (NSNumber*(^)(BOOL value))b;
- (BOOL)b;

+ (NSNumber*(^)(NSInteger value))i;
- (NSInteger)i;

+ (NSNumber*(^)(float value))f;
- (float)f;

@end