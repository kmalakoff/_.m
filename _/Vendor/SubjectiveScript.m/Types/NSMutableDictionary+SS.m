//
//  NSMutableDictionary+SS.m
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

#import "NSMutableDictionary+SS.h"
#import "NSString+SS.h"
#import "NSNumber+SS.h"
#import <objc/runtime.h>

static const char* SSNamedPropertiesKey = "SSNP";

@implementation NSMutableDictionary (Object)

+ (O*(^)(UI capacity))newC
{
  return ^(UI capacity) {
    return [O dictionaryWithCapacity:capacity];
  };
}

- (O*(^)())toMutable { return ^{ return self; }; }

- (NSO*(^)(id key, SSGetOrAddBlock add))getOrAdd
{
  return ^(id key, SSGetOrAddBlock add) {
    id value = [self objectForKey:key];
    if (value) return value;
    
    // create a new one
    value = add();
    [self setValue:value forKey:key];
    return value;
  };
}

- (O*(^)(id key, id value))set
{
  return ^(id key, id value) {
    if (!value) value = NSNull.null;
    [self setValue:value forKey:key];
    return self;
  };
}

- (O*(^)(const KV* values /* NIL_TERMINATION */))setKV
{
  return ^(const KV* values /* NIL_TERMINATION */) {
    for (const id* pair = (const id*) values; *pair != nil; pair+=2) {
      id value = pair[1];
      [self setValue:value ? value : NSNull.null forKey:pair[0]];
    }
    return self;
  };
}

// Thank you to Jens Alfke for his CouchDynamicObject to show me that dynamic properties were possible: https://github.com/couchbaselabs/CouchCocoa/blob/master/Model/CouchDynamicObject.m
+ (BOOL)resolveInstanceMethod:(SEL)selector
{
  NSS* name = [NSS stringWithUTF8String:sel_getName(selector)];
  BOOL isSetter = name.startsWith(@"set");
  
  // signature checker for getters and setters
  NSRange colonsRange = [name rangeOfString:@":"];
  if (
    name.startsWith(@"_") || // internal
    (isSetter && name.endsWith(@":") && (colonsRange.location!=name.length-1)) || // not quite a setter
    (!isSetter && (colonsRange.length!=0)) // not a getter
  ) {
    return [super resolveInstanceMethod:selector];
  }

  // setter
  if (isSetter)
  {
    unichar firstLetter = [name characterAtIndex:3];
    name = [NSS stringWithFormat:@"%@%@",[[NSS stringWithCharacters:&firstLetter length:1] lowercaseString], [name substringWithRange:NSMakeRange(4, name.length-5)]];
  }

  objc_property_t propertyInfo = class_getProperty(self.class, name.UTF8String);
  if (!propertyInfo) return [super resolveInstanceMethod:selector]; // not a property

  // find the class that declared the property
  Class owningClass = self.class;
  Class superClass = class_getSuperclass(owningClass);
  while(superClass && class_getProperty(superClass, name.UTF8String)==propertyInfo) {
    owningClass = superClass; superClass = class_getSuperclass(owningClass);
  }

  // look for a mismatch or invalid type
  const char* attrs = property_getAttributes(propertyInfo);
  NSA* typeComponents = [[S stringWithUTF8String:attrs] componentsSeparatedByString:@","];
  for (NSS* component in typeComponents) {
    // read only mismatch
    if (([component characterAtIndex:0] == 'R') && isSetter) {
#ifdef DEBUG
        @throw [NSException exceptionWithName:@"TypeError" reason:@"SubjectiveScript: Setter is read-only for property '%@' on '%@'." userInfo:nil];
#else
        NSLog(@"SubjectiveScript: Setter is read-only for property '%@' on '%@'. Skipping.", name, NSStringFromClass(owningClass));
        return NO;
#endif
    }
  }
  
  // create an NSMutableDictionary to hold the properties
  O* dynamicProperties = objc_getAssociatedObject(self, SSNamedPropertiesKey);
  if (!dynamicProperties) {
    dynamicProperties = O.new;
    objc_setAssociatedObject(self, SSNamedPropertiesKey, dynamicProperties, OBJC_ASSOCIATION_RETAIN);
  }
  
  // create a custom setter or getter based on the type of property
  IMP implementation;
  if (isSetter) {
    if (attrs[1]==_C_ID)
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj, id value) {
        [dynamicProperties setValue:value forKey:name];
      }));
    else if ((attrs[1]==_C_CHR) || (attrs[1]==_C_UCHR) || (attrs[1]==_C_USHT) || (attrs[1]==_C_INT) || (attrs[1]==_C_UINT) || (attrs[1]==_C_LNG) || (attrs[1]==_C_ULNG))
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj, I value) {
        [dynamicProperties setValue:N.I(value) forKey:name];
      }));
    else if(attrs[1]==_C_FLT)
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj, F value) {
        [dynamicProperties setValue:N.F(value) forKey:name];
      }));
    else if(attrs[1]==_C_DBL)
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj, D value) {
        [dynamicProperties setValue:N.D(value) forKey:name];
      }));
    else if(attrs[1]==_C_BOOL)
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj, bool value) {
        [dynamicProperties setValue:N.B(value) forKey:name];
      }));
    else {
      NSLog(@"SubjectiveScript: Unsupported type encountered for property '%@' on '%@'. Skipping.", name, NSStringFromClass(owningClass));
      return NO;
    }
  }
  else {
    if (attrs[1]==_C_ID)
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj) {
        return [dynamicProperties valueForKey:name];
      }));
    else if ((attrs[1]==_C_CHR) || (attrs[1]==_C_UCHR) || (attrs[1]==_C_USHT) || (attrs[1]==_C_INT) || (attrs[1]==_C_UINT) || (attrs[1]==_C_LNG) || (attrs[1]==_C_ULNG))
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj) {
        N* value = [dynamicProperties valueForKey:name];
        return value ? value.I : 0;
      }));
    else if(attrs[1]==_C_FLT)
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj) {
        N* value = [dynamicProperties valueForKey:name];
        return value ? value.F : 0;
      }));
    else if(attrs[1]==_C_DBL)
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj) {
        N* value = [dynamicProperties valueForKey:name];
        return value ? value.D : 0;
      }));
    else if(attrs[1]==_C_BOOL)
      implementation = imp_implementationWithBlock((void*)CFBridgingRetain(^(O* obj) {
        N* value = [dynamicProperties valueForKey:name];
        return value ? value.B : false;
      }));
    else {
      NSLog(@"SubjectiveScript: Unsupported type encountered for property '%@' on '%@'. Skipping.", name, NSStringFromClass(owningClass));
      return NO;
    }
  }

  class_addMethod(owningClass, selector, implementation, attrs);
  return YES;
}

@end
