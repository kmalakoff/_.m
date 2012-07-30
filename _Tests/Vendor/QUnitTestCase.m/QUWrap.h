//
//  QUWrap.h
//  QUnit.m
//
//  Created by Kevin Malakoff on 7/30/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QUWrap : NSObject

+ (id)wrap:(void*)value type:(char[2])type;

@end


#define QUWrapValue(_value) [QUWrap wrap:(void*)_value type:@encode(__typeof__(_value))]