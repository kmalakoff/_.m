//
//  NSMutableString+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "NSMutableString+SS.h"
#import "SSArrayCreateWrapper+Private.h"

@implementation NSMutableString (SS)

+ (NSMutableString*)new_
{
  return [NSMutableString string];
}

+ (NSMutableString*(^)(NSString *value))s
{
  return ^(NSString *value) {
    return [NSMutableString stringWithString:value];
  };
}

//+ (SSArrayCreateWrapper*(^)(id))s_
//{
//  return ^(id value) {
//    return [[SSArrayCreateWrapper alloc] initWithArray:[NSMutableString arrayWithObject:value]];
//  };
//}

+ (NSMutableString*(^)(NSString *format, ...))f
{
  return ^(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return result;
  };
}

- (NSMutableString* (^)(NSString *value))add
{
  return ^(NSString *value) {
    [self appendString:value];
    return self;
  };
}

@end
