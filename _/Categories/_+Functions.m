//
//  _+Functions.m
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

#import "_+Functions.h"
#import "_+Utility.h"
#import "_+Objects.h"
#import "SubjectiveScript.h"

@implementation _ (Functions)

//bind /* NOT SUPPORTED: JavaScript-only */
//bindAll /* NOT SUPPORTED: JavaScript-only */

+ (_MemoizeBlock(^)(_MemoizeBlock func, _MemoizeBlock hasher))memoize
{
  return ^(_MemoizeBlock func, _MemoizeBlock hasher) {
    O* memo = O.new;
    if (!hasher) hasher = ^id(id arg1, ...) {
      return arg1;
    };
    
    return ^(id arg1, ...){
      ARGS_AO(arguments, arg1);

      // requires at least one argument to match the block signature (id arg1, ...)
      if (arguments.length < 1) arguments.push(NSNull.null);

      id key = SS.apply(hasher, arguments);
      if (_.has(memo, key))
        return memo.get(key);

      id value = SS.apply(func, arguments);
      memo.set(key, value);
      return value;
    };
  };
}

+ (void(^)(_DelayBlock func, I wait))delay
{
  return ^(_DelayBlock func, I wait) {
    // TODO: add arguments
    SS.dispatchMain(func, wait);
  };
}

+ (void(^)(_DelayBlock func, I wait))delayBG
{
  return ^(_DelayBlock func, I wait) {
    SS.dispatchBackground(func, wait);
  };
}

+ (void(^)(_DeferBlock func))defer 
{ 
  return ^(_DeferBlock func) {
    SS.dispatchMain(func, 0);
  };
}

+ (void(^)(_DeferBlock func))deferBG
{ 
  return ^(_DeferBlock func) {
    SS.dispatchBackground(func, 0);
  };
}

+ (_ThrottledBlock(^)(_ThrottleBlock func, I waitNS, id arg1, ...))throttle
{
  return ^(_ThrottleBlock func, I waitNS, id arg1, ...) {
    ARGS_AO(arguments, arg1);

    __block B throttling;
    __block B more;

    _DebouncedBlock whenDone = _.debounce(^(/* MANDATORY */ id arg1, ...){ more = throttling = false; }, waitNS, /* MANDATORY */ false, /* NIL TERMINATED */ nil);
    return ^{
      id result;
      __block SSTimeout* timeout;
      _TimeoutBlock later = ^{
        timeout = nil;
        if (more) SS.apply(func, arguments);
        whenDone();
      };
      if (!timeout) timeout = SS.setTimeout(later, waitNS);
      if (throttling) {
        more = true;
      } else {
        throttling = true;
        result = SS.apply(func, arguments);
      }
      whenDone();
      return result;
    };
  };
}

+ (_DebouncedBlock(^)(_DebounceBlock func, I waitNS, B immediate, id arg1, ...))debounce
{
  return ^(_DebounceBlock func, I waitNS, B immediate, id arg1, ...) {
    ARGS_AO(arguments, arg1);
    
    // requires at least one argument to match the block signature (id arg1, ...)
    if (arguments.length < 1) arguments.push(NSNull.null);
    __block SSTimeout* timeout;

    return ^{
      _DebouncedBlock later = ^{
        timeout = nil;
        if (!immediate) SS.apply(func, arguments);
      };
      B callNow = immediate && !timeout;
      SS.clearTimeout(timeout);
      timeout = SS.setTimeout(later, waitNS);
      if (callNow) SS.apply(func, arguments);
    };
  };
}

+ (_OncedBlock(^)(_OnceBlock func, id arg1, ...))once
{
  return ^(_OnceBlock func, id arg1, ...) {
    ARGS_AO(arguments, arg1);

    // requires at least one argument to match the block signature (id arg1, ...)
    if (arguments.length < 1) arguments.push(NSNull.null);

    __block B ran = false;
    __block id memo;
    return ^{
      if (ran) return memo;
      ran = true;
      return memo = SS.apply(func, arguments);
    };
  };
}

+ (_AfterBlock(^)(I times, _AfterBlock func, id arg1, ...))after
{
  return ^_AfterBlock(I times, _AfterBlock func, id arg1, ...) {
    ARGS_AO(arguments, arg1);

    // requires at least one argument to match the block signature (id arg1, ...)
    if (arguments.length < 1) arguments.push(NSNull.null);

    __block I timesInternal = times;
    if (timesInternal <= 0) return SS.apply(func, arguments);
    return ^(id arg1, ...) {
      if (--timesInternal < 1) {
        return SS.apply(func, arguments);
      }
      return nil;
    };
  };
}

+ (_WrappedBlock(^)(_WrappedBlock func, _WrapBlock wrapper))wrap
{
  return ^(_WrappedBlock func, _WrapBlock wrapper) {
    return ^id(id arg1, ...){
      ARGS_AO(arguments, arg1);

      // requires at least one argument to match the block signature (id arg1, ...)
      if (arguments.length < 1) arguments.push(NSNull.null);
      
      A* args = A.newNSO(func).concat(arguments);
      return SS.apply(wrapper, args);
    };
  };
}

+ (_ComposeBlock(^)(_ComposeBlock func1, ...))compose
{
  return ^_ComposeBlock(_ComposeBlock func1, ...) {
    // TODO: add type checking 
    ARGS_AO(funcs, func1);

    return ^(id arg1, ...) {
      ARGS_AO(args, arg1);

      // requires at least one argument to match the block signature (id arg1, ...)
      if (args.length < 1) args.push(NSNull.null);

      for (I i = funcs.length - 1; i >= 0; i--) {
        args = [A arrayWithObject:SS.apply(funcs.getAt(i), args)];
      }
      return args.getAt(0);
    };
  };
}

@end
