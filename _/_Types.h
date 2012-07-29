//
//  _Types.h
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

#import "SSTypes.h"

// Helpers to access collection iteration (each, map, etc) with variable arguments
#define ARGS_KEY(_lastNamedArg) \
  id key; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    key = va_arg(argList, id); \
    va_end(argList); \
  }
#define ARGS_KEY_COLLECTION(_lastNamedArg, _collection) \
  id key; \
  id _collection; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    key = va_arg(argList, id); \
    _collection = va_arg(argList, id); \
    va_end(argList); \
  }
#define ARGS_INDEX(_lastNamedArg) \
  I index; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    index =  ((N*)va_arg(argList, N*)).I; \
    va_end(argList); \
  }
#define ARGS_INDEX_COLLECTION(_lastNamedArg, _collection) \
  I index; \
  id _collection; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    index =  va_arg(argList, N*)).I; \
    _collection = va_arg(argList, id); \
    va_end(argList); \
  }
#define ARGS_COLLECTION(_lastNamedArg, _collection) \
  id _collection; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    va_arg(argList, id); \
    _collection = va_arg(argList, id); \
    va_end(argList); \
  }

// timeouts
typedef SSTaskId            _Timeout;
typedef void                (^_TimeoutBlock)();

// blocks
typedef void                (^_EachBlock)(id value, ... /* KEY, COLLECTION */);
typedef B                   (^_EachWithStopBlock)(id value, ... /* KEY, COLLECTION */);
typedef NSO*                (^_MapBlock)(id value, ... /* KEY, COLLECTION */);

typedef NSO*                (^_ReduceBlock)(id memo, id value, ... /* KEY, COLLECTION */);

typedef B                   (^_FindBlock)(id value);

typedef B                   (^_CollectionItemTestBlock)(id value, ... /* KEY, COLLECTION */);

typedef NSO*                (^_MinBlock)(id value);
typedef NSO*                (^_MaxBlock)(id value);

typedef NSComparisonResult  (^_SortBlock)(id left, id right); /* ADDED */

typedef NSO*                (^_SortByBlock)(id value, ... /* KEY, COLLECTION */);
typedef NSO*                (^_GroupByBlock)(id value, ... /* KEY, COLLECTION */);
typedef NSO*                (^_SortedIndexBlock)(id value, ... /* KEY, COLLECTION */);

typedef id                  (^_MemoizedBlock)(id arg1, ... /* NIL_TERMINATION */);
typedef id                  (^_MemoizeBlock)(id arg1, ... /* NIL_TERMINATION */);
typedef id                  (^_MemoizeHashBlock)(id arg1, ... /* NIL_TERMINATION */);

typedef void                (^_DelayBlock)();
typedef void                (^_DeferBlock)();

typedef id                  (^_ThrottledBlock)();
typedef id                  (^_ThrottleBlock)(id arg1, ... /* NIL_TERMINATION */);

typedef void                (^_DebouncedBlock)();
typedef void                (^_DebounceBlock)(id arg1, ... /* NIL_TERMINATION */);

typedef id                  (^_OncedBlock)();
typedef id                  (^_OnceBlock)(id arg1, ... /* NIL_TERMINATION */);

typedef id                  (^_AfteredBlock)(id arg1, ... /* NIL_TERMINATION */);
typedef id                  (^_AfterBlock)(id arg1, ... /* NIL_TERMINATION */);

typedef id                  (^_WrappedBlock)(id arg1, ... /* NIL_TERMINATION */);
typedef id                  (^_WrapBlock)(_WrappedBlock wrapped, id arg1, ... /* NIL_TERMINATION */);

typedef void                (^_TapBlock)(id obj);

typedef id                  (^_ComposeBlock)(id arg1, ... /* NIL_TERMINATION */);

typedef id                  (^_IdentityBlock)(id value);

typedef void                (^_TimesBlock)(I index);