//
//  QUnitTests.m
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

#import "QUnitTests.h"

@implementation QUnitTests

+ (void)equal:(SenTestCase*)testCase actual:(id)actual expected:(id)expected expression:(NSString*)expression description:(NSString*)description filename:(NSString*)filename lineNumber:(NSUInteger)lineNumber strict:(BOOL)strict
{
  @try {
    if (actual == expected)
      return;

    if (
      (strcmp(@encode(__typeof__(actual)), @encode(id)) == 0) &&
      (strcmp(@encode(__typeof__(expected)), @encode(id)) == 0) &&
      [actual isEqual:expected]
    ) {
      return;
    }
    
    if (strict && (strcmp(@encode(__typeof__(actual)), @encode(__typeof__(expected))) != 0)) {
      [testCase failWithException:([NSException failureInEqualityBetweenObject:actual andObject:expected inFile:filename atLine:lineNumber withDescription:description])];
    }

   [testCase failWithException:([NSException failureInEqualityBetweenObject:actual andObject:expected inFile:filename atLine:lineNumber withDescription:description])];
  }
  @catch (id anException) {
    [testCase failWithException:([NSException failureInRaise:expression exception:anException inFile:filename atLine:lineNumber withDescription:description])];
  }
}

+ (void)deepEqual:(SenTestCase*)testCase actual:(id)actual expected:(id)expected expression:(NSString*)expression description:(NSString*)description filename:(NSString*)filename lineNumber:(NSUInteger)lineNumber
{
  if ([actual isKindOfClass:[NSArray class]]) {
    NSArray *actualArray = actual;
    NSArray *expectedArray = expected;
    
    // not a match
    if (![expectedArray isKindOfClass:[NSArray class]]
      || (actualArray.count != expectedArray.count)
    ) {
     [testCase failWithException:([NSException failureInEqualityBetweenObject:actual andObject:expected inFile:filename atLine:lineNumber withDescription:description])];
      return;
    }
  
    // check each element
    for (NSInteger index=0; index<actualArray.count; index++) {
      [QUnitTests equal:testCase actual:[actualArray objectAtIndex:index] expected:[expectedArray objectAtIndex:index] expression:expression description:description filename:filename lineNumber:lineNumber strict:YES];
    }
  }

  else
    [QUnitTests equal:testCase actual:actual expected:expected expression:expression description:description filename:filename lineNumber:lineNumber strict:YES];
}

+ (void)notEqual:(SenTestCase*)testCase actual:(id)actual expected:(id)expected expression:(NSString*)expression description:(NSString*)description filename:(NSString*)filename lineNumber:(NSUInteger)lineNumber strict:(BOOL)strict
{
  @try {
    if (actual != expected)
      return;

    if (
      (strcmp(@encode(__typeof__(actual)), @encode(id)) == 0) &&
      (strcmp(@encode(__typeof__(expected)), @encode(id)) == 0) &&
      ![actual isEqual:expected]
    ) {
      return;
    }
    
    if (strict && (strcmp(@encode(__typeof__(actual)), @encode(__typeof__(expected))) != 0)) {
      [testCase failWithException:([NSException failureInEqualityBetweenObject:actual andObject:expected inFile:filename atLine:lineNumber withDescription:description])];
    }

   [testCase failWithException:([NSException failureInEqualityBetweenObject:actual andObject:expected inFile:filename atLine:lineNumber withDescription:description])];
  }
  @catch (id anException) {
    [testCase failWithException:([NSException failureInRaise:expression exception:anException inFile:filename atLine:lineNumber withDescription:description])];
  }
}

+ (void)ok:(SenTestCase*)testCase result:(BOOL)result expression:(NSString*)expression description:(NSString*)description filename:(NSString*)filename lineNumber:(NSUInteger)lineNumber
{
  if (result)
    return;
            
 [testCase failWithException:([NSException failureInCondition:expression isTrue:result inFile:filename atLine:lineNumber withDescription:description])];
}

+ (void)raises:(SenTestCase*)testCase callback:(void(^)())callback expectedExceptionName:(NSString*)expectedExceptionName expression:(NSString*)expression description:(NSString*)description filename:(NSString*)filename lineNumber:(NSUInteger)lineNumber
{
  @try {
    callback();
  }
  @catch (NSException* anException) {
    if (expectedExceptionName && ![expectedExceptionName isEqual:anException.name])
     [testCase failWithException:([NSException failureInRaise:[NSString stringWithFormat:@"Unexpected exception type '%@'. Was expecting '%@'", anException.name, expectedExceptionName] inFile:filename atLine:lineNumber withDescription:description])];
    return;
  }

 [testCase failWithException:([NSException failureInRaise:expression inFile:filename atLine:lineNumber withDescription:description])];
}

@end