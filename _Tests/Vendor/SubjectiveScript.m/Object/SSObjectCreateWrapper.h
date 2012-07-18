//
//  SSObjectCreateWrapper.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSObjectCreateWrapper : NSObject

@property (readonly) SSObjectCreateWrapper*(^_)(id key, id value);
@property (readonly) id(^value)();
@property (readonly) id __;

@end
