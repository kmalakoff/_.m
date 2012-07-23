//
//  QUnitTest+Private.h
//  _.m
//
//  Created by Kevin Malakoff on 7/23/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "QUnitTest.h"

@interface QUnitTest (Private)

- (id)initWithTestCase:(QUnitTestCase*)testCase expected:(id)expected callback:(QUAsyncTestBlockExpected)callback;
- (void)runTest;

@end
