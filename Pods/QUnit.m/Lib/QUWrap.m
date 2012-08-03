//
//  QUWrap.m
//  QUnit.m
//
//  Created by Kevin Malakoff on 7/30/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
    case _C_LNG_LNG:
    case _C_ULNG_LNG:
      return [NSNumber numberWithInteger:(NSInteger)value];
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