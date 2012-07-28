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
#import "_+Extensions.h"
#import "SubjectiveScript.h"

@implementation _ (Functions)

//bind /* NOT SUPPORTED: JavaScript-only */
//bindAll /* NOT SUPPORTED: JavaScript-only */

+ (_MemoizedBlock /* NIL_TERMINATION */(^)(_MemoizeBlock func, _MemoizeHashBlock hasher))memoize
{
  return ^(_MemoizeBlock func, _MemoizeHashBlock hasher) {
    O* memo = O.new;
    if (!hasher) hasher = ^id(id arg1, .../* KEY, COLLECTION */) {
      return arg1;
    };
    
    return ^id(id arg1, ... /* NIL_TERMINATION */){
      ARGS_AO(arguments, arg1);
      if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

      id key = SS.apply(hasher, arguments);
      if (_.has(memo, key))
        return memo.get(key);

      id value = SS.apply(func, arguments);
      memo.set(key, value);
      return value;
    };
  };
}

+ (void(^)(_DelayBlock func, I wait, id arg1, ... /* NIL_TERMINATION */))delay
{
  return ^(_DelayBlock func, I wait, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);
    if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

    SS.dispatchMain(^{
      SS.apply(func, arguments);
    }, wait);
  };
}

+ (void(^)(_DelayBlock func, I wait, id arg1, ... /* NIL_TERMINATION */))delayBG
{
  return ^(_DelayBlock func, I wait, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);
    if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

    SS.dispatchBackground(^{
      SS.apply(func, arguments);
    }, wait);
  };
}

+ (void(^)(_DeferBlock func, id arg1, ... /* NIL_TERMINATION */))defer
{ 
  return ^(_DeferBlock func, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);
    if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

    SS.dispatchMain(^{
      SS.apply(func, arguments);
    }, 0);
  };
}

+ (void(^)(_DeferBlock func, id arg1, ... /* NIL_TERMINATION */))deferBG
{ 
  return ^(_DeferBlock func, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);
    if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

    SS.dispatchBackground(^{
      SS.apply(func, arguments);
    }, 0);
  };
}

+ (_ThrottledBlock(^)(_ThrottleBlock func, I waitNS, id arg1, ... /* NIL_TERMINATION */))throttle
{
  return ^(_ThrottleBlock func, I waitNS, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);

    __block B throttling;
    __block B more;

    _DebouncedBlock whenDone = _.debounce(^(id arg1, ... /* NIL_TERMINATION */ /* NIL_TERMINATION */){ more = throttling = false; }, waitNS, /* MANDATORY */ false, /* NIL_TERMINATION */ nil);
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

+ (_DebouncedBlock(^)(_DebounceBlock func, I waitNS, B immediate, id arg1, ... /* NIL_TERMINATION */))debounce
{
  return ^(_DebounceBlock func, I waitNS, B immediate, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);
      if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

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

+ (_OncedBlock(^)(_OnceBlock func, id arg1, ... /* NIL_TERMINATION */))once
{
  return ^(_OnceBlock func, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);
    if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

    __block B ran = false;
    __block id memo;
    return ^{
      if (ran) return memo;
      ran = true;
      return memo = SS.apply(func, arguments);
    };
  };
}

+ (_AfteredBlock /* NIL_TERMINATION */(^)(I times, _AfterBlock func, id arg1, ... /* NIL_TERMINATION */))after
{
  return ^_AfterBlock(I times, _AfterBlock func, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);
    if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

    __block I timesInternal = times;
    if (timesInternal <= 0) return SS.apply(func, arguments);
    return ^id(id arg1, ... /* NIL_TERMINATION */) {
      if (--timesInternal < 1) {
        return SS.apply(func, arguments);
      }
      return nil;
    };
  };
}

+ (_WrappedBlock /* NIL_TERMINATION */(^)(_WrappedBlock func, _WrapBlock wrapper))wrap
{
  return ^(_WrappedBlock func, _WrapBlock wrapper) {
    return ^id(id arg1, ... /* NIL_TERMINATION */){
      ARGS_AO(arguments, arg1);
      if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)
      
      A* args = A.newNSO(func).concat(arguments);
      return SS.apply(wrapper, args);
    };
  };
}

+ (_ComposeBlock /* NIL_TERMINATION */(^)(_ComposeBlock func1, ... /* NIL_TERMINATION */))compose
{
  return ^_ComposeBlock(_ComposeBlock func1, ... /* NIL_TERMINATION */) {
    ARGS_AO(funcs, func1);

#ifdef DEBUG
    for (id func in funcs) {
      _.isBlock(func);
    }
#endif

    return ^(id arg1, ... /* NIL_TERMINATION */) {
      ARGS_AO(args, arg1);
      if (args.length < 1) args.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

      for (I i = funcs.length - 1; i >= 0; i--) {
        args = [A arrayWithObject:SS.apply(funcs.getAt(i), args)];
      }
      return args.getAt(0);
    };
  };
}

@end
