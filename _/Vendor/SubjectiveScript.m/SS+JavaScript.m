//
//  SS+JavaScript.m
//  _.m
//
//  Created by Kevin Malakoff on 7/22/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SS+JavaScript.h"
#import "SSJSON.h"

@implementation SS (JavaScript)

+ (SSJSON*)JSON
{
  static SSJSON* json = nil;
  if(!json)
    json = [[SSJSON alloc] init]; 

  return json;
}

@end
