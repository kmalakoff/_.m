//
//  SSArrayCreateWrapper.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SSArrayCreateWrapper.h"
#import "NSMutableArray+SS.h"

@interface SSArrayCreateWrapper()

@property (readwrite) NSMutableArray *_array;

@end

@implementation SSArrayCreateWrapper

@synthesize _array;

- (SSArrayCreateWrapper*(^)(id))_
{
  return ^(id value){
    [_array addObject:value];
    return self;
  };
}

- (id(^)())value
{
  return ^() {
    return _array;
  };
}

- (id)__
{
  return self.value();
}

@end
