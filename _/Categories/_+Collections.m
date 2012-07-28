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
#ifdef DEBUG
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"each xpecting NSArray or NSDictionary or nil");
#endif

    if (_.isNull(obj)) return;

    else if (_.isArray(obj)) {
      NSA* array = obj;
      if(!array.length) return;

      I count = [array count];
      for (I index=0; index<count; index++) {
        iterator([array objectAtIndex:index], N.I(index), obj);
      }
    }
    else {
      NSD* dictionary = obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        iterator(value, key, obj);
      }];
    }
  };
}
+ (void(^)(id obj, _EachBlock iterator))forEach { return self.each; }  // ALIAS
+ (B(^)(id obj, _EachWithStopBlock iterator))eachWithStop
{
  return ^B(id obj, _EachWithStopBlock iterator) {
#ifdef DEBUG
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"eachWithStop expecting NSArray or NSDictionary or nil");
#endif

    if (_.isNull(obj)) return YES;

    else if (_.isArray(obj)) {
      NSA* array = obj;
      if(!array.length) return YES;

      I count = [array count];
      for (I index=0; index<count; index++) {
        if (!iterator([array objectAtIndex:index], N.I(index), obj))
          return NO;
      }

      return YES; /* processed all */
    }
    else {
      __block B processedWithoutStop = YES;
      NSD* dictionary = obj;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if (!iterator(value, key, obj)) {
          processedWithoutStop = NO;
          *stop = YES;
        }
      }];
      
      return processedWithoutStop; /* processed all */
    }
  };
}

+ (A*(^)(NSO* obj, _MapBlock iterator))map
{
  return ^A*(NSO* obj, _MapBlock iterator) {
#ifdef DEBUG
    NSAssert(_.isArray(obj) || _.isDictionary(obj) || _.isNull(obj), @"map expecting NSArray or NSDictionary or nil");
#endif

    if (_.isNull(obj))
      return A.new;

    else if (_.isArray(obj)) {
      NSA* array = (NSA*) obj;
      if(!array.length) return A.new;

      A* result = [A arrayWithCapacity:array.length];
      I count = [array count];
      for (I index=0; index<count; index++) {
        id mapped = iterator([array objectAtIndex:index], N.I(index), obj);
        if (mapped)
          [result addObject:mapped];
      }

      return result;
    }
    else {
      NSD* dictionary = (NSD*) obj;

      A* result = [A arrayWithCapacity:obj.length];
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        id mapped = iterator(value, key, obj);
        if (mapped)
          [result addObject:mapped];
      }];
      
      return result;
    }
    return nil;
  };
}
+ (A*(^)(id obj, _MapBlock iterator))collect { return self.map; } // ALIAS

+ (id(^)(id obj, _ReduceBlock iterator, id memo))reduce
{
  return ^(id obj, _ReduceBlock iterator, id memo) {
    if (!obj) {
#ifdef DEBUG
      if (!memo) @throw [NSException exceptionWithName:@"TypeError" reason:@"null without inital value" userInfo:nil];
#endif
      return memo;
    }
  
    __block id internalMemo = memo;
    __block BOOL initial = false;
    if (obj == nil) obj = A.new;
    _.each(obj, ^(NSO* value, ... /* KEY, COLLECTION */) {
      initial = true;
      if (!internalMemo) internalMemo = [[NSClassFromString(value.mutableClassName) alloc] init];
      
      _ARGS_KEY(value);
      internalMemo = iterator(internalMemo, value, key);
    });
#ifdef DEBUG
    if (!initial) @throw [NSException exceptionWithName:@"TypeError" reason:@"Reduce of empty array with no initial value" userInfo:nil];
#endif
    return internalMemo;
  };
}
+ (id(^)(id obj, _ReduceBlock iterator, id memo))foldl { return self.reduce; } // ALIAS
+ (id(^)(id obj, _ReduceBlock iterator, id memo))inject { return self.reduce; } // ALIAS

+ (id(^)(id obj, _ReduceBlock iterator, id memo))reduceRight
{
  return ^(id obj, _ReduceBlock iterator, id memo) {
    if (!obj) {
#ifdef DEBUG
      if (!memo) @throw [NSException exceptionWithName:@"TypeError" reason:@"null without inital value" userInfo:nil];
#endif
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
      internalMemo = iterator(internalMemo, value, N.I(index), obj);
    }
#ifdef DEBUG
    if (!initial) @throw [NSException exceptionWithName:@"TypeError" reason:@"Reduce of empty array with no initial value" userInfo:nil];
#endif
    return internalMemo;
  };
}
+ (id(^)(id obj, _ReduceBlock iterator, id memo))foldr { return self.reduceRight; } // ALIAS

+ (id(^)(id obj, _FindBlock iterator))find
{
  return ^(id obj, _FindBlock iterator) {
    __block NSO* result;
    _.any(obj, ^B(id value, ... /* KEY, COLLECTION */) {
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

+ (A*(^)(id obj, _CollectionItemTestBlock iterator))filter
{
  return ^(id obj, _CollectionItemTestBlock iterator) {
    A* results = A.new;
    if (obj == nil) return results;
    _.each(obj, ^(id value, ... /* KEY, COLLECTION */) {
      _ARGS_KEY(value);
      if (iterator(value, key)) results.push(value);
    });
    return results;
  };
}
+ (A*(^)(id obj, _CollectionItemTestBlock iterator))select { return self.filter; } // ALIAS

+ (A*(^)(id obj, _CollectionItemTestBlock iterator))reject
{
  return ^(id obj, _CollectionItemTestBlock iterator) {
    A* results = A.new;
    if (obj == nil) return results;
    _.each(obj, ^(id value, ... /* KEY, COLLECTION */) {
      _ARGS_KEY(value);
      if (!iterator(value, key)) results.push(value);
    });
    return results;
  };
}

+ (B(^)(id obj, _CollectionItemTestBlock iterator))all
{
  return ^B(id obj, _CollectionItemTestBlock iterator) {
    if (obj == nil) return YES;
    return _.eachWithStop(obj, iterator);
  };
}
+ (B(^)(id obj, _CollectionItemTestBlock iterator))every {return self.all; } // ALIAS

+ (B(^)(id obj, _CollectionItemTestBlock iterator))any
{
  return ^B(id obj, _CollectionItemTestBlock iterator) {
    if (!iterator) iterator = _.identityTruthy;
    __block BOOL result = NO;
    if (obj == nil) return result;
    _.eachWithStop(obj, ^B(id value, ... /* KEY, COLLECTION */) {
      _ARGS_KEY(value);
      if (result || (result = iterator(value, key)))
        return NO;
      return YES;
    });
    return !!result;
  };
}
+ (B(^)(id obj, _CollectionItemTestBlock iterator))some { return self.any; }

+ (B(^)(id obj, id target))include
{
  return ^B(id obj, id target) {
    BOOL found = NO;
    if (obj == nil) return found;
    found = _.any(obj, ^B(id value, ... /* KEY, COLLECTION */) {
      return value == target;
    });
    return found;
  };
}
+ (B(^)(id obj, id target))contains { return self.include; } // ALIAS

+ (NSO*(^)(id obj, NSS* methodName, id arg1, ... /* NIL_TERMINATION */))invoke
{
  return ^NSO*(id obj, NSS* methodName, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);

    return _.map(obj, ^(NSO* value, ... /* KEY, COLLECTION */) {
      return methodName.apply(value, arguments);
    });
  };
}

+ (NSO*(^)(id obj, NSS* keyPath))pluck
{
  return ^NSO*(id obj, NSString *keyPath) {
#ifdef DEBUG
    NSAssert(_.isArray(obj) || _.isDictionary(obj), @"each expecting NSArray or NSDictionary");
#endif

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
      _.each(obj, ^(NSO* value, ... /* KEY, COLLECTION */) {
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
      _.each(obj, ^(NSO* value, ... /* KEY, COLLECTION */) {
        NSO* computed = iterator ? iterator(value) : value;
        computed >= result.get(@"computed") && (result = OKV({@"value", value}, {@"computed", computed}));
      });
      return (NSO*) result.get(@"value");
    }
  };
}

+ (id(^)(id obj, id iteratorOrKey /* _SortByBlock or key */))sortBy
{
  return ^(id obj, id iteratorOrKey) {
#ifdef DEBUG
    NSAssert(_.isArray(obj) || _.isDictionary(obj), @"each expecting NSArray or NSDictionary");
#endif

    _SortedIndexBlock iterator = _.isBlock(iteratorOrKey) ? (_SortedIndexBlock) iteratorOrKey : ^(NSO* value){ 
      return value.get(iteratorOrKey); 
    };

    return _.chain(obj)
      .map(^(NSO* value, ... /* KEY, COLLECTION */) {
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

+ (O*(^)(id obj, id iteratorOrKey /* _GroupByBlock or key */))groupBy
{
  return ^(id obj, id iteratorOrKey) {
#ifdef DEBUG
    NSAssert(_.isArray(obj) || _.isDictionary(obj), @"each expecting NSArray or NSDictionary");
#endif

    _GroupByBlock iterator = _.isBlock(iteratorOrKey) ? (_GroupByBlock) iteratorOrKey : ^(NSO* value, ... /* KEY, COLLECTION */){
      return value.get(iteratorOrKey); 
    };
    
    __block O* result = O.new;
    _.each(obj, ^(id value, ... /* KEY, COLLECTION */) {
      _ARGS_KEY(value);
      key = iterator(value, key, obj);
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
    _.each(obj, ^(id value, ... /* KEY, COLLECTION */) {
      _ARGS_INDEX(value);
      I rand = arc4random() % (index + 1);
      [shuffled exchangeObjectAtIndex:rand withObjectAtIndex:index];
    });
    return shuffled;
  };
}

+ (NSA*(^)(id obj))toArray
{
  return ^NSA*(id obj) {
    if (!obj)                                         return NSA.new;
    if (_.isArray(obj))                               return ((NSA*)obj).copy;
//    if (_.isArguments(obj))                           return ((NSA*)obj).copy;  /* NOT NEEDED: Arugements are an array */
    if ([obj respondsToSelector:@selector(toArray)])  return [obj performSelector:@selector(toArray)];
    if (_.isFunction(@"toArray", obj))                return @"toArray".call(obj, nil);
    return _.values(obj);
  };
}

+ (UI(^)(id obj))size {
  return ^UI(id obj) {
    if (_.isArray(obj))          return ((NSA*)obj).count;
    if (_.isDictionary(obj))     return ((NSD*)obj).count;
    return 0;
  };
}

@end
