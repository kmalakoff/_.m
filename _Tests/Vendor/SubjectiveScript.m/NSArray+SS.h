//
//  NSArray+SS.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSTypes.h"

@interface NSArray (SS)

- (NSInteger)length;
- (id (^)(NSInteger index))get;
- (NSString* (^)(NSString *separator))join;

@end