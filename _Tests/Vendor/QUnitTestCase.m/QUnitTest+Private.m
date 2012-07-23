//
//  QUnitTest+Private.m
//  _.m
//
//  Created by Kevin Malakoff on 7/23/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "QUnitTest+Private.h"
#import "QUnitTestCase.h"

#define TEST_TIMEOUT_S 0.5

@implementation QUnitTest (Private)

- (id)initWithTestCase:(QUnitTestCase*)testCase expected:(id)expected callback:(QUAsyncTestBlockExpected)callback
{
  self = [super init];
  if (!self) return self;
  
  mTestCase = testCase;
  mExpected = expected;
  mCallback = callback;
  
  return self;
}

- (void)runTest
{
  mStartCalled = NO;
  id result = mCallback(self);
  if (!mExpected || [mExpected isEqual:result])
    return;

 [mTestCase failWithException:([NSException failureInEqualityBetweenObject:mExpected andObject:result
                                                        inFile:@"" 
                                                        atLine:0 
                                               withDescription:@"async test failed to match expected value"])]; 

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, TEST_TIMEOUT_S * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    if (!mStartCalled) {
     [mTestCase failWithException:([NSException failureInFile:@"" 
                                                            atLine:0 
                                                   withDescription:@"async test timed out"])]; 
    }
  });
}

@end
