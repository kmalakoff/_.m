//
//  _+Objects.h
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

#import "_.h"

@interface _ (Objects)

+ (NSA*(^)(NSD* obj))keys;
+ (NSA*(^)(NSD* obj))values;

//functions
//extend
//pick
//defaults
//clone
//tap

+ (B(^)(NSO* obj, id key))has;

+ (B(^)(id a, id b))isEqual;

+ (B(^)(NSO* obj))isEmpty;

//isElement /* NOT SUPPORTED: JavaScript-only */

+ (B(^)(id obj))isArray;

+ (B(^)(id obj))isObject;

+ (B(^)(id obj))isArguments;

+ (B(^)(id obj, id target))isFunction;  /* DEFINITION: you call @"fnName".apply(target, ...) or @"fnName".call(target, ...) it using a block property or static function. See NSString+SS.h */

+ (B(^)(id obj))isString;

+ (B(^)(id obj))isNumber;

+ (B(^)(id obj))isFinite;

+ (B(^)(id obj))isBoolean;

+ (B(^)(id obj))isDate;

//isRegExp /* NOT SUPPORTED: JavaScript-only */

+ (B(^)(N* obj))isNaN;

+ (B(^)(id obj))isNull;

//isUndefined /* NOT SUPPORTED: JavaScript-only */

/* ADDED */
+ (B(^)(id obj))isDictionary;
+ (B(^)(id obj))isBlock;

@end