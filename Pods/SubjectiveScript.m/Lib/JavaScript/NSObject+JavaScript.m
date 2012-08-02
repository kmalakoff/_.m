//
//  NSObject+JavaScript.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/29/12.
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

#import "NSObject+JavaScript.h"
#import "NSObject+SS.h"
#import "SS+Types.h"

@implementation NSObject (JavaScript)

- (B(^)(Class class))instanceof {
  return ^(Class class) {
    return [self isKindOfClass:class];
  };
}
- (NSS*(^)())toString
{
  return ^{
    if (SS.isNull(self)) return @"";
    return self.description;
  };
}

// array
- (UI)length
{
  // base class can be triggered by KeyValueCoding
  if (SS.isArray(self)) return ((NSA*)self).count;
  if (SS.isString(self)) return ((NSS*)self).length;
  return 0;
}
- (S*(^)(NSS* separator))join
{
#ifdef DEBUG
    NSAssert(nil, @"join not implemented for this type");
#endif

  return nil;
}
- (A*(^)(id value))push
{
  return ^(NSO* obj) {
#ifdef DEBUG
    NSAssert(nil, @"push not implemented for this type");
#endif
    return A.new;
  };
}

// object
- (B(^)(id key))hasOwnProperty
{
  return ^B(id key) {
#ifdef DEBUG
    NSAssert(nil, @"hasOwnProperty not implemented for this type");
#endif
    return false;
  };
}

- (B(^)(NSO* obj))in
{
  return ^B(NSO* obj) {
    return obj.get(self) != nil;
  };
}

// string
- (NSS*(^)(NSS* string))add
{
  return ^(NSS* string) {
#ifdef DEBUG
    NSAssert(nil, @"add not implemented for this type");
#endif
    return string;
  };
}

- (S*(^)(NSS* string))append
{
  return ^(NSS* string) {
#ifdef DEBUG
    NSAssert(nil, @"append not implemented for this type");
#endif
    return string.mutableCopy;
  };
}

@end
