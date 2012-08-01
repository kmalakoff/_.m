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
#import "_Wrapper.h"
#import "SubjectiveScript.h"

@implementation _ (Objects)

+ (NSA*(^)(NSD* obj))keys 
{
  return ^(NSD* obj) {
#ifdef DEBUG
    if (!obj) @throw [NSException exceptionWithName:@"TypeError" reason:@"keys expecting non-nil" userInfo:nil];
#endif

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
    return SS.functionNames(obj);
  };
}
+ (A*(^)(NSD* obj))methods { return _.functions; } // ALIAS 

+ (O*(^)(O* destination, NSD* source1, ... /* NIL_TERMINATION */))extend
{
  return ^(O* destination, NSD* source1, ... /* NIL_TERMINATION */) {
    ARGS_AO(sources, source1);

    _.each(sources, ^(NSD* source, ... /* KEY, LIST */) {
      [source enumerateKeysAndObjectsUsingBlock:^(id key, id value, B *stop) {
        [destination setObject:value forKey:key];
      }];
    });
    return destination;
  };
}

+ (O*(^)(O* obj, id key1, ... /* NIL_TERMINATION */))pick
{
  return ^(O* obj, id key1, ... /* NIL_TERMINATION */) {
    ARGS_AO(keys, key1);

    __block O* result = O.new;
    _.each(_.flatten(keys, true), ^(NSO* key, ... /* KEY, LIST */) {
      if (key.in(obj)) result.set(key, obj.get(key));
    });
    return result;
  };
}

+ (O*(^)(O* object, NSD* default1, ... /* NIL_TERMINATION */))defaults
{
  return ^(O* obj, NSD* default1, ... /* NIL_TERMINATION */) {
    ARGS_AO(defaults, default1);

    _.each(defaults, ^(NSD* source, ... /* KEY, LIST */) {
      [source enumerateKeysAndObjectsUsingBlock:^(NSO* key, id value, B *stop) {
        if (!key.in(obj)) [obj setObject:value forKey:key];
      }];
    });
    return obj;
  };
}

+ (NSO*(^)(NSO* obj))clone /* RETURNS MUTABLE IF POSSIBLE */
{
  return ^NSO*(NSO* obj) {
    if (!obj)
      return obj;
    else if ([obj respondsToSelector:@selector(mutableCopyWithZone:)])
      return obj.mutableCopy;
    else
      return obj.copy;
  };
}

+ (NSO*(^)(NSO* obj, _TapBlock interceptor))tap
{
{
  return ^(NSO* obj, _TapBlock interceptor) {
    interceptor(obj);
    return obj;
  };
}
}

+ (B(^)(NSO* obj, id key))has
{
  return ^(NSO* obj, id key) {
    return obj.hasOwnProperty(key);
  };
}

+ (B(^)(id a, id b))isEqual
{
  return ^B(id a, id b) {
    if ([a isKindOfClass:[_Wrapper class]]) // unwrap
      return _.isEqual(((_Wrapper*)a).value(), b);
    if ([b isKindOfClass:[_Wrapper class]]) // unwrap
      return _.isEqual(a, ((_Wrapper*)b).value());
  
    if (_.isNull(a) || _.isNull(b))
      return (a == b);

    if (_.isNumber(a) || _.isNumber(b)) {
      if ((!_.isNumber(a) || !_.isNumber(b)) || (strcmp(((N*)a).objCType, ((N*)b).objCType) != 0))
        return NO;
      else
        return [a isEqual:b];
    }

    // REVIEW: override functions needed?
//    if (_.isFunction(@"isEqual", a))
//      @"isEqual".apply(a, [A arrayWithObject:b]);
//    if (_.isFunction(@"isEqual", b))
//      @"isEqual".apply(b, [A arrayWithObject:a]);
    
    return [a isEqual:b];
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

//isElement /* NOT SUPPORTED: JavaScript-only */

+ (B(^)(id obj))isArray       { return ^B(id obj) { return [obj isKindOfClass:[NSArray class]]; }; }
+ (B(^)(id obj))isObject      { return ^B(id obj) { return _.isDictionary(obj) || _.isArray(obj) || _.isString(obj) || _.isFunction(obj, nil); }; }
+ (B(^)(id obj))isArguments   { return ^B(id obj) { return [obj isKindOfClass:[NSArray class]] && ((NSA*)obj).isArguments(); }; }

+ (B(^)(id obj, id target))isFunction  /* DEFINITION: it is a block or you call @"fnName".apply(obj, ... NIL_TERMINATION) or @"fnName".call(obj, ... NIL_TERMINATION) it using a block property or static function. See NSString+SS.h */
{
  return ^B(id obj, id target) { 
    return (_.isBlock(obj) ||(_.isString(obj) && !!SS.resolveFunction(target, obj)));
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

+ (B(^)(id obj))isBoolean     { return ^B(id obj) { return [obj isKindOfClass:[NSNumber class]] && ((N*)obj).isBoolean(); }; }

+ (B(^)(id obj))isDate        { return ^B(id obj) { return [obj isKindOfClass:[NSDate class]]; }; }

//isRegExp /* NOT SUPPORTED: JavaScript-only */

+ (B(^)(id obj))isNaN         { return ^B(N* obj) { return [obj isKindOfClass:[NSNumber class]] && [obj isEqualToNumber:[NSDecimalNumber notANumber]]; }; }

+ (B(^)(id obj))isNull        { return ^B(id obj) { return !obj || [obj isKindOfClass:[NSNull class]]; }; }

//isUndefined /* NOT SUPPORTED: JavaScript-only */

@end
