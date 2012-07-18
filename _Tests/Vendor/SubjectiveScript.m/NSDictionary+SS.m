//
//  NSDictionary+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "NSDictionary+SS.h"

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
