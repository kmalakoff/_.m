//
//  NSObject+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
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

#import "NSObject+SS.h"
#import "SS+Types.h"
#import "NSString+SS.h"
#import "NSArray+SS.h"

const NSS* SSTypeObject = @"object";

@implementation NSObject (SS)

- (const NSS*)typeof {return SSTypeObject; }
- (NSS*(^)())toString
{
  return ^() {
    if (SS.isNull(self)) return @"";
    return self.description;
  };
}
- (NSS*)className { return NSStringFromClass([self class]); }

// use dynamic type checking for some JavaScript operations to reduce manual casting
- (UI)length
{
  // base class can be triggered by KeyValueCoding
  if (SS.isArray(self)) return ((NSA*)self).count;
  if (SS.isString(self)) return ((NSS*)self).length;
  return 0;
}
- (S*(^)(NSS* separator))join
{
  NSAssert(nil, @"join not implemented for this type");
  return nil;
}

- (NSComparisonResult)compare:(NSO*)other
{
  if (SS.isString(self)) return [(NSS*)self compare:(NSS*)other];
  if (SS.isNumber(self)) return [(N*)self compare:(N*)other];
  NSAssert(nil, @"cannot compare the provided objects");
  return NSOrderedSame;
}

@end
