//
//  NSMutableArray+SS.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSTypes.h"

@interface NSMutableArray (SS)

+ (NSMutableArray*)new_;
+ (NSMutableArray* (^)(const BA values, I count))ba;
+ (NSMutableArray* (^)(const IA values, I count))ia;
+ (NSMutableArray* (^)(const FA values, I count))fa;
+ (NSMutableArray* (^)(const OA values, I count))oa;

- (NSMutableArray* (^)(id value))push;

@end

#define _BA(...) A.ba((BA){__VA_ARGS__}, sizeof((BA){__VA_ARGS__})/sizeof(B))
#define _IA(...) A.ia((IA){__VA_ARGS__}, sizeof((IA){__VA_ARGS__})/sizeof(I))
#define _FA(...) A.fa((FA){__VA_ARGS__}, sizeof((FA){__VA_ARGS__})/sizeof(F))
#define _OA(...) A.oa((OA){__VA_ARGS__}, sizeof((OA){__VA_ARGS__})/sizeof(id))