//
//  SS+GCD.m
//  _.m
//
//  Created by Kevin Malakoff on 7/22/12.
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

#import "SS+GCD.h"
#import "SS+SystemCompatibility.h"

@implementation SS (GCD)

+ (void(^)(SSDispatchBlock block, I waitNS))dispatchMain
{
  return ^(SSDispatchBlock block, I waitNS) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, waitNS), dispatch_get_main_queue(), block);
  };
}

+ (void(^)(SSDispatchBlock block, I waitNS))dispatchBackground
{
  return ^(SSDispatchBlock block, I waitNS) {
    if (SS.iOSVersionLT(@"5.0")) 
    {
      dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0UL);
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, waitNS), concurrentQueue, block);
    }
    else
    {
      dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0UL);
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, waitNS), concurrentQueue, block);
    }
  };
}

+ (A*)timeoutRunningList
{
  static NSMutableArray *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = A.new;
  });
  return sharedInstance;
}

+ (SSTimeout*(^)(SSTimeoutBlock block, I waitNS))setTimeout
{
  return ^(SSTimeoutBlock block, I waitNS) {
    @synchronized(self) {
      static I id = 0; id++;
      
      SSTimeout* timeout = [NSNumber numberWithInteger:id];
      [[SS timeoutRunningList] addObject:timeout];
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, waitNS), dispatch_get_main_queue(), ^{
        @synchronized(self) {
          A* runningList = [SS timeoutRunningList];
          UI index = [runningList indexOfObject:timeout];
          if (index == NSNotFound) // not running
            return;
          
          // remove
          [runningList removeObjectAtIndex:index];
          
          // call
          block();
       }
      });
      return timeout;
    }
  };
}

+ (void(^)(SSTimeout* timeout))clearTimeout
{
  return ^(SSTimeout* timeout) {
    if (!timeout) return; // no timeout
    
    @synchronized(self) {
      A* runningList = [SS timeoutRunningList];
      UI index = [runningList indexOfObject:timeout];
      if (index == NSNotFound) // not running
        return;
      
      // remove
      [runningList removeObjectAtIndex:index];
    }
  };
}

@end
