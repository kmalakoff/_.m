//
//  SSObjectCreateWrapper+Private.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SSObjectCreateWrapper.h"

@interface SSObjectCreateWrapper (Private)

- (id)initWithDictionary:(NSMutableDictionary*)_dictionary;

@property (readwrite) NSMutableDictionary *_dictionary;

@end
