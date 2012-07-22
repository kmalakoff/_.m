//
//  NSArray+SSArguments.h
//  _.m
//
//  Created by Kevin Malakoff on 7/22/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SSTypes.h"

@interface NSArray (SSArguments)

- (NSO*(^)(I index))getArgAt;

@end
