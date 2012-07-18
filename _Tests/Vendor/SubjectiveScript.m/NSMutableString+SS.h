//
//  NSMutableString+SS.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (SS)

+ (NSMutableString*)new_;
+ (NSMutableString*(^)(NSString *value))s;
+ (NSMutableString*(^)(NSString *format, ...))f;
- (NSMutableString* (^)(NSString* value))add;

@end