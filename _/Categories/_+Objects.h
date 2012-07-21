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

//keys
//values
//functions
//extend
//pick
//defaults
//clone
//tap
//has

+ (B(^)(id a, id b))isEqual; // TODO: tests

+ (B(^)(NSO* obj))isEmpty;

//isElement

+ (B(^)(id obj))isArray;

+ (B(^)(id obj))isObject;

//isArguments
//isFunction

+ (B(^)(id obj))isString;

+ (B(^)(id obj))isNumber;

//isFinite
//isBoolean

+ (B(^)(id obj))isDate;

//isRegExp
//isNaN
+ (B(^)(N* obj))isNaN;

+ (B(^)(id obj))isNull;

//isUndefined

// ADDED
+ (B(^)(id obj))isDictionary;

@end
