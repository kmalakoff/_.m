//
//  _Types.h
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
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

// iteration helpers for polymorphic keys (id and I type) under ARC
typedef void* KH;
#define KHFromIndex(_index)     (KH)_index
#define KHIndex(_kh)            (I)_kh

#define KHRetainKey(_key)       (void*)CFBridgingRetain(_key)
#define KHReleaseKey(_key)      CFBridgingRelease((__bridge KH)_key)
#define KHKey(_kh)              (__bridge id)_kh

// blocks
typedef void                (^_DoBlock)();

typedef B                   (^_TestBlock)(id obj);
typedef N*                  (^_MaxBlock)(N* number);

typedef NSO*                (^_ReduceBlock)(id memo, id obj, KH kh);

typedef void                (^_ValueKeyBlock)(id value, KH kh);
typedef B                   (^_ValueKeyTestBlock)(id value, KH kh);

typedef NSO*                (^_MapBlock)(id value, KH kh);

typedef NSO*                (^_SortByBlock)(id value);
typedef NSComparisonResult  (^_CompareBlock)(id left, id right);