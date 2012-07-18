//
//  NSMutableArray+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "NSMutableArray+SS.h"
#import "NSNumber+SS.h"

@implementation NSMutableArray (SS)

+ (NSMutableArray*)new_
{
  return [NSMutableArray array];
}

+ (NSMutableArray* (^)(const BA values, I count))ba
{
  return ^(const BA values, I count) {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger index=0; index<count; index++) {
      [result addObject:N.b(values[index])];
    }
    return result;
  };
}

+ (NSMutableArray* (^)(const IA values, I count))ia
{
  return ^(const IA values, I count) {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger index=0; index<count; index++) {
      [result addObject:N.i(values[index])];
    }
    return result;
  };
}

+ (NSMutableArray* (^)(const FA values, I count))fa
{
  return ^(const FA values, I count) {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger index=0; index<count; index++) {
      [result addObject:N.f(values[index])];
    }
    return result;
  };
}

+ (NSMutableArray* (^)(const OA values, I count))oa
{
  return ^(const OA values, I count) {
    return [NSMutableArray arrayWithObjects:values count:count];
  };
}

- (NSMutableArray* (^)(id))push
{
  return ^(id value) {
    [self addObject:value];
    return self;
  };
}

@end
