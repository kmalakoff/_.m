//
//  SSTypes.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>

// fundamental types
typedef BOOL            B;
typedef NSInteger       I;
typedef float           F;

// object types
#define A               NSMutableArray
#define O               NSMutableDictionary
#define S               NSMutableString
#define D               NSDate
#define N               NSNumber

// array types
typedef B               BA[];
typedef I               IA[];
typedef F               FA[];
typedef id              OA[];
typedef id              KVA[][2];