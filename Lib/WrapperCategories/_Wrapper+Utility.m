//
//  _Wrapper+Utility.m
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

#import "_Wrapper+Utility.h"
#import "_Wrapper+Private.h"
#import "_+Utility.h"

@implementation _Wrapper (Utility)

//noConflict /* NOT SUPPORTED: JavaScript-only */

//- (_IdentityBlock)identity; /* NOT WRAPPED */
//- (_ItemTestBlock)identityTruthy; /* SPECIALIZED */ /* NOT WRAPPED */

- (_Wrapper*(^)(_TimesBlock iterator))times
{
  return ^(_TimesBlock iterator) {
    _.times(self.I, iterator);
    return self;
  };
}

//mixin /* NOT SUPPORTED: JavaScript-only: use Objective-C categories on '_' instead */

//- (NSS*(^)(NSS* prefix))uniqueId; /* NOT WRAPPED */

//escape /* NOT SUPPORTED: JavaScript-only...could be implemented with GTMNSString+HTML, but currently not ARC compatible and adds significant size to the library */

- (_Wrapper*(^)(id property))result
{
  return ^(id property) {
    return _.chain(_.result(self.value(), property));
  };
}

//template /* NOT SUPPORTED: JavaScript-only */

@end
