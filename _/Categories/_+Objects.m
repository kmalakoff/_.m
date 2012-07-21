//
//  _+Objects.m
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

#import "_+Objects.h"
#import "SubjectiveScript.h"

@implementation _ (Objects)

+ (NSA*(^)(NSD* obj))keys {
  return ^(NSD* obj) {
    return obj.allKeys;
  };
}

+ (NSA*(^)(NSD* obj))values {
  return ^(NSD* obj) {
    return obj.allValues;
  };
}

//functions
//extend
//pick
//defaults
//clone
//tap
//has

+ (B(^)(id a, id b))isEqual
{
  return ^(id a, id b) {
    return (B) [a isEqual:b];
  };
}

+ (B(^)(NSO* obj))isEmpty  { 
  return ^B(NSO* obj) {
    if (obj == nil) return YES;
    // TODO: why doesn't this work: if (_.isArray(obj) || _.isString(obj)) return obj.length == 0;
    if (_.isArray(obj)) return ((NSA*)obj).count == 0;
    if (_.isString(obj)) return ((NSS*)obj).length == 0;
    if (_.isDictionary(obj)) return ((O*)obj).isEmpty();
    return (B) YES;
  }; 
}

//isElement

+ (B(^)(id obj))isArray  { return ^B(id obj) { return [obj isKindOfClass:[NSArray class]]; }; }
+ (B(^)(id obj))isObject { return ^B(id obj) { return _.isDictionary(obj) || _.isString(obj) || _.isArray(obj); }; }

//isFunction
+ (B(^)(id obj))isString { return ^B(id obj) { return [obj isKindOfClass:[NSString class]]; }; }
+ (B(^)(id obj))isNumber { return ^B(id obj) { return [obj isKindOfClass:[NSNumber class]]; }; }
//isFinite

+ (B(^)(id obj))isBoolean { return ^B(id obj) { return [obj isKindOfClass:[NSNumber class]] && ((N*)obj).isBoolean; }; }

+ (B(^)(id obj))isDate { return ^B(id obj) { return [obj isKindOfClass:[NSDate class]]; }; }
//isRegExp

+ (B(^)(N* obj))isNaN { return ^B(N* obj) { return [obj isEqualToNumber:[NSDecimalNumber notANumber]]; }; }

+ (B(^)(id obj))isNull   { return ^B(id obj) { return (obj==nil) || [obj isKindOfClass:[NSNull class]]; }; }
//isUndefined

// ADDED
+ (B(^)(id obj))isDictionary { return ^B(id obj) { return [obj isKindOfClass:[NSDictionary class]]; }; } 

@end
