//
//  SS+GCD.h
//  _.m
//
//  Created by Kevin Malakoff on 7/22/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SS.h"

@interface SS (GCD)

+ (void(^)(SSDoBlock block, I waitNS))dispatchMain;
+ (void(^)(SSDoBlock block, I waitNS))dispatchBackground;

@end
