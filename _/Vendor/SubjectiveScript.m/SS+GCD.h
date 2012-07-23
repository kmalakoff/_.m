//
//  SS+GCD.h
//  _.m
//
//  Created by Kevin Malakoff on 7/22/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SS.h"

typedef NSNumber SSTimeout;

@interface SS (GCD)

+ (void(^)(SSDispatchBlock block, I waitNS))dispatchMain;
+ (void(^)(SSDispatchBlock block, I waitNS))dispatchBackground;
+ (SSTimeout*(^)(SSTimeoutBlock block, I waitNS))setTimeout;
+ (void(^)(SSTimeout* timeout))clearTimeout;

@end
