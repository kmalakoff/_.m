//
//  _Tests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Tests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"
#import "QUnit.h"

@implementation _Tests

- (void)test_version
{
  ok(_.VERSION.VersionGreaterThanOrEqualTo(@"0.0.1"), @"expected version");
}

@end
