//
//  _Wrapper.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
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

#import "_Wrapper.h"
#import "_Wrapper+Private.h"
#import "_+Objects.h"

@interface _Wrapper ()

@property (readwrite, retain) NSO* _wrapped;

@end

@implementation _Wrapper

@synthesize _wrapped;

- (_Wrapper*(^)())chain
{
  return ^{
    return _.chain(self._wrapped);
  };
}

- (NSO*(^)())value
{
  return ^{
    return self._wrapped;
  };
}

- (B)B
{
  if (_.isBoolean(self._wrapped)) return ((N*)self._wrapped).boolValue;
  NSLog(@"B is not a boolean");
  return NO;
}

- (I)I
{
  if ([self._wrapped isKindOfClass:[NSNumber class]]) return ((N*)self._wrapped).integerValue;
  NSLog(@"I is not a NSNumber");
  return 0;
}

- (UI)UI
{
  if ([self._wrapped isKindOfClass:[NSNumber class]]) return ((N*)self._wrapped).unsignedIntegerValue;
  NSLog(@"UI is not a NSNumber");
  return 0;
}

- (F)F
{
  if ([self._wrapped isKindOfClass:[NSNumber class]]) return ((N*)self._wrapped).floatValue;
  NSLog(@"F is not a NSNumber");
  return 0.0f;
}

- (N*)N
{
  if ([self._wrapped isKindOfClass:[NSNumber class]]) return (N*)self._wrapped;
  NSLog(@"N is not a NSNumber");
  return nil;
}

- (NSS*)NSS
{
  if ([self._wrapped isKindOfClass:[NSString class]]) return (NSS*)self._wrapped;
  NSLog(@"NSS is not a NSString");
  return nil;
}

- (S*)S
{
  if ([self._wrapped isKindOfClass:[NSMutableString class]]) return (S*)self._wrapped;
  if ([self._wrapped isKindOfClass:[NSString class]]) return (S*)self._wrapped.mutableCopy;
  NSLog(@"S is not a NSMutableString");
  return nil;
}

- (NSA*)NSA
{
  if ([self._wrapped isKindOfClass:[NSArray class]]) return (NSA*)self._wrapped;
  NSLog(@"NSA is not a NSArray");
  return nil;
}

- (A*)A
{
  if ([self._wrapped isKindOfClass:[NSMutableArray class]]) return (A*)self._wrapped;
  if ([self._wrapped isKindOfClass:[NSArray class]]) return (A*)self._wrapped.mutableCopy;
  NSLog(@"A is not a NSMutableArray");
  return nil;
}

- (NSD*)NSD
{
  if ([self._wrapped isKindOfClass:[NSDictionary class]]) return (NSD*)self._wrapped;
  NSLog(@"NSD is not a NSDictionary");
  return nil;
}

- (O*)O
{
  if ([self._wrapped isKindOfClass:[NSMutableDictionary class]]) return (O*)self._wrapped;
  if ([self._wrapped isKindOfClass:[NSDictionary class]]) return (O*)self._wrapped.mutableCopy;
  NSLog(@"O is not a NSMutableDictionary");
  return nil;
}

- (Date*)Date
{
  if ([self._wrapped isKindOfClass:[NSDate class]]) return (Date*)self._wrapped;
  NSLog(@"O is not a NSDate");
  return nil;
}

@end
