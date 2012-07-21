//
//  SS+Arguments.h
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

#import "SS.h"

@interface SS (Arguments)

+ (A*(^)(va_list argList, NSO* lastNamedArg))objectArgumentsToArray;
+ (A*(^)(va_list argList, I lastNamedArg))integerArgumentsToArray;

@end

// TODO: can I make the arguments inline and returnable?

// NOTE: your variable argument array must be nil terminated to indicate the end of arguments
#define AO_ARGS(_name, _lastNamedArg) \
  va_list argList; \
  va_start(argList, _lastNamedArg); \
  A* _name = SS.objectArgumentsToArray(argList, _lastNamedArg); \
  va_end(argList);

#define AI_END (I)NSNotFound
#define AI_ARGS(_name, _lastNamedArg) \
  va_list argList; \
  va_start(argList, _lastNamedArg); \
  A* _name = SS.integerArgumentsToArray(argList, _lastNamedArg); \
  va_end(argList);