//
//  NSDictionary+NamedProperties.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/31/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NamedProperties)

+ (void)setupNamedProperties;
+ (BOOL)resolveNamedProperties:(SEL)selector;

@end

#define IMPLEMENT_NAMED_PROPERTIES \
  +(void)initialize { [self setupNamedProperties]; } \
  +(BOOL)resolveInstanceMethod:(SEL)selector { return [self resolveNamedProperties:selector]; }
