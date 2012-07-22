//
//  NSArray+SSArguments.m
//  _.m
//
//  Created by Kevin Malakoff on 7/22/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "NSArray+SSArguments.h"
#import "SS+Types.h"

@implementation NSArray (SSArguments)

- (NSO*(^)(I index))getArgAt
{
  return ^NSO*(I index) {
    if (index>=self.count) return nil;
    NSO* item = [self objectAtIndex:index];
    return SS.isNull(item) ? (NSO*) nil : item; 
  };
}

@end
