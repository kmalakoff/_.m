//
//  SS+GCD.m
//  _.m
//
//  Created by Kevin Malakoff on 7/22/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
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
