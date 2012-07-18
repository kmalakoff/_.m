//
//  NSMutableArray+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "NSMutableArray+SS.h"
#import "SSArrayCreateWrapper+Private.h"

@implementation NSArray (SS)

- (NSInteger)length
{
  return [self count];
}

- (id (^)(NSInteger))get
{
  return ^(NSInteger index) {
    return [self objectAtIndex:index];
  };
}

- (NSString* (^)(NSString *separator))join
{
  return ^(NSString *separator) {
    return [self componentsJoinedByString:separator];
  };
}

@end

@implementation NSMutableArray (SS)

+ (NSMutableArray*)new_
{
  return [NSMutableArray array];
}

+ (SSArrayCreateWrapper*(^)(id))a_
{
  return ^(id value) {
    return [[SSArrayCreateWrapper alloc] initWithArray:[NSMutableArray arrayWithObject:value]];
  };
}

+ (NSMutableArray* (^)(NSInteger values[], NSInteger length))newWithIntegers
{
  return [NSMutableArray array];
}

- (NSMutableArray* (^)(id))push
{
  return ^(id value) {
    [self addObject:value];
    return self;
  };
}

@end
