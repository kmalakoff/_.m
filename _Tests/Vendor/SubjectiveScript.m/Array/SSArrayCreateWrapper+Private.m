//
//  SSArrayCreateWrapper+Private.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SSArrayCreateWrapper+Private.h"

@implementation SSArrayCreateWrapper (Private)

@dynamic _array;

- (id)initWithArray:(NSMutableArray*)array
{
  self = [super init];
  if (!self) return self;

  self._array = array;
  
  return self;
}

@end
