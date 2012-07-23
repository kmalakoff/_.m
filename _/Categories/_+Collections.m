//
//  _+Collections.m
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

#import "_+Collections.h"
#import "_+Objects.h"
#import "_+Arrays.h"
#import "_+Utility.h"
#import "_+Extensions.h"
#import "_Wrapper+Collections.h"
#import "SubjectiveScript.h"

@implementation _ (Collections)

+ (void(^)(id obj, _EachBlock iterator))each
{
  return ^(id obj, _EachBlock iterator) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"each xpecting NSArray or NSDictionary or nil");

    if (_.isNull(obj)) return;

    else if (_.isArray(obj)) {
      NSA* array = obj;
      if(!array.length) return;

      I count = [array count];
      for (I index=0; index<count; index++) {
        iterator([array objectAtIndex:index], N.I(index));
      }
    }
    else {
      NSD* dictionary = obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        iterator(value, key);
      }];
    }
  };
}
+ (void(^)(id obj, _EachBlock iterator))forEach { return self.each; }  // ALIAS
+ (B(^)(id obj, _ValueKeyTestBlock iterator))eachWithStop
{
  return ^B(id obj, _ValueKeyTestBlock iterator) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"eachWithStop expecting NSArray or NSDictionary or nil");

    if (_.isNull(obj)) return YES;

    else if (_.isArray(obj)) {
      NSA* array = obj;
      if(!array.length) return YES;

      I count = [array count];
      for (I index=0; index<count; index++) {
        if (!iterator([array objectAtIndex:index], N.I(index)))
          return NO;
      }

      return YES; /* processed all */
    }
    else {
      __block B processedWithoutStop = YES;
      NSD* dictionary = obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if (!iterator(value, key)) {
          processedWithoutStop = NO;
          *stop = YES;
        }
      }];
      
      return processedWithoutStop; /* processed all */
    }
  };
}

+ (A*(^)(NSO* obj, _ValueKeyMapBlock iterator))map
{
  return ^(NSO* obj, _ValueKeyMapBlock iterator) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or nil");

    if (_.isNull(obj))
      return A.new;

    else if (_.isArray(obj)) {
      NSA* array = (NSA*) obj;
      if(!array.length) return A.new;

      A* result = [A arrayWithCapacity:array.length];
      I count = [array count];
      for (I index=0; index<count; index++) {
        id mapped = iterator([array objectAtIndex:index], N.I(index));
        if (mapped)
          [result addObject:mapped];
      }

      return result;
    }
    else {
      NSD* dictionary = (NSD*) obj;

      O* result = O.new;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        id mapped = iterator(value, key);
        if (mapped)
          [result setObject:mapped forKey:key];
      }];
      
      return (id) result;
    }
    return nil;
  };
}
+ (A*(^)(id obj, _ValueKeyMapBlock iterator))collect { return self.map; } // ALIAS

+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))reduce
{
  return ^(id obj, _MemoValueKeyMapBlock iterator, id memo) {
    if (!obj) {
      if (!memo) @throw [NSException exceptionWithName:@"TypeError" reason:@"null without inital value" userInfo:nil];
      return memo;
    }
  
    __block id internalMemo = memo;
    __block BOOL initial = false;
    if (obj == nil) obj = A.new;
    _.each(obj, ^(NSO* value, id key) {
      initial = true;
      if (!internalMemo) internalMemo = [[NSClassFromString(value.mutableClassName) alloc] init];
      internalMemo = iterator(internalMemo, value, key);
    });
    if (!initial) @throw [NSException exceptionWithName:@"TypeError" reason:@"Reduce of empty array with no initial value" userInfo:nil];
    return internalMemo;
  };
}
+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))foldl { return self.reduce; } // ALIAS
+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))inject { return self.reduce; } // ALIAS

+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))reduceRight
{
  return ^(id obj, _MemoValueKeyMapBlock iterator, id memo) {
    if (!obj) {
      if (!memo) @throw [NSException exceptionWithName:@"TypeError" reason:@"null without inital value" userInfo:nil];
      return memo;
    }

    // do it the memory intensive way for dictionaries
    if (_.isDictionary(obj)) return _.reduce(_.toArray(obj).reverse().mutableCopy, iterator, memo);

    id internalMemo = memo;
    __block BOOL initial = false;
    if (obj == nil) obj = A.new;
    A* array = obj;
    for (I index=array.count-1; index>=0; index--) {
      NSO* value = [array objectAtIndex:index];
      initial = true;
      if (!internalMemo) internalMemo = [[NSClassFromString(value.mutableClassName) alloc] init];
      internalMemo = iterator(internalMemo, value, N.I(index));
    }
    if (!initial) @throw [NSException exceptionWithName:@"TypeError" reason:@"Reduce of empty array with no initial value" userInfo:nil];
    return internalMemo;
  };
}
+ (id(^)(id obj, _MemoValueKeyMapBlock iterator, id memo))foldr { return self.reduceRight; } // ALIAS

+ (id(^)(id obj, _FindBlock iterator))find
{
  return ^(id obj, _FindBlock iterator) {
    __block NSO* result;
    _.any(obj, ^B(id value, id key) {
      if (iterator(value)) {
        result = value;
        return true;
      }
      return false;
    });
    return result;
  };
}

+ (id(^)(id obj, _FindBlock iterator))detect { return self.find; } // ALIAS

+ (A*(^)(id obj, _ValueKeyTestBlock iterator))filter
{
  return ^(id obj, _ValueKeyTestBlock iterator) {
    A* results = A.new;
    if (obj == nil) return results;
    _.each(obj, ^(id value, id key) {
      if (iterator(value, key)) results.push(value);
    });
    return results;
  };
}
+ (A*(^)(id obj, _ValueKeyTestBlock iterator))select { return self.filter; } // ALIAS

+ (A*(^)(id obj, _ValueKeyTestBlock iterator))reject
{
  return ^(id obj, _ValueKeyTestBlock iterator) {
    A* results = A.new;
    if (obj == nil) return results;
    _.each(obj, ^(id value, id key) {
      if (!iterator(value, key)) results.push(value);
    });
    return results;
  };
}

+ (B(^)(id obj, _ValueKeyTestBlock iterator))all
{
  return ^B(id obj, _ValueKeyTestBlock iterator) {
    if (obj == nil) return YES;
    return _.eachWithStop(obj, iterator);
  };
}
+ (B(^)(id obj, _ValueKeyTestBlock iterator))every {return self.all; } // ALIAS

+ (B(^)(id obj, _ValueKeyTestBlock iterator))any
{
  return ^B(id obj, _ValueKeyTestBlock iterator) {
    if (!iterator) iterator = _.identityVKTB;
    __block BOOL result = NO;
    if (obj == nil) return result;
    _.eachWithStop(obj, ^B(id value, id key) {
      if (result || (result = iterator(value, key))) 
        return NO;
      return YES;
    });
    return !!result;
  };
}
+ (B(^)(id obj, _ValueKeyTestBlock iterator))some { return self.any; }

+ (B(^)(id obj, id target))include
{
  return ^B(id obj, id target) {
    BOOL found = NO;
    if (obj == nil) return found;
    found = _.any(obj, ^B(id value, id key) {
      return value == target;
    });
    return found;
  };
}
+ (B(^)(id obj, id target))contains { return self.include; } // ALIAS

+ (NSO*(^)(id obj, NSS* methodName, id arg1, ...))invoke
{
  return ^NSO*(id obj, NSS* methodName, id arg1, ...) {
    ARGS_AO(arguments, arg1);

    return _.map(obj, ^(NSO* value, id key) {
      return methodName.apply(value, arguments);
    });
  };
}

+ (NSO*(^)(id obj, NSS* keyPath))pluck
{
  return ^NSO*(id obj, NSString *keyPath) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj), @"each expecting NSArray or NSDictionary");

    if (_.isArray(obj)) {
      A* result = A.new;
      for (NSO* item in (NSA*)obj) {
        id value = item.get(keyPath);
        result.push(value ? value : NSNull.null);
      }
      return result;
    }
    else
      return ((NSD*)obj).get(keyPath);
  };
}

+ (NSO*(^)(NSO* obj, _MaxBlock iterator))max
{
  return ^NSO*(id obj, _MaxBlock iterator) {
    if (!iterator && _.isEmpty(obj))
      return NF_NEG_INFINITY;

    if (_.isArray(obj)) {
      NSA* array = obj;
      NSO* max = array.getAt(0);
      for (NSO* value in array) {
        NSO* computed = iterator ? iterator(value) : value;
        if ([max compare: computed] == NSOrderedAscending)
          max = value; 
      }
      return max;
    }  
    
    else {
      __block O* result = OKV({@"computed", ((NSD*)obj).objectEnumerator.nextObject});
      _.each(obj, ^(NSO* value, id key) {
        NSO* computed = iterator ? iterator(value) : value;
        computed <= result.get(@"computed") && (result = OKV({@"value", value}, {@"computed", computed}));
      });
      return (NSO*) result.get(@"value");
    }
  };
}

+ (NSO*(^)(NSO* obj, _MinBlock iterator))min
{
  return ^NSO*(id obj, _MinBlock iterator) {
    if (!iterator && _.isEmpty(obj))
      return NF_POS_INFINITY;

    if (_.isArray(obj)) {
      NSA* array = obj;
      NSO* min = array.getAt(0);
      for (NSO* value in array) {
        NSO* computed = iterator ? iterator(value) : value;
        if ([min compare: computed] == NSOrderedDescending)
          min = value; 
      }
      return min;
    }
    
    else
    {
      __block O* result = OKV({@"computed", ((NSD*)obj).objectEnumerator.nextObject});
      _.each(obj, ^(NSO* value, id key) {
        NSO* computed = iterator ? iterator(value) : value;
        computed >= result.get(@"computed") && (result = OKV({@"value", value}, {@"computed", computed}));
      });
      return (NSO*) result.get(@"value");
    }
  };
}

+ (id(^)(id obj, id iteratorOrKey))sortBy
{
  return ^(id obj, id iteratorOrKey) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj), @"each expecting NSArray or NSDictionary");

    _SortedIndexBlock iterator = _.isBlock(iteratorOrKey) ? (_SortedIndexBlock) iteratorOrKey : ^(NSO* value){ 
      return value.get(iteratorOrKey); 
    };

    return _.chain(obj)
      .map(^(NSO* value, id key) {
        return OKV({@"value", value}, {@"criteria", iterator(value)});
      })
      .sort(^(NSDictionary *left, NSDictionary *right) {
        id a = [left valueForKey:@"criteria"];
        id b = [right valueForKey:@"criteria"];
        return [a compare:b];
      })
      .pluck(@"value")
      .value();
  };
}

+ (O*(^)(id obj, id iteratorOrKey))groupBy
{
  return ^(id obj, id iteratorOrKey) {
    NSAssert(_.isArray(obj) || _.isDictionary(obj), @"each expecting NSArray or NSDictionary");

    _GroupByBlock iterator = _.isBlock(iteratorOrKey) ? (_GroupByBlock) iteratorOrKey : ^(NSO* value, id key){ 
      return value.get(iteratorOrKey); 
    };
    
    __block O* result = O.new;
    _.each(obj, ^(id value, id key) {
      key = iterator(value, key);
      A* values = (A*) result.getOrAdd(key, ^{ return A.new; });
      values.push(value);
    });
    return result;
  };
}

+ (I(^)(NSA* array, id obj, _SortedIndexBlock iterator))sortedIndex
{
  return ^(NSA* array, id obj, _SortedIndexBlock iterator) {
    if (!iterator) iterator = _.identity;
    NSO* value = iterator(obj);
    I low = 0, high = array.length;
    while (low < high) {
      I mid = (low + high) >> 1;
      ([iterator(array.getAt(mid)) compare:value] == NSOrderedAscending) ? (low = mid + 1) : (high = mid);
    }
    return low;
  };
}

+ (A*(^)(id obj))shuffle
{
  return ^(id obj) {
    __block A* shuffled = _.isArray(obj) ? ((NSA*)obj).mutableCopy : _.values(obj);
    _.each(obj, ^(id value, N* indexNumber) {
      I index = indexNumber.I;
      I rand = arc4random() % (index + 1);
      [shuffled exchangeObjectAtIndex:rand withObjectAtIndex:index];
    });
    return shuffled;
  };
}

+ (NSA*(^)(id obj))toArray
{
  return ^(id obj) {
    if (!obj)                                         return NSA.new;
    if (_.isArray(obj))                               return ((NSA*)obj).copy;
//    if (_.isArguments(obj))                           return ((NSA*)obj).copy;  /* NOT NEEDED: Arugements are an array */
    if ([obj respondsToSelector:@selector(toArray)])  return (NSA*) [obj performSelector:@selector(toArray)];
    return _.values(obj);
  };
}

+ (UI(^)(id obj))size {
  return ^(id obj) {
    if (_.isArray(obj))          return ((NSA*)obj).count;
    if (_.isDictionary(obj))     return ((NSD*)obj).count;
    return 0;
  };
}

@end
