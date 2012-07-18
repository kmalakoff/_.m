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

+ (NSMutableDictionary*(^)(const KVA values, I count))kva
{
  return ^(const KVA values, I count) {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (NSInteger index=0; index<count; index++) {
      [result setValue:values[index][1] forKey:values[index][0]];
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
