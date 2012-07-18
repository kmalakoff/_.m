//
//  SSObjectCreateWrapper+Private.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SSObjectCreateWrapper+Private.h"

@implementation SSObjectCreateWrapper (Private)

@dynamic _dictionary;

- (id)initWithDictionary:(NSMutableDictionary*)dictionary
{
  self = [super init];
  if (!self) return self;

  self._dictionary = dictionary;
  
  return self;
}

@end
