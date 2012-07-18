//
//  SSArrayCreateWrapper.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSArrayCreateWrapper : NSObject

@property (readonly) SSArrayCreateWrapper*(^_)(id value);
@property (readonly) id(^value)();
@property (readonly) id __;

@end
