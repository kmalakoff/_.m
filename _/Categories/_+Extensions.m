//
//  _+Extensions.m
//  _.m
//
//  Created by Kevin Malakoff on 7/19/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
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
    if (_.isNumber(obj)) return !(((N*)obj).boolValue);
    if (_.isArray(obj) || _.isDictionary(obj)) return !_.isEmpty(obj);
    if (_.isString(obj)) return !(((NSS*)obj).length);
    
    // TODO: write test
    return NO;
  }; 
}

// object
+ (B(^)(id obj))isDictionary  { return ^B(id obj) { return [obj isKindOfClass:[NSDictionary class]]; }; } 
+ (B(^)(id obj))isBlock       { return ^B(id obj) { return [obj isKindOfClass:NSClassFromString(@"NSBlock")]; }; } 

+ (_ValueTestBlock(^)(NSString* key, id match))propTester;
{
  return ^(NSString* key, id match) {
    return ^BOOL(id object) 
    {
      NSString *value = [object valueForKey:key];
      return (value == match);
    };
  };
}

+ (_ValueTestBlock(^)(NSString* key, NSString *match))propStringTester;
{
  return ^(NSString* key, NSString *match) {
    return ^BOOL(id object) 
    {
      NSString *value = [object valueForKey:key];
      return ([value isEqualToString:match]);
    };
  };
}

// array
+ (void(^)(NSA* array, NSString* key, id value))setProps;
{
  return ^(NSA* array, NSString* key, id value) {
    _.each(array, ^(NSObject *obj, id keyj){ 
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
