//
//  NSNumber+SS.m
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

#import "NSNumber+SS.h"
#import "NSString+SS.h"
#import <objc/runtime.h>

static const NSS* SSTypeBoolean = @"boolean";
static char* const SSIsBooleanKey = "IsBoolean";

@implementation N (SS)

+ (N*(^)(B value))B;
{
  return ^(B value) {
    N* boolNumber = [[NSNumber alloc] initWithBool:value];
    
    // add a dynamic property to the class so it can be recognized as a boolean. Explaination on why it is not built in functionality: http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
    objc_setAssociatedObject(boolNumber, SSIsBooleanKey, SSTypeBoolean, OBJC_ASSOCIATION_ASSIGN);

    return boolNumber;
  };
}
- (B)B { return self.boolValue; }

+ (N*(^)(I value))I
{
  return ^(I value) {
    return [N numberWithInteger:value];
  };
}
- (I)I { return self.integerValue; }

+ (N*(^)(UI value))UI
{
  return ^(UI value) {
    return [N numberWithUnsignedInteger:value];
  };
}
- (UI)UI { return self.unsignedIntegerValue; }

+ (N*(^)(F value))F
{
  return ^(F value) {
    return [N numberWithFloat:value];
  };
}
- (F)F { return self.floatValue; }

+ (N*(^)(D value))D
{
  return ^(D value) {
    return [N numberWithDouble:value];
  };
}
- (D)D { return self.doubleValue; }

- (B(^)())isBoolean{ return ^B(){ return objc_getAssociatedObject(self, SSIsBooleanKey) != nil; }; }

@end