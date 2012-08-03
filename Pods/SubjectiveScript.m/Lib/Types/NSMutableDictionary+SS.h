//
//  NSMutableDictionary+SS.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "SSTypes.h"

@interface NSMutableDictionary (SS)

+ (O*(^)(const KV* values /* NIL_TERMINATED */))newWithKV;
+ (O*(^)(UI capacity))newC;

- (O*(^)())toMutable;

- (NSO*(^)(id key, SSGetOrAddBlock add))getOrAdd;
- (O*(^)(id key, id value))set;
- (O*(^)(const KV* values /* NIL_TERMINATION */))setKV;
- (O*(^)(NSD* other))setO;

@end

#define OKV(...)        O.newWithKV((KV[]){__VA_ARGS__, /* NIL_TERMINATION */ nil})
#define OsetKV(_o, ...) _o.setKV((KV[]){__VA_ARGS__, /* NIL_TERMINATION */ nil})