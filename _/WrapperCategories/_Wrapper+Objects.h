//
//  _Wrapper+Objects.h
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

#import "_Wrapper.h"

@interface _Wrapper (Objects)

- (_Wrapper*(^)())keys;
- (_Wrapper*(^)())values;

- (_Wrapper*(^)())functions;
- (_Wrapper*(^)())methods;

- (_Wrapper*(^)(NSD* obj1, ... /* NIL_TERMINATION */))extend;

- (_Wrapper*(^)(id key1, ... /* NIL_TERMINATION */))pick;

- (_Wrapper*(^)(NSD* obj1, ... /* NIL_TERMINATION */))defaults;

- (_Wrapper*(^)())clone; /* RETURNS MUTABLE IF POSSIBLE */

- (_Wrapper*(^)(_TapBlock interceptor))tap;

- (_Wrapper*(^)(id key))has;

- (_Wrapper*(^)(id b))isEqual;

- (_Wrapper*(^)())isEmpty;

//isElement /* NOT SUPPORTED: JavaScript-only */

- (_Wrapper*(^)())isArray;

- (_Wrapper*(^)())isObject;

- (_Wrapper*(^)())isArguments;

- (_Wrapper*(^)(id target))isFunction;  /* DEFINITION: it is a block or you call @"fnName".apply(target, ... NIL_TERMINATION) or @"fnName".call(target, ... NIL_TERMINATION) it using a block property or static function. See NSString+SS.h */

- (_Wrapper*(^)())isString;

- (_Wrapper*(^)())isNumber;

- (_Wrapper*(^)())isFinite;

- (_Wrapper*(^)())isBoolean;

- (_Wrapper*(^)())isDate;

//isRegExp /* NOT SUPPORTED: JavaScript-only */

- (_Wrapper*(^)())isNaN;

- (_Wrapper*(^)())isNull;

//isUndefined /* NOT SUPPORTED: JavaScript-only */

@end
