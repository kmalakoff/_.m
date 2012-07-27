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
#import "_+Arrays.h"
#import "_+Collections.h"
#import "_+Extensions.h"
#import "SubjectiveScript.h"

@implementation _ (Objects)

+ (NSA*(^)(NSD* obj))keys 
{
  return ^(NSD* obj) {
    return obj.allKeys;
  };
}

+ (NSA*(^)(NSD* obj))values 
{
  return ^(NSD* obj) {
    return obj.allValues;
  };
}

+ (A*(^)(NSD* obj))functions 
{
  return ^(NSD* obj) {
    return obj.functionNames();
  };
}
+ (A*(^)(NSD* obj))methods { return _.functions; } // ALIAS 

+ (O*(^)(O* obj, NSD* obj1, ...))extend
{
  return ^(O* obj, NSD* obj1, ...) {
    ARGS_AO(objects, obj1);

    _.each(objects, ^(NSD* source, ...) {
      [source enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [obj setObject:value forKey:key];
      }];
    });
    return obj;
  };
}

+ (O*(^)(O* obj, id key1, ...))pick
{
  return ^(O* obj, id key1, ...) {
    ARGS_AO(keys, key1);

    __block O* result = O.new;
    _.each(_.flatten(keys, true), ^(NSO* key, ...) {
      if (key.in(obj)) result.set(key, obj.get(key));
    });
    return result;
  };
}

+ (O*(^)(O* obj, NSD* obj1, ...))defaults
{
  return ^(O* obj, NSD* obj1, ...) {
    ARGS_AO(objects, obj1);

    _.each(objects, ^(NSD* source, ...) {
      [source enumerateKeysAndObjectsUsingBlock:^(NSO* key, id value, BOOL *stop) {
        if (!key.in(obj)) [obj setObject:value forKey:key];
      }];
    });
    return obj;
  };
}

+ (NSO*(^)(NSO* obj))clone
{
  return ^(NSO* obj) {
    return obj.copy;
  };
}

//tap /* NOT SUPPORTED: JavaScript-only */

+ (B(^)(NSO* obj, id key))has
{
  return ^(NSO* obj, id key) {
    return obj.hasOwnProperty(key);
  };
}

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

//isElement /* NOT SUPPORTED: JavaScript-only */

+ (B(^)(id obj))isArray       { return ^B(id obj) { return [obj isKindOfClass:[NSArray class]]; }; }
+ (B(^)(id obj))isObject      { return ^B(id obj) { return _.isDictionary(obj) || _.isString(obj) || _.isArray(obj); }; }
+ (B(^)(id obj))isArguments   { return ^B(id obj) { return [obj isKindOfClass:[NSArray class]] && ((NSA*)obj).isArguments; }; }

+ (B(^)(id obj, id target))isFunction  /* DEFINITION: you call @"fnName".apply(obj, ...) or @"fnName".call(obj, ...) it using a block property or static function. See NSString+SS.h */
{
  return ^B(id obj, id target) { 
    return (_.isString(obj) && !!((NSS*)obj).getScriptFunctionBlock(target)); 
  };
}

+ (B(^)(id obj))isString      { return ^B(id obj) { return [obj isKindOfClass:[NSString class]]; }; }
+ (B(^)(id obj))isNumber      { return ^B(id obj) { return [obj isKindOfClass:[NSNumber class]]; }; }
+ (B(^)(id obj))isFinite      
{ 
  return ^B(id obj) { 
    return (
      _.isNumber(obj) && 
      !_.isNaN(obj) && 
      ([(N*)obj compare:NF_POS_INFINITY] != NSOrderedSame) &&
      ([(N*)obj compare:NF_NEG_INFINITY] != NSOrderedSame)
    );
  }; 
}

+ (B(^)(id obj))isBoolean     { return ^B(id obj) { return [obj isKindOfClass:[NSNumber class]] && ((N*)obj).isBoolean; }; }

+ (B(^)(id obj))isDate        { return ^B(id obj) { return [obj isKindOfClass:[NSDate class]]; }; }

//isRegExp /* NOT SUPPORTED: JavaScript-only */

+ (B(^)(N* obj))isNaN         { return ^B(N* obj) { return [obj isEqualToNumber:[NSDecimalNumber notANumber]]; }; }

+ (B(^)(id obj))isNull        { return ^B(id obj) { return !obj || [obj isKindOfClass:[NSNull class]]; }; }

//isUndefined /* NOT SUPPORTED: JavaScript-only */

@end
