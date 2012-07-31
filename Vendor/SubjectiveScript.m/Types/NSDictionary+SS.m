//
//  NSDictionary+SS.m
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

#import "NSDictionary+SS.h"

// REMOVE
#import <objc/runtime.h>

@implementation NSDictionary (SS)

- (id)initWithKV:(const KV*) values /* NIL_TERMINATED */
{
  O* dictionary = O.new;
  for (const id* pair = (const id*) values; *pair != nil; pair+=2) {
    id value = pair[1];
    [dictionary setValue:value ? value : NSNull.null forKey:pair[0]];
  }
  
  return [self initWithDictionary:dictionary];
}

+ (O*(^)(NSD* other))newO
{
  return ^(NSD* other) {
    return [O dictionaryWithDictionary:other];
  };
}

- (NSS*)mutableClassName { return NSStringFromClass([O class]); }
- (O*(^)())toMutable { return ^{ return self.mutableCopy; }; }

- (B(^)())isEmpty { return ^B() { return ([self keyEnumerator].nextObject == nil); }; }
- (NSO*(^)(NSO* key))get { return ^(NSO* key) { return [self objectForKey:key]; }; }

@end
