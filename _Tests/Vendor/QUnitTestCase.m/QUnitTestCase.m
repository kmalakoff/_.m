//
//  QUnitTestCase.m
//  QUnitTestCase.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "QUnitTestCase.h"

@implementation QUnitTestCase

- (void (^)(id actual, id expected, NSString *message, va_list args))_equal
{
  return ^(id actual, id expected, NSString *message, va_list args){
    NSString *description = [[NSString alloc] initWithFormat:message arguments:args];

    @try {
      if (actual != expected) { 
        if (
          (strcmp(@encode(__typeof__(actual)), @encode(id)) == 0) && 
          (strcmp(@encode(__typeof__(expected)), @encode(id)) == 0) && 
          [actual isEqual:expected]
        )
          return;
              
       [self failWithException:([NSException failureInEqualityBetweenObject:actual 
                                                                 andObject:expected 
                                                              inFile:@"" 
                                                              atLine:0 
                                                     withDescription:description])]; 
    } 
    }
    @catch (id anException) {
        [self failWithException:([NSException failureInRaise:[NSString stringWithFormat:@"(%s) == (%s)", @"actual", @"expected"] 
              exception:anException 
                 inFile:@"" 
                 atLine:0
        withDescription:description])]; 
    }
  };
}

- (void (^)(id actual, id expected, NSString *message, ...))equal
{
  return ^(id actual, id expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    self._equal(actual, expected, message, args);
    va_end(args);
  };
}

- (void (^)(NSInteger actual, NSInteger expected, NSString *message, ...))equalI
{
  return ^(NSInteger actual, NSInteger expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    self._equal([NSNumber numberWithInteger:actual], [NSNumber numberWithInteger:expected], message, args);
    va_end(args);
  };
}

- (void (^)(BOOL result, NSString *message, ...))ok
{
  return ^(BOOL result, NSString *message, ...){
    if (result)
        return;

    va_list args;
    va_start(args, message);
    NSString *description = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);
              
   [self failWithException:([NSException failureInCondition:@"" 
                                                             isTrue:result 
                                                          inFile:@"" 
                                                          atLine:0 
                                                 withDescription:description])]; 
  };
}

@end
