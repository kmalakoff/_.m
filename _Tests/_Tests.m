//
//  _Tests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Tests.h"
#import "Underscore.h"
#import "QUnit.h"

@implementation _Tests

- (void)test_version
{
  ok(_.VERSION.VersionGreaterThanOrEqualTo(@"0.1.0"), @"expected version");
}

@end
