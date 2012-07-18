//
//  NSDictionary+SS.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SS)

- (BOOL (^)(id key))has;
- (id (^)(id key))get;

@end