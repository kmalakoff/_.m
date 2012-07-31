//
//  _+Utility.m
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

#import "_+Utility.h"
#import "_+Extensions.h"
#import "_+Objects.h"
#import "SubjectiveScript.h"

@implementation _ (Utility)

//noConflict /* NOT SUPPORTED: JavaScript-only */

+ (_IdentityBlock)identity
{
  return ^(id value) {
    return value;
  };
}

+ (_CollectionItemTestBlock)identityTruthy
{
  return ^(id value, ... /* KEY, COLLECTION */) {
    return _.isTruthy(value);
  };
}

+ (void(^)(I n, _TimesBlock iterator))times
{
  return ^(I n, _TimesBlock iterator) {
    for (I i = 0; i < n; i++) iterator(i);
  };
}

//mixin /* NOT SUPPORTED: JavaScript-only: use Objective-C categories on '_' instead */

+ (NSS*(^)(NSS* prefix))uniqueId
{
  return ^(NSS* prefix) {
    static I id = 0; id++;
    return prefix ? [NSString stringWithFormat:@"%@%d", prefix, id] : [NSString stringWithFormat:@"%d", id];
  };
}

/* NOT SUPPORTED: JavaScript-only */
//+ (NSS*(^)(NSS* string))escape
//{
//  return ^(NSS* string) {
//    return [string gtm_stringByEscapingForHTML];
//  };
//}

+ (NSO*(^)(NSO* object, id property))result
{
  return ^NSO*(NSO* object, id property) {
    if (object == nil) return nil;
    if (_.isFunction(property, object))
      return ((NSS*)property).call(object, nil);
    else
      return object.get(property);
  };
}

//template /* NOT SUPPORTED: JavaScript-only */

@end
