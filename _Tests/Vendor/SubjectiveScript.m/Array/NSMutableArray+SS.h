//
//  NSMutableArray+SS.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSArrayCreateWrapper.h"

@interface NSArray (SS)

- (NSInteger)length;
- (id (^)(NSInteger index))get;
- (NSString* (^)(NSString *separator))join;

@end

@interface NSMutableArray (SS)

+ (NSMutableArray*)new_;
+ (SSArrayCreateWrapper* (^)(id value))a_;
+ (NSMutableArray* (^)(NSInteger values[], NSInteger length))newWithIntegers;

- (NSMutableArray* (^)(id value))push;

@end

// aliases
#define A       NSMutableArray

#define Ai1(_1)         ((NSMutableArray*)[NSMutableArray arrayWithObject:N.i(_1)])
#define Ai3(_1,_2,_3)   ((NSMutableArray*)[NSMutableArray arrayWithObjects:N.i(_1), N.i(_2), N.i(_3), nil])