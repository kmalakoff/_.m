//
//  SSObjectCreateWrapper.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SSObjectCreateWrapper.h"
#import "NSMutableDictionary+SS.h"

@interface SSObjectCreateWrapper()

@property (readwrite) NSMutableDictionary *_dictionary;

@end

@implementation SSObjectCreateWrapper

@synthesize _dictionary;

- (SSObjectCreateWrapper*(^)(id, id))_
{
  return ^(id key, id value){
    NSAssert(!_dictionary.has(key), @"key %@ already exists for add", key);
    [_dictionary setObject:value forKey:key];
    return self;
  };
}

- (id(^)())value
{
  return ^() {
    return _dictionary;
  };
}

- (id)__
{
  return self.value();
}

@end
