//
//  NSArray+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "NSArray+SS.h"
#import "NSNumber+SS.h"

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