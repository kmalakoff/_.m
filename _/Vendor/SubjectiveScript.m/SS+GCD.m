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

+ (void(^)(SSDoBlock block, I waitNS))dispatchMain
{
  return ^(SSDoBlock block, I waitNS) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, waitNS), dispatch_get_main_queue(), block);
  };
}

+ (void(^)(SSDoBlock block, I waitNS))dispatchBackground
{
  return ^(SSDoBlock block, I waitNS) {
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

@end
