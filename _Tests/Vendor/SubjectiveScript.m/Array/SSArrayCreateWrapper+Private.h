//
//  SSArrayCreateWrapper+Private.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "SSArrayCreateWrapper.h"

@interface SSArrayCreateWrapper (Private)

- (id)initWithArray:(NSMutableArray*)_array;

@property (readwrite) NSMutableArray *_array;

@end
