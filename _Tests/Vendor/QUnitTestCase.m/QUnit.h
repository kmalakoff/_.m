//
//  QUnit.h
//  QUnit.m
//
//  Created by Kevin Malakoff on 7/23/12.
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

#import <SenTestingKit/SenTestingKit.h> // adds QUnit syntax on top of SenTestingKit

@interface QUnit : NSObject
@end

#ifndef QUNIT_TESTS
#define QUNIT_TESTS
#import "QUnit+Tests.h"

/////////////////////////////
// Equality
/////////////////////////////

#define equal(_actual, _expected, _description, ...) \
  [QUnit equal:self actual:_actual expected:_expected expression:[NSString stringWithFormat:@"(%s) == (%s)", #_actual, #_expected] description:[NSString stringWithFormat:(_description), ##__VA_ARGS__] filename:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__ strict:NO];

#define equalI(_actual, _expected, _description, ...) \
  [QUnit equal:self actual:[NSNumber numberWithInteger:_actual] expected:[NSNumber numberWithInteger:_expected] expression:[NSString stringWithFormat:@"(%s) == (%s)", #_actual, #_expected] description:[NSString stringWithFormat:(_description), ##__VA_ARGS__] filename:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__ strict:NO];

#define strictEqual(_actual, _expected, _description, ...) \
  [QUnit equal:self actual:_actual expected:_expected expression:[NSString stringWithFormat:@"(%s) == (%s)", #_actual, #_expected] description:[NSString stringWithFormat:(_description), ##__VA_ARGS__] filename:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__ strict:YES];

#define deepEqual(_actual, _expected, _description, ...) \
  [QUnit deepEqual:self actual:_actual expected:_expected expression:[NSString stringWithFormat:@"(%s) == (%s)", #_actual, #_expected] description:[NSString stringWithFormat:(_description), ##__VA_ARGS__] filename:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__];

/////////////////////////////
// Non-Equality
/////////////////////////////

#define notEqual(_actual, _expected, _description, ...) \
  [QUnit notEqual:self actual:_actual expected:_expected expression:[NSString stringWithFormat:@"(%s) == (%s)", #_actual, #_expected] description:[NSString stringWithFormat:(_description), ##__VA_ARGS__] filename:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__ strict:NO];

#define notStrictEqual(_actual, _expected, _description, ...) \
  [QUnit notEqual:self actual:_actual expected:_expected expression:[NSString stringWithFormat:@"(%s) == (%s)", #_actual, #_expected] description:[NSString stringWithFormat:(_description), ##__VA_ARGS__] filename:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__ strict:YES];

/////////////////////////////
// Acceptance
/////////////////////////////

#define ok(_result, _description, ...) \
  [QUnit ok:self result:_result expression:[NSString stringWithFormat:@"(%s) == true", #_result] description:[NSString stringWithFormat:(_description), ##__VA_ARGS__] filename:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__];

/////////////////////////////
// Exceptions
/////////////////////////////

#define raises(_callback, _expectedExceptionName, _description, ...) \
  [QUnit raises:self callback:_callback expectedExceptionName:_expectedExceptionName expression:[NSString stringWithFormat:@"(%s)", #_callback] description:[NSString stringWithFormat:(_description), ##__VA_ARGS__] filename:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__];

/////////////////////////////
// Asynchronous
/////////////////////////////
#define QU_ASYNC_TEST_TIMEOUT_S 5

#define asyncTest(_callback) \
{ \
  __block BOOL _quStartCalled = NO; \
  void (^start)() = ^{ _quStartCalled = YES; }; \
\
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, QU_ASYNC_TEST_TIMEOUT_S * NSEC_PER_SEC), dispatch_get_main_queue(), ^{ \
      if (_quStartCalled) return; \
     [self failWithException:([NSException failureInFile:[NSString stringWithUTF8String:__FILE__] atLine:__LINE__ withDescription:@"QUnit: async test timed out"])]; \
    }); \
  _callback(); \
}

#endif