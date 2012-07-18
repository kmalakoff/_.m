//
//  NSMutableDictionary+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "NSMutableDictionary+SS.h"
#import "SSObjectCreateWrapper+Private.h"

@implementation NSDictionary (SS)

- (BOOL (^)(id))has
{
  return ^(id key) {
    return (BOOL) ([self objectForKey:key]!=nil);
  };
}

- (id (^)(id))get
{
  return ^(id key) {
    return [self objectForKey:key];
  };
}

@end

@implementation NSMutableDictionary (Object)

+ (NSMutableDictionary*)new_
{
  return [NSMutableDictionary dictionary];
}

+ (SSObjectCreateWrapper*(^)(id, id))o_
{
  return ^(id key, id value) {
    return [[SSObjectCreateWrapper alloc] initWithDictionary:[NSMutableDictionary dictionaryWithObject:value forKey:key]];
  };
}

- (NSMutableDictionary* (^)(id, id))set
{
  return ^(id key, id value) {
    [self setValue:value forKey:key];
    return self;
  };
}

@end
