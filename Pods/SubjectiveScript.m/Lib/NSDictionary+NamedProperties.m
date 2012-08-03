//
//  NSDictionary+NamedProperties.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/31/12.
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

#import "NSDictionary+NamedProperties.h"
#import <objc/runtime.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#define BLOCK_TO_IMPL(_b) imp_implementationWithBlock((void*)CFBridgingRetain(_b))
#elif TARGET_OS_MAC
#define BLOCK_TO_IMPL(_b) imp_implementationWithBlock(_b)
#endif

static const char* NamedPropertiesKey = "SSNP";

@implementation NSDictionary (NamedProperties)

- (NSMutableDictionary*)getPropertiesContainer
{
  NSMutableDictionary* properties = objc_getAssociatedObject(self, NamedPropertiesKey);
  if (properties) return properties;

  // add the properties
  properties = NSMutableDictionary.new; // keep mutable since need to add to it during initializers
  objc_setAssociatedObject(self, NamedPropertiesKey, properties, OBJC_ASSOCIATION_RETAIN);
  return properties;
}

+ (void)setupNamedProperties
{
  ///////////////////////////
  // Add Instance Methods - NSDictionary
  ///////////////////////////
  if ([self.class isSubclassOfClass:NSDictionary.class])
  {
    // - (id)initWithObjects:(const id [])objects forKeys:(const id [])keys count:(NSUInteger)cnt;
    class_addMethod(self.class, @selector(initWithObjects:forKeys:count:),
      BLOCK_TO_IMPL(^(NSDictionary* obj, const id objects[], const id keys[], NSUInteger count) {
        NSMutableDictionary* properties = obj.getPropertiesContainer;
        for (NSUInteger index=0; index<count; index++) {
          [properties setObject:objects[index] forKey:keys[index]];
        }
        return obj;
      }),
      method_getDescription(class_getInstanceMethod(NSDictionary.class, @selector(initWithObjects:forKeys:count:)))->types
    );

    // - (NSUInteger)count;
    class_addMethod(self.class, @selector(count),
      BLOCK_TO_IMPL(^(NSDictionary* obj) {
        return obj.getPropertiesContainer.count;
      }),
      method_getDescription(class_getInstanceMethod(NSDictionary.class, @selector(count)))->types
    );

    // - (id)objectForKey:(id)aKey;
    class_addMethod(self.class, @selector(objectForKey:),
      BLOCK_TO_IMPL(^(NSDictionary* obj, id key) {
        return [obj.getPropertiesContainer objectForKey:key];
      }),
      method_getDescription(class_getInstanceMethod(NSDictionary.class, @selector(objectForKey:)))->types
    );

    // - (NSEnumerator *)keyEnumerator;
    class_addMethod(self.class, @selector(keyEnumerator),
      BLOCK_TO_IMPL(^(NSDictionary* obj) {
        return [obj.getPropertiesContainer keyEnumerator];
      }),
      method_getDescription(class_getInstanceMethod(NSDictionary.class, @selector(keyEnumerator)))->types
    );
    
    // - (NSArray *)allKeys;
    class_addMethod(self.class, @selector(allKeys),
      BLOCK_TO_IMPL(^(NSDictionary* obj) {
        return obj.getPropertiesContainer.allKeys;
      }),
      method_getDescription(class_getInstanceMethod(NSDictionary.class, @selector(allKeys)))->types
    );

    // - (NSArray *)allKeysForObject:(id)anObject;
    class_addMethod(self.class, @selector(allKeysForObject:),
      BLOCK_TO_IMPL(^(NSDictionary* obj, id object) {
        return [obj.getPropertiesContainer allKeysForObject:object];
      }),
      method_getDescription(class_getInstanceMethod(NSDictionary.class, @selector(allKeysForObject:)))->types
    );

    // - (NSArray *)allValues;
    class_addMethod(self.class, @selector(allValues),
      BLOCK_TO_IMPL(^(NSDictionary* obj) {
        return obj.getPropertiesContainer.allValues;
      }),
      method_getDescription(class_getInstanceMethod(NSDictionary.class, @selector(allValues)))->types
    );
  }

  ///////////////////////////
  // Add Instance Methods - NSDictionary
  ///////////////////////////
  if ([self.class isSubclassOfClass:NSMutableDictionary.class])
  {
    // - (void)removeObjectForKey:(id)aKey;
    class_addMethod(self.class, @selector(removeObjectForKey:),
      BLOCK_TO_IMPL(^(NSDictionary* obj, id key) {
        [obj.getPropertiesContainer removeObjectForKey:key];
      }),
      method_getDescription(class_getInstanceMethod(NSMutableDictionary.class, @selector(removeObjectForKey:)))->types
    );

    // - (void)setObject:(id)anObject forKey:(id)aKey
    class_addMethod(self.class, @selector(setValue:forKey:),
      BLOCK_TO_IMPL(^(NSDictionary* obj, id value, id key) {
        [obj.getPropertiesContainer setValue:value forKey:key];
      }),
      method_getDescription(class_getInstanceMethod(NSMutableDictionary.class, @selector(setValue:forKey:)))->types
    );
  }
  
  // TODO: add all the necessary functions
}

// Thank you to Jens Alfke for his CouchDynamicObject to show me that dynamic properties were possible: https://github.com/couchbaselabs/CouchCocoa/blob/master/Model/CouchDynamicObject.m
+ (BOOL)resolveNamedProperties:(SEL)selector
{
  NSString* name = [NSString stringWithUTF8String:sel_getName(selector)];
  BOOL isSetter = [name hasPrefix:@"set"];

  // signature checker for getters and setters
  NSRange colonsRange = [name rangeOfString:@":"];
  if (
    [name hasPrefix:@"_"] || // internal
    (isSetter && [name hasSuffix:@":"] && (colonsRange.location!=name.length-1)) || // not quite a setter
    (!isSetter && (colonsRange.length!=0)) // not a getter
  ) {
    return [super resolveInstanceMethod:selector];
  }

  // setter
  if (isSetter)
  {
    unichar firstLetter = [name characterAtIndex:3];
    name = [NSString stringWithFormat:@"%@%@",[[NSString stringWithCharacters:&firstLetter length:1] lowercaseString], [name substringWithRange:NSMakeRange(4, name.length-5)]];
    
    // not mutable
    if (![self isSubclassOfClass:NSMutableDictionary.class])
    {
      NSString* message = [NSString stringWithFormat:@"SubjectiveScript: Setter shouldn't be called for property '%@' on '%@' because not NSMutableDictionary. Skipping.", name, NSStringFromClass(self.class)];
#ifdef DEBUG
      @throw [NSException exceptionWithName:@"TypeError" reason:message userInfo:nil];
#else
      NSLog(@"%@", message);
      return NO;
#endif
    }
  }

  objc_property_t propertyInfo = class_getProperty(self.class, name.UTF8String);
  if (!propertyInfo) return [super resolveInstanceMethod:selector]; // not a property

  // find the class that declared the property
  Class owningClass = self.class;
  while(owningClass.superclass && class_getProperty(owningClass.superclass, name.UTF8String)==propertyInfo) {
    owningClass = owningClass.superclass;
  }

  // look for a mismatch or invalid type
  const char* attrs = property_getAttributes(propertyInfo);
  NSArray* typeComponents = [[NSString stringWithUTF8String:attrs] componentsSeparatedByString:@","];
  for (NSString* component in typeComponents) {
    // read only mismatch
    if (([component characterAtIndex:0] == 'R') && isSetter) {
      NSString* message = [NSString stringWithFormat:@"SubjectiveScript: Setter is read-only for property '%@' on '%@'.", name, NSStringFromClass(self.class)];
#ifdef DEBUG
      @throw [NSException exceptionWithName:@"TypeError" reason:message userInfo:nil];
#else
      NSLog(@"%@", message);
      return NO;
#endif
    }
  }
  
  // create a custom setter or getter based on the type of property
  IMP implementation;
  if (isSetter) {
    if (attrs[1]==_C_ID)
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj, id value) {
        [obj.getPropertiesContainer setValue:value forKey:name];
      });
    else if ((attrs[1]==_C_CHR) || (attrs[1]==_C_UCHR) || (attrs[1]==_C_USHT) || (attrs[1]==_C_INT) || (attrs[1]==_C_UINT) || (attrs[1]==_C_LNG) || (attrs[1]==_C_ULNG)|| (attrs[1]==_C_LNG_LNG) || (attrs[1]==_C_ULNG_LNG))
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj, NSInteger value) {
        [obj.getPropertiesContainer setValue:[NSNumber numberWithInteger:value] forKey:name];
      });
    else if(attrs[1]==_C_FLT)
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj, float value) {
        [obj.getPropertiesContainer setValue:[NSNumber numberWithFloat:value] forKey:name];
      });
    else if(attrs[1]==_C_DBL)
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj, double value) {
        [obj.getPropertiesContainer setValue:[NSNumber numberWithDouble:value] forKey:name];
      });
    else if(attrs[1]==_C_BOOL)
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj, bool value) {
        [obj.getPropertiesContainer setValue:[NSNumber numberWithBool:value] forKey:name];
      });
    else {
      NSLog(@"SubjectiveScript: Unsupported type encountered for property '%@' on '%@'. Skipping.", name, NSStringFromClass(owningClass));
      return NO;
    }
  }
  else {
    if (attrs[1]==_C_ID)
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj) {
        return [obj.getPropertiesContainer valueForKey:name];
      });
    else if ((attrs[1]==_C_CHR) || (attrs[1]==_C_UCHR) || (attrs[1]==_C_USHT) || (attrs[1]==_C_INT) || (attrs[1]==_C_UINT) || (attrs[1]==_C_LNG) || (attrs[1]==_C_ULNG)|| (attrs[1]==_C_LNG_LNG) || (attrs[1]==_C_ULNG_LNG))
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj) {
        NSNumber* value = [obj.getPropertiesContainer valueForKey:name];
        return value ? value.integerValue : 0;
      });
    else if(attrs[1]==_C_FLT)
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj) {
        NSNumber* value = [obj.getPropertiesContainer valueForKey:name];
        return value ? value.floatValue : 0;
      });
    else if(attrs[1]==_C_DBL)
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj) {
        NSNumber* value = [obj.getPropertiesContainer valueForKey:name];
        return value ? value.doubleValue : 0;
      });
    else if(attrs[1]==_C_BOOL)
      implementation = BLOCK_TO_IMPL(^(NSDictionary* obj) {
        NSNumber* value = [obj.getPropertiesContainer valueForKey:name];
        return value ? value.boolValue : false;
      });
    else {
      NSLog(@"SubjectiveScript: Unsupported type encountered for property '%@' on '%@'. Skipping.", name, NSStringFromClass(owningClass));
      return NO;
    }
  }

  class_addMethod(owningClass, selector, implementation, attrs);
  return YES;
}

@end