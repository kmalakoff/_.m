//
//  QUWrap.m
//  QUnit.m
//
//  Created by Kevin Malakoff on 7/30/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "QUWrap.h"
#import <objc/runtime.h>

@implementation QUWrap

+ (id)wrap:(unsigned long long)value type:(char[2])type
{
  switch(type[0])
  {
    case _C_ID:
    case _C_PTR:
#if __has_feature(objc_arc)
      return (__bridge id)(void*)value;
#else
      return (id)value;
#endif
    case _C_UCHR:
    case _C_SHT:
    case _C_USHT:
    case _C_INT:
    case _C_UINT:
    case _C_LNG:
    case _C_ULNG:
      return [NSNumber numberWithInt:(NSInteger)value];
    case _C_CHR:
    case _C_BOOL:
      return [NSNumber numberWithBool:(BOOL)value];
    case _C_FLT:
      return [NSNumber numberWithFloat:(float)value];
    case _C_DBL:
      return [NSNumber numberWithDouble:(double)value];
    default:
      @throw [NSException exceptionWithName:@"TypeError" reason:@"QUnit: unsupported comparison type" userInfo:nil];
      return (id)nil;
  }
}

@end