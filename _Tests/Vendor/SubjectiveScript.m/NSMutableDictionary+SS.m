//
//  NSMutableDictionary+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "NSMutableDictionary+SS.h"

@implementation NSMutableDictionary (Object)

+ (NSMutableDictionary*)new_
{
  return [NSMutableDictionary dictionary];
}

+ (NSMutableDictionary*(^)(const KVA values))kva
{
  return ^(const KVA values) {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    for (const id* value = (const id*) values; value[0] != nil; value+=2) {
      [result setValue:value[1] forKey:value[0]];
    }
    return result;
  };
}

+ (NSMutableDictionary*(^)(id key, id value))set
{
  return ^(id key, id value) {
    [self setValue:value forKey:key];
    return self;
  };
}

@end
