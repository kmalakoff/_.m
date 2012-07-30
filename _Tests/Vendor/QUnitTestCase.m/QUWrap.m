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

+ (id)wrap:(void*)value type:(char[2])type
{
  NSAssert(type[0]!=_C_FLT && type[0]!=_C_DBL, @"QUnit current doesn't support floats and doubles");

  switch(type[0])
  {
    case _C_ID:
#if __has_feature(objc_arc)
      return (__bridge id)value;
#else
      return (id)value;
#endif
    case _C_INT:
      return [NSNumber numberWithInt:(int)value];
    case _C_UINT:
      return [NSNumber numberWithUnsignedInt:(unsigned int)value];
    case _C_LNG:
      return [NSNumber numberWithInteger:(NSInteger)value];
    case _C_ULNG:
      return [NSNumber numberWithUnsignedInteger:(NSUInteger)value];
    case _C_CHR:
      return [NSNumber numberWithBool:(BOOL)value];
    default:
#if __has_feature(objc_arc)
      return (__bridge id)value;
#else
      return (id)value;
#endif
  }
}

@end