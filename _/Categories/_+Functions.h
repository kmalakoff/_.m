//
//  _+Functions.h
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

@interface _ (Functions)

//bind /* NOT SUPPORTED: JavaScript-only */
//bindAll /* NOT SUPPORTED: JavaScript-only */

+ (_MemoizedBlock /* NIL_TERMINATION */(^)(_MemoizeBlock func, _MemoizeHashBlock hasher))memoize;

+ (void(^)(_DelayBlock func, I waitNS))delay;
+ (void(^)(_DelayBlock func, I waitNS))delayBG; /* ADDED: BACKGROUND QUEUE */

+ (void(^)(_DeferBlock func))defer;
+ (void(^)(_DeferBlock func))deferBG; /* ADDED: BACKGROUND QUEUE */

+ (_ThrottledBlock(^)(_ThrottleBlock func, I waitNS, id arg1, ... /* NIL_TERMINATION */))throttle;

+ (_DebouncedBlock(^)(_DebounceBlock func, I waitNS, B immediate, id arg1, ... /* NIL_TERMINATION */))debounce;

+ (_OncedBlock(^)(_OnceBlock func, id arg1, ... /* NIL_TERMINATION */))once;

+ (_AfteredBlock /* NIL_TERMINATION */(^)(I times, _AfterBlock func, id arg1, ... /* NIL_TERMINATION */))after;

+ (_WrappedBlock /* NIL_TERMINATION */(^)(_WrappedBlock func, _WrapBlock wrapper))wrap;

+ (_ComposeBlock /* NIL_TERMINATION */(^)(_ComposeBlock func1, ... /* NIL_TERMINATION */))compose;

@end