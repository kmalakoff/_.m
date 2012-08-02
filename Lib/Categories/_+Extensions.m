//
//  _+Extensions.m
//  _.m
//
//  Created by Kevin Malakoff on 7/19/12.
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

#import "_+Extensions.h"
#import "_+Objects.h"
#import "_+Collections.h"
#import "SubjectiveScript.h"

@implementation _ (Extensions)

+ (B(^)(id obj))isTruthy { return ^B(id obj) { return !_.isFalsy(obj); }; }
+ (B(^)(id obj))isFalsy { 
  return ^B(id obj) { 
    if (_.isNull(obj)) return YES;
    if (_.isNumber(obj)) return !((N*)obj).B;
    if (_.isArray(obj) || _.isDictionary(obj)) return _.isEmpty(obj);
    if (_.isString(obj)) return !(((NSS*)obj).length);
    
    // TODO: write test
    return NO;
  }; 
}

// object
+ (B(^)(id obj))isDictionary  { return ^B(id obj) { return [obj isKindOfClass:[NSDictionary class]]; }; } 
+ (B(^)(id obj))isBlock       { return ^B(id obj) { return [obj isKindOfClass:NSClassFromString(@"NSBlock")]; }; } 

+ (_ItemTestBlock(^)(NSString* key, id match))valueTester;
{
  return ^(NSString* key, id match) {
    return ^B(NSD* obj, ...)
    {
      id value = [obj valueForKey:key];
      return [value isEqual:match];
    };
  };
}

+ (_ItemTestBlock(^)(NSString* key, NSString *match))valueStringTester;
{
  return ^(NSString* key, NSString *match) {
    return ^B(NSD* obj, ...)
    {
      NSString *value = [obj valueForKey:key];
      return [value isEqualToString:match];
    };
  };
}

// array
+ (void(^)(NSA* array, NSString* key, id value))setProps;
{
  return ^(NSA* array, NSString* key, id value) {
    _.each(array, ^(NSObject *obj, ... /* KEY, LIST */){
      [obj setValue:value forKey:key];
    });
  };
}

+ (A*(^)(NSA* array))classNames;
{
  return ^(NSA* array) {
    A* result = A.new;
    for (NSO* obj in array)
      result.push(obj.className);
    return result;
  };
}

@end
