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

- (B(^)())valueB
{
  return ^{
    if (_.isBoolean(self._wrapped)) return ((N*)self._wrapped).boolValue;
    NSLog(@"valueB is not a boolean");
    return NO;
  };
}

- (I(^)())valueI
{
  return ^{
    if ([self._wrapped isKindOfClass:[NSNumber class]]) return ((N*)self._wrapped).integerValue;
    NSLog(@"valueI is not a NSNumber");
    return 0;
  };
}

- (UI(^)())valueUI
{
  return ^UI{
    if ([self._wrapped isKindOfClass:[NSNumber class]]) return ((N*)self._wrapped).unsignedIntegerValue;
    NSLog(@"valueUI is not a NSNumber");
    return 0;
  };
}

- (F(^)())valueF
{
  return ^{
    if ([self._wrapped isKindOfClass:[NSNumber class]]) return ((N*)self._wrapped).floatValue;
    NSLog(@"valueF is not a NSNumber");
    return 0.0f;
  };
}

- (N*(^)())valueN
{
  return ^{
    if ([self._wrapped isKindOfClass:[NSNumber class]]) return (N*)self._wrapped;
    NSLog(@"valueN is not a NSNumber");
    return (N*)nil;
  };
}

- (NSS*(^)())valueNSS
{
  return ^{
    if ([self._wrapped isKindOfClass:[NSString class]]) return (NSS*)self._wrapped;
    NSLog(@"valueNSS is not a NSString");
    return (NSS*)nil;
  };
}

- (S*(^)())valueS
{
  return ^{
    if ([self._wrapped isKindOfClass:[NSMutableString class]]) return (S*)self._wrapped;
    if ([self._wrapped isKindOfClass:[NSString class]]) return (S*)self._wrapped.mutableCopy;
    NSLog(@"valueS is not a NSMutableString");
    return (S*)nil;
  };
}

- (NSA*(^)())valueNSA
{
  return ^{
    if ([self._wrapped isKindOfClass:[NSArray class]]) return (NSA*)self._wrapped;
    NSLog(@"valueNSA is not a NSArray");
    return (NSA*)nil;
  };
}

- (A*(^)())valueA
{
  return ^{
    if ([self._wrapped isKindOfClass:[NSMutableArray class]]) return (A*)self._wrapped;
    if ([self._wrapped isKindOfClass:[NSArray class]]) return (A*)self._wrapped.mutableCopy;
    NSLog(@"valueA is not a NSMutableArray");
    return (A*)nil;
  };
}

- (NSD*(^)())valueNSD
{
  return ^{
    if ([self._wrapped isKindOfClass:[NSDictionary class]]) return (NSD*)self._wrapped;
    NSLog(@"valueNSD is not a NSDictionary");
    return (NSD*)nil;
  };
}

- (O*(^)())valueO
{
  return ^{
    if ([self._wrapped isKindOfClass:[NSMutableDictionary class]]) return (O*)self._wrapped;
    if ([self._wrapped isKindOfClass:[NSDictionary class]]) return (O*)self._wrapped.mutableCopy;
    NSLog(@"valueO is not a NSMutableDictionary");
    return (O*)nil;
  };
}

@end
