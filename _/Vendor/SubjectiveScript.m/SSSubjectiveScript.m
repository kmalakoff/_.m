//
//  SSSubjectiveScript.m
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

#import "SSSubjectiveScript.h"
#import "NSArray+SS.h"
#import "NSDictionary+SS.h"
#import "NSString+SS.h"
#import "NSNumber+SS.h"
#import "NSDate+SS.h"

@implementation SS

+ (B(^)(id obj))isArray   { return ^(id obj) { return [obj isKindOfClass:[NSArray class]]; }; }
+ (B(^)(id obj))isObject  { return ^(id obj) { return [obj isKindOfClass:[NSDictionary class]]; }; } // TODO: document difference with Underscore definition
+ (B(^)(id obj))isString  { return ^(id obj) { return [obj isKindOfClass:[NSString class]]; }; }
+ (B(^)(id obj))isNumber  { return ^(id obj) { return [obj isKindOfClass:[NSNumber class]]; }; }
+ (B(^)(id obj))isDate    { return ^(id obj) { return [obj isKindOfClass:[NSDate class]]; }; }
+ (B(^)(id obj))isNull    { return ^(id obj) { return [obj isKindOfClass:[NSNull class]]; }; }

+ (NSString*(^)(id obj))toString
{
  return ^(id obj) {
    if(SS.isArray(obj)) {
      return ((NSArray*)obj).toString();
    }
    
    else if (SS.isObject(obj)) {
      return ((NSDictionary*)obj).toString();
    }
    
    else if (SS.isString(obj)) {
      return ((NSString*)obj).toString();
    }

    else if (SS.isNumber(obj)) {
      return ((NSNumber*)obj).toString();
    }

    else if (SS.isDate(obj)) {
      return ((NSDate*)obj).toString();
    }

    else if (SS.isNull(obj)) {
      return @"null";
    }
    
    else
      NSAssert(nil, @"object type unrecognized for toString");
    return @"error"; 
  };
}

@end
