//
//  NSNumber+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "NSNumber+SS.h"
#import "SSArrayCreateWrapper+Private.h"

@implementation NSNumber (SS)

+ (NSNumber*(^)(BOOL value))b;
{
  return ^(BOOL value) {
    return [NSNumber numberWithBool:value];
  };
}
- (BOOL)b { return self.boolValue; }

+ (NSNumber*(^)(NSInteger))i
{
  return ^(NSInteger value) {
    return [NSNumber numberWithInt:value];
  };
}
- (NSInteger)i { return self.integerValue; }

+ (NSNumber*(^)(float value))f
{
  return ^(float value) {
    return [NSNumber numberWithFloat:value];
  };
}
- (float)f { return self.floatValue; }

@end
