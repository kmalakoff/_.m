//
//  SSArguments.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
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

#import "NSMutableArray+SS.h"
#import "TargetConditionals.h"

// any number of arguments of type id or NSObject terminated with nil
#define ARGS_AO(_name, _lastNamedArg) \
  A* _name = A.newArguments; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    for (NSO* arg = _lastNamedArg; arg != nil; arg = va_arg(argList, NSO*)) { [_name addObject:arg]; } \
    va_end(argList); \
  }

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
// any number of arguments of type NSInteger terminated with AI_END
#define AI_END (I)NSNotFound
#define ARGS_AI(_name, _lastNamedArg) \
  A* _name = A.newArguments; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    for (I arg = _lastNamedArg; arg != AI_END; arg = va_arg(argList, I)) { [_name addObject:N.I(arg)]; } \
    va_end(argList); \
  }
#elif TARGET_OS_MAC
// any number of arguments of type NSInteger terminated with AI_END
#define AI_END (int)NSNotFound
#define ARGS_AI(_name, _lastNamedArg) \
  A* _name = A.newArguments; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    for (int arg = (int) _lastNamedArg; arg != AI_END; arg = va_arg(argList, int)) { [_name addObject:N.I((I)arg)]; } \
    va_end(argList); \
  }
#endif

// one argument of type BOOL
#define ARG_B(_name, _lastNamedArg) \
  I _name; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    _name = va_arg(argList, B); \
    va_end(argList); \
  }

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
// one argument of type NSInteger
#define ARG_I(_name, _lastNamedArg) \
  I _name; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    _name = va_arg(argList, I); \
    va_end(argList); \
  }

// one argument of type NSUInteger
#define ARG_UI(_name, _lastNamedArg) \
  UI _name; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    _name = va_arg(argList, UI); \
    va_end(argList); \
  }
#elif TARGET_OS_MAC
// one argument of type NSInteger
#define ARG_I(_name, _lastNamedArg) \
  I _name; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    _name = (I) va_arg(argList, int); \
    va_end(argList); \
  }
// one argument of type NSUInteger
#define ARG_UI(_name, _lastNamedArg) \
  UI _name; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    _name = (UI) va_arg(argList, unsigned int); \
    va_end(argList); \
  }
#endif

// one argument of type float
#define ARG_F(_name, _lastNamedArg) \
  F _name; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    _name = va_arg(argList, F); \
    va_end(argList); \
  }

// one argument of type double
#define ARG_D(_name, _lastNamedArg) \
  D _name; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    _name = va_arg(argList, D); \
    va_end(argList); \
  }

// one argument of type NSNumber
#define ARG_N(_name, _lastNamedArg) \
  N* _name; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    _name = va_arg(argList, N*); \
    va_end(argList); \
  }

// one argument of type NSNumber
#define ARG_NSO(_name, _lastNamedArg) \
  NSO* _name; \
  { \
    va_list argList; \
    va_start(argList, _lastNamedArg); \
    _name = va_arg(argList, NSO*); \
    va_end(argList); \
  }