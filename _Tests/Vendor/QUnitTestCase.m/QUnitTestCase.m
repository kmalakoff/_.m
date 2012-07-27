//
//  QUnitTestCase.m
//  QUnitTestCase.m
//
//  Created by Kevin Malakoff on 7/18/12.
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

#import "QUnitTestCase.h"
#import "QUnitTest+Private.h"

@implementation QUnitTestCase

- (void)equal:(id)actual expected:(id)expected message:(NSString*)message args:(va_list)args strict:(BOOL)strict
{
  NSString *description = [[NSString alloc] initWithFormat:message arguments:args];

  @try {
    if (actual != expected) { 
      if (
        (strcmp(@encode(__typeof__(actual)), @encode(id)) == 0) && 
        (strcmp(@encode(__typeof__(expected)), @encode(id)) == 0) && 
        [actual isEqual:expected]
      )
        return;

      if (strict && (strcmp(@encode(__typeof__(actual)), @encode(__typeof__(expected))) != 0)) 
      {
        [self failWithException:([NSException failureInEqualityBetweenObject:actual 
                                                                 andObject:expected 
                                                              inFile:@"" 
                                                              atLine:0 
                                                     withDescription:description])]; 
      }
      
     [self failWithException:([NSException failureInEqualityBetweenObject:actual 
                                                               andObject:expected 
                                                            inFile:@"" 
                                                            atLine:0 
                                                   withDescription:description])]; 
  } 
  }
  @catch (id anException) {
      [self failWithException:([NSException failureInRaise:[NSString stringWithFormat:@"(%@) == (%@)", @"actual", @"expected"]
            exception:anException 
               inFile:@"" 
               atLine:0
      withDescription:description])]; 
  }
}

- (void)deepEqual:(id)actual expected:(id)expected message:(NSString*)message args:(va_list)args strict:(BOOL)strict
{
  if ([actual isKindOfClass:[NSArray class]])
  {
    NSArray *actualArray = actual;
    NSArray *expectedArray = expected;
    
    // not a match
    if (![expectedArray isKindOfClass:[NSArray class]]
      || (actualArray.count != expectedArray.count)
    )
    {
      NSString *description = [[NSString alloc] initWithFormat:message arguments:args];
     [self failWithException:([NSException failureInEqualityBetweenObject:actual 
                                                               andObject:expected 
                                                            inFile:@"" 
                                                            atLine:0 
                                                   withDescription:description])]; 
      return;
    }
  
    // check each element
    for (NSInteger index=0; index<actualArray.count; index++) 
    {
      [self equal:[actualArray objectAtIndex:index] expected:[expectedArray objectAtIndex:index] message:message args:args strict:strict];
    }
  }

  else
  {
    [self equal:actual expected:expected message:message args:args strict:strict];
  }
}

- (void)notEqual:(id)actual expected:(id)expected message:(NSString*)message args:(va_list)args strict:(BOOL)strict
{
  NSString *description = [[NSString alloc] initWithFormat:message arguments:args];

  @try {
    if (actual == expected) { 
      if (
        (strcmp(@encode(__typeof__(actual)), @encode(id)) == 0) && 
        (strcmp(@encode(__typeof__(expected)), @encode(id)) == 0) && 
        ![actual isEqual:expected]
      )
      {
        return;
      }
      
      if (strict && (strcmp(@encode(__typeof__(actual)), @encode(__typeof__(expected))) != 0))
      {
        [self failWithException:([NSException failureInEqualityBetweenObject:actual 
                                                                 andObject:expected 
                                                              inFile:@"" 
                                                              atLine:0 
                                                     withDescription:description])]; 
      }
            
     [self failWithException:([NSException failureInEqualityBetweenObject:actual 
                                                               andObject:expected 
                                                            inFile:@"" 
                                                            atLine:0 
                                                   withDescription:description])]; 
  } 
  }
  @catch (id anException) {
      [self failWithException:([NSException failureInRaise:[NSString stringWithFormat:@"(%@) == (%@)", @"actual", @"expected"]
            exception:anException 
               inFile:@"" 
               atLine:0
      withDescription:description])]; 
  }
}

- (void(^)(id actual, id expected, NSString *message, ...))equal
{
  return ^(id actual, id expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    [self equal:actual expected:expected message:message args:args strict:NO];
    va_end(args);
  };
}

- (void(^)(id actual, id expected, NSString *message, ...))notEqual
{
  return ^(id actual, id expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    [self notEqual:actual expected:expected message:message args:args strict:NO];
    va_end(args);
  };
}

- (void(^)(NSInteger actual, NSInteger expected, NSString *message, ...))equalI
{
  return ^(NSInteger actual, NSInteger expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    [self equal:[NSNumber numberWithInteger:actual] expected:[NSNumber numberWithInteger:expected] message:message args:args strict:NO];
    va_end(args);
  };
}

- (void(^)(NSInteger actual, NSInteger expected, NSString *message, ...))notEqualI
{
  return ^(NSInteger actual, NSInteger expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    [self notEqual:[NSNumber numberWithInteger:actual] expected:[NSNumber numberWithInteger:expected] message:message args:args strict:NO];
    va_end(args);
  };
}

- (void(^)(id actual, id expected, NSString *message, ...))strictEqual
{
  return ^(id actual, id expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    [self equal:actual expected:expected message:message args:args strict:YES];
    va_end(args);
  };
}

- (void(^)(id actual, id expected, NSString *message, ...))notStrictEqual
{
  return ^(id actual, id expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    [self notEqual:actual expected:expected message:message args:args strict:YES];
    va_end(args);
  };
}

- (void(^)(id actual, id expected, NSString *message, ...))deepEqual
{
  return ^(id actual, id expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    [self deepEqual:actual expected:expected message:message args:args strict:NO];
    va_end(args);
  };
}

- (void(^)(BOOL result, NSString *message, ...))ok
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

- (void(^)(QURaiseBlock block, NSString *expected, NSString *message, ...))raises
{
  return ^(QURaiseBlock block, NSString *expected, NSString *message, ...){
    va_list args;
    va_start(args, message);
    NSString *description = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);

    @try {
      block();
    }
    @catch (NSException* anException) {
      if (expected && ![expected isEqual:anException.name])
       [self failWithException:([NSException failureInRaise:[NSString stringWithFormat:@"Unexpected exception type '%@'. Was expecting '%@'", anException.name, expected] 
                                                              inFile:@"" 
                                                              atLine:0 
                                                     withDescription:description])]; 
      return;
    }

   [self failWithException:([NSException failureInRaise:@"" 
                                                          inFile:@"" 
                                                          atLine:0 
                                                 withDescription:description])]; 
  };
}

- (void(^)(QUAsyncTestBlock callback))asyncTest
{
  return ^(QUAsyncTestBlock callback) {
    QUnitTest *test = [[QUnitTest alloc] initWithTestCase:self expected:nil callback:^(QUnitTest *test){ callback(test); return (id) nil; }];
    [test runTest];
  };
}

- (void(^)(id expected, QUAsyncTestBlockExpected callback))asyncTestExpected
{
  return ^(id expected, QUAsyncTestBlockExpected callback) {
    QUnitTest *test = [[QUnitTest alloc] initWithTestCase:self expected:expected callback:callback];
    [test runTest];
  };
}

@end
