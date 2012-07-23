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

// TODO: can I make the arguments inline and returnable?

// any number of arguments of type id or NSObject terminated with nil
#define ARGS_AO(_name, _lastNamedArg) \
  va_list argList; \
  va_start(argList, _lastNamedArg); \
  A* _name = A.newArguments; \
  for (NSO* arg = _lastNamedArg; arg != nil; arg = va_arg(argList, NSO*)) { [_name addObject:arg]; } \
  va_end(argList);

// any number of arguments of type NSInteger terminated with AI_END
#define AI_END (I)NSNotFound
#define ARGS_AI(_name, _lastNamedArg) \
  va_list argList; \
  va_start(argList, _lastNamedArg); \
  A* _name = A.newArguments; \
  for (I arg = _lastNamedArg; arg != AI_END; arg = va_arg(argList, I)) { [_name addObject:N.I(arg)]; } \
  va_end(argList);

// one argument of type NSInteger
#define ARG_I(_name, _lastNamedArg) \
  va_list argList; \
  va_start(argList, _lastNamedArg); \
  I _name = va_arg(argList, I); \
  va_end(argList);

// one argument of type NSNumber
#define ARG_N(_name, _lastNamedArg) \
  va_list argList; \
  va_start(argList, _lastNamedArg); \
  N* _name = va_arg(argList, N*); \
  va_end(argList);