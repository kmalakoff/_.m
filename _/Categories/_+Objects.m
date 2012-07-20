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

//keys
//values
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
    if (_.isArray(obj) || _.isString(obj)) return obj.length == 0;
    if (_.isDictionary(obj)) return ((O*)obj).isEmpty();
    return (B) YES;
  }; 
}

//isElement

+ (B(^)(id obj))isArray  { return ^B(id obj) { return [obj isKindOfClass:[NSArray class]]; }; }
+ (B(^)(id obj))isObject { return ^B(id obj) { return _.isDictionary(obj) || _.isString(obj) || _.isArray(obj); }; }

//isArguments
//isFunction
+ (B(^)(id obj))isString { return ^B(id obj) { return [obj isKindOfClass:[NSString class]]; }; }
+ (B(^)(id obj))isNumber { return ^B(id obj) { return [obj isKindOfClass:[NSNumber class]]; }; }
//isFinite
//isBoolean
+ (B(^)(id obj))isDate { return ^B(id obj) { return [obj isKindOfClass:[NSDate class]]; }; }
//isRegExp
//isNaN
+ (B(^)(id obj))isNull   { return ^B(id obj) { return (obj==nil) || [obj isKindOfClass:[NSNull class]]; }; }
//isUndefined

// ADDED
+ (B(^)(id obj))isDictionary { return ^B(id obj) { return [obj isKindOfClass:[NSDictionary class]]; }; } 

+ (B(^)(id obj))isTruthy { return ^B(id obj) { return !_.isFalsy(obj); }; }
+ (B(^)(id obj))isFalsy { 
  return ^B(id obj) { 
    if (!obj) return YES;
    if (_.isNull(obj)) return YES;
    if (_.isNumber(obj)) return (((N*)obj).I == 0);  // TODO: handle correctly
    if (_.isArray(obj) || _.isDictionary(obj)) return !_.isEmpty(obj);
    
    // TODO: write test
    return NO;
  }; 
}

@end
