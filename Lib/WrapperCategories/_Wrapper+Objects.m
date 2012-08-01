//
//  _Wrapper+Objects.m
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

#import "_Wrapper+Objects.h"
#import "_+Objects.h"
#import "_+Collections.h"
#import "_+Extensions.h"
#import "_+Arrays.h"
#import "SubjectiveScript.h"

@implementation _Wrapper (Objects)

- (_Wrapper*(^)())keys
{
  return ^() {
    return _.chain(_.keys(self.NSD));
  };
}

- (_Wrapper*(^)())values
{
  return ^() {
    return _.chain(_.values(self.NSD));
  };
}

- (_Wrapper*(^)())functions
{
  return ^() {
    return _.chain(_.functions(self.NSD));
  };
}

- (_Wrapper*(^)())methods
{
  return ^() {
    return _.chain(_.methods(self.NSD));
  };
}

- (_Wrapper*(^)(NSD* source1, ... /* NIL_TERMINATION */))extend
{
  return ^(NSD* source1, ... /* NIL_TERMINATION */) {
#ifdef DEBUG
      NSAssert(_.isDictionary(self.value()), @"sort expecting NSDictionary");
#endif
    O* obj = self.O;
    if (!obj) return self;

    ARGS_AO(sources, source1);
    
    _.each(sources, ^(NSD* source, ... /* KEY, LIST */) {
      [source enumerateKeysAndObjectsUsingBlock:^(id key, id value, B *stop) {
        [obj setObject:value forKey:key];
      }];
    });
    return self;
  };
}

- (_Wrapper*(^)(id key1, ... /* NIL_TERMINATION */))pick
{
  return ^(id key1, ... /* NIL_TERMINATION */) {
#ifdef DEBUG
      NSAssert(_.isDictionary(self.value()), @"sort expecting NSDictionary");
#endif
    O* obj = self.O;
    if (!obj) return self;

    ARGS_AO(keys, key1);

    __block O* result = O.new;
    _.each(_.flatten(keys, true), ^(NSO* key, ... /* KEY, LIST */) {
      if (key.in(obj)) result.set(key, obj.get(key));
    });
    return _.chain(result);
  };
}

- (_Wrapper*(^)(NSD* default1, ... /* NIL_TERMINATION */))defaults
{
  return ^(NSD* default1, ... /* NIL_TERMINATION */) {
#ifdef DEBUG
      NSAssert(_.isDictionary(self.value()), @"sort expecting NSDictionary");
#endif
    O* obj = self.O;
    if (!obj) return self;

    ARGS_AO(defaults, default1);

    _.each(defaults, ^(NSD* source, ... /* KEY, LIST */) {
      [source enumerateKeysAndObjectsUsingBlock:^(NSO* key, id value, B *stop) {
        if (!key.in(obj)) [obj setObject:value forKey:key];
      }];
    });
    return _.chain(obj);
  };
}

- (_Wrapper*(^)())clone /* RETURNS MUTABLE IF POSSIBLE */
{
  return ^() {
    return _.chain(_.clone(self.value()));
  };
}

- (_Wrapper*(^)(_TapBlock interceptor))tap
{
  return ^(_TapBlock interceptor) {
    _.tap(self.value(), interceptor);
    return self;
  };
}

- (_Wrapper*(^)(id key))has
{
  return ^(id key) {
    return _.chain(N.B(_.has(self.value(), key)));
  };
}

- (_Wrapper*(^)(id b))isEqual
{
  return ^(id b) {
    return _.chain(N.B(_.isEqual(self.value(), b)));
  };
}

- (_Wrapper*(^)())isEmpty
{
  return ^() {
    return _.chain(N.B(_.isEmpty(self.value())));
  };
}

//isElement /* NOT SUPPORTED: JavaScript-only */

- (_Wrapper*(^)())isArray
{
  return ^() {
    return _.chain(N.B(_.isArray(self.value())));
  };
}

- (_Wrapper*(^)())isObject
{
  return ^() {
    return _.chain(N.B(_.isObject(self.value())));
  };
}

- (_Wrapper*(^)())isArguments
{
  return ^() {
    return _.chain(N.B(_.isArguments(self.value())));
  };
}

- (_Wrapper*(^)(id target))isFunction  /* DEFINITION: it is a block or you call @"fnName".apply(target, ... NIL_TERMINATION) or @"fnName".call(target, ... NIL_TERMINATION) it using a block property or static function. See NSString+SS.h */
{
  return ^(id target) {
    return _.chain(N.B(_.isFunction(self.value(), target)));
  };
}

- (_Wrapper*(^)())isString
{
  return ^() {
    return _.chain(N.B(_.isString(self.value())));
  };
}

- (_Wrapper*(^)())isNumber
{
  return ^() {
    return _.chain(N.B(_.isNumber(self.value())));
  };
}

- (_Wrapper*(^)())isFinite
{
  return ^() {
    return _.chain(N.B(_.isFinite(self.value())));
  };
}

- (_Wrapper*(^)())isBoolean
{
  return ^() {
    return _.chain(N.B(_.isBoolean(self.value())));
  };
}

- (_Wrapper*(^)())isDate
{
  return ^() {
    return _.chain(N.B(_.isDate(self.value())));
  };
}

//isRegExp /* NOT SUPPORTED: JavaScript-only */

- (_Wrapper*(^)())isNaN
{
  return ^() {
    return _.chain(N.B(_.isNaN(self.value())));
  };
}

- (_Wrapper*(^)())isNull
{
  return ^() {
    return _.chain(N.B(_.isNull(self.value())));
  };
}

//isUndefined /* NOT SUPPORTED: JavaScript-only */

@end
