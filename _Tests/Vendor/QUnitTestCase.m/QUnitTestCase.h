//
//  QUnitTestCase.h
//  QUnitTestCase.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

@interface QUnitTestCase : SenTestCase

- (void (^)(id actual, id expected, NSString *message, ...))equal;
- (void (^)(NSInteger actual, NSInteger expected, NSString *message, ...))equalI;
- (void (^)(BOOL result, NSString *message, ...))ok;

@end