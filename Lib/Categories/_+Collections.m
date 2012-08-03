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
#import "_Wrapper+JavaScript.h"
#import "SubjectiveScript.h"

@implementation _ (Collections)

+ (void(^)(id list, _EachBlock iterator))each
{
  return ^(id list, _EachBlock iterator) {
#ifdef DEBUG
    NSAssert(_.isArray(list) || _.isDictionary(list) || _.isNull(list), @"each xpecting NSArray or NSDictionary or nil");
#endif

    if (_.isNull(list)) return;

    else if (_.isArray(list)) {
      NSA* array = list;
      if(!array.length) return;

      UI count = [array count];
      for (I index=0; index<count; index++) {
        iterator([array objectAtIndex:index], N.I(index), list);
      }
    }
    else {
      NSD* dictionary = list;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, B *stop) {
        iterator(value, key, list);
      }];
    }
  };
}
+ (void(^)(id list, _EachBlock iterator))forEach { return self.each; }  // ALIAS
+ (B(^)(id list, _EachWithStopBlock iterator))eachWithStop
{
  return ^B(id list, _EachWithStopBlock iterator) {
#ifdef DEBUG
    NSAssert(_.isArray(list) || _.isDictionary(list) || _.isNull(list), @"eachWithStop expecting NSArray or NSDictionary or nil");
#endif

    if (_.isNull(list)) return YES;

    else if (_.isArray(list)) {
      NSA* array = list;
      if(!array.length) return YES;

      UI count = [array count];
      for (I index=0; index<count; index++) {
        if (!iterator([array objectAtIndex:index], N.I(index), list))
          return NO;
      }

      return YES; /* processed all */
    }
    else {
      __block B processedWithoutStop = YES;
      NSD* dictionary = list;
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, B *stop) {
        if (!iterator(value, key, list)) {
          processedWithoutStop = NO;
          *stop = YES;
        }
      }];
      
      return processedWithoutStop; /* processed all */
    }
  };
}

+ (A*(^)(NSO* list, _MapBlock iterator))map
{
  return ^A*(NSO* list, _MapBlock iterator) {
#ifdef DEBUG
    NSAssert(_.isArray(list) || _.isDictionary(list) || _.isNull(list), @"map expecting NSArray or NSDictionary or nil");
#endif

    if (_.isNull(list))
      return A.new;

    else if (_.isArray(list)) {
      NSA* array = (NSA*) list;
      if(!array.length) return A.new;

      A* result = [A arrayWithCapacity:array.length];
      UI count = [array count];
      for (I index=0; index<count; index++) {
        id mapped = iterator([array objectAtIndex:index], N.I(index), list);
        if (mapped)
          [result addObject:mapped];
      }

      return result;
    }
    else {
      NSD* dictionary = (NSD*) list;

      A* result = [A arrayWithCapacity:list.length];
      [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, B *stop) {
        id mapped = iterator(value, key, list);
        if (mapped)
          [result addObject:mapped];
      }];
      
      return result;
    }
    return nil;
  };
}
+ (A*(^)(id list, _MapBlock iterator))collect { return self.map; } // ALIAS

+ (id(^)(id list, _ReduceBlock iterator, id memo))reduce
{
  return ^(id list, _ReduceBlock iterator, id memo) {
    if (!list) {
#ifdef DEBUG
      if (!memo) @throw [NSException exceptionWithName:@"TypeError" reason:@"null without inital value" userInfo:nil];
#endif
      return memo;
    }
  
    __block id internalMemo = memo;
    __block B initial = false;
    if (list == nil) list = A.new;
    _.each(list, ^(NSO* value, ... /* KEY, LIST */) {
      initial = true;
      if (!internalMemo) internalMemo = [[NSClassFromString(value.mutableClassName) alloc] init];
      
      ARGS_KEY(value);
      internalMemo = iterator(internalMemo, value, key);
    });
#ifdef DEBUG
    if (!initial) @throw [NSException exceptionWithName:@"TypeError" reason:@"Reduce of empty array with no initial value" userInfo:nil];
#endif
    return internalMemo;
  };
}
+ (id(^)(id list, _ReduceBlock iterator, id memo))foldl { return self.reduce; } // ALIAS
+ (id(^)(id list, _ReduceBlock iterator, id memo))inject { return self.reduce; } // ALIAS

+ (id(^)(id list, _ReduceBlock iterator, id memo))reduceRight
{
  return ^id(id list, _ReduceBlock iterator, id memo) {
    if (!list) {
#ifdef DEBUG
      if (!memo) @throw [NSException exceptionWithName:@"TypeError" reason:@"null without inital value" userInfo:nil];
#endif
      return memo;
    }

    // do it the memory intensive way for dictionaries
    if (_.isDictionary(list)) return _.reduce(_.toArray(list).reverse().mutableCopy, iterator, memo);

    id internalMemo = memo;
    __block B initial = false;
    if (list == nil) list = A.new;
    A* array = list;
    for (I index=array.count-1; index>=0; index--) {
      NSO* value = [array objectAtIndex:index];
      initial = true;
      if (!internalMemo) internalMemo = [[NSClassFromString(value.mutableClassName) alloc] init];
      internalMemo = iterator(internalMemo, value, N.I(index), list);
    }
#ifdef DEBUG
    if (!initial) @throw [NSException exceptionWithName:@"TypeError" reason:@"Reduce of empty array with no initial value" userInfo:nil];
#endif
    return internalMemo;
  };
}
+ (id(^)(id list, _ReduceBlock iterator, id memo))foldr { return self.reduceRight; } // ALIAS

+ (id(^)(id list, _FindBlock iterator))find
{
  return ^(id list, _FindBlock iterator) {
    __block id result;
    _.any(list, ^B(id value, ... /* KEY, LIST */) {
      if (iterator(value)) {
        result = value;
        return true;
      }
      return false;
    });
    return result;
  };
}

+ (id(^)(id list, _FindBlock iterator))detect { return self.find; } // ALIAS

+ (A*(^)(id list, _ItemTestBlock iterator))filter
{
  return ^(id list, _ItemTestBlock iterator) {
    A* results = A.new;
    if (list == nil) return results;
    _.each(list, ^(id value, ... /* KEY, LIST */) {
      ARGS_KEY(value);
      if (iterator(value, key, list)) results.push(value);
    });
    return results;
  };
}
+ (A*(^)(id list, _ItemTestBlock iterator))select { return self.filter; } // ALIAS

+ (A*(^)(id list, _ItemTestBlock iterator))reject
{
  return ^(id list, _ItemTestBlock iterator) {
    A* results = A.new;
    if (list == nil) return results;
    _.each(list, ^(id value, ... /* KEY, LIST */) {
      ARGS_KEY(value);
      if (!iterator(value, key, list)) results.push(value);
    });
    return results;
  };
}

+ (B(^)(id list, _ItemTestBlock iterator))all
{
  return ^B(id list, _ItemTestBlock iterator) {
    if (list == nil) return YES;
    return _.eachWithStop(list, iterator);
  };
}
+ (B(^)(id list, _ItemTestBlock iterator))every {return self.all; } // ALIAS

+ (B(^)(id list, _ItemTestBlock iterator))any
{
  return ^B(id list, _ItemTestBlock iterator) {
    if (!iterator) iterator = _.identityTruthy;
    __block B result = NO;
    if (list == nil) return result;
    _.eachWithStop(list, ^B(id value, ... /* KEY, LIST */) {
      ARGS_KEY(value);
      if (result || (result = iterator(value, key, list)))
        return NO;
      return YES;
    });
    return !!result;
  };
}
+ (B(^)(id list, _ItemTestBlock iterator))some { return self.any; }

+ (B(^)(id list, id target))include
{
  return ^B(id list, id target) {
    B found = NO;
    if (list == nil) return found;
    found = _.any(list, ^B(id value, ... /* KEY, LIST */) {
      return value == target;
    });
    return found;
  };
}
+ (B(^)(id list, id target))contains { return self.include; } // ALIAS

+ (id(^)(id list, NSS* methodName, id arg1, ... /* NIL_TERMINATION */))invoke
{
  return ^(id list, NSS* methodName, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);
    if (arguments.length < 1) arguments.push(NSNull.null); // requires at least one argument to match the block signature (id arg1, ... /* NIL_TERMINATION */)

    return _.map(list, ^(NSO* value, ... /* KEY, LIST */) {
      return methodName.apply(value, arguments);
    });
  };
}

+ (NSO*(^)(id list, NSS* propertyName))pluck
{
  return ^NSO*(id list, NSString *propertyName) {
#ifdef DEBUG
    NSAssert(_.isArray(list) || _.isDictionary(list), @"each expecting NSArray or NSDictionary");
#endif

    if (_.isArray(list)) {
      A* result = A.new;
      for (NSO* item in (NSA*)list) {
        id value = item.get(propertyName);
        result.push(value ? value : NSNull.null);
      }
      return result;
    }
    else
      return ((NSD*)list).get(propertyName);
  };
}

+ (id(^)(id list, _MaxBlock iterator))max
{
  return ^id(id list, _MaxBlock iterator) {
    if (!iterator && _.isEmpty(list))
      return NF_NEG_INFINITY;

    if (_.isArray(list)) {
      NSA* array = list;
      NSO* max = nil;
      NSO* maxComputed;
      for (NSO* value in array) {
        NSO* computed = iterator ? iterator(value) : value;
        if (!maxComputed) {
          max = value;
          maxComputed = computed;
        }
        else if ([maxComputed compare: computed] == NSOrderedAscending) {
          max = value;
          maxComputed = computed;
        }
      }
      return max;
    }  
    
    else {
      __block O* result = OKV({@"computed", ((NSD*)list).objectEnumerator.nextObject});
      _.each(list, ^(NSO* value, ... /* KEY, LIST */) {
        NSO* computed = iterator ? iterator(value) : value;
        computed <= result.get(@"computed") && (result = OKV({@"value", value}, {@"computed", computed}));
      });
      return (NSO*) result.get(@"value");
    }
  };
}

+ (id(^)(id list, _MinBlock iterator))min
{
  return ^id(id list, _MinBlock iterator) {
    if (!iterator && _.isEmpty(list))
      return NF_POS_INFINITY;

    if (_.isArray(list)) {
      NSA* array = list;
      NSO* min = nil;
      NSO* minComputed;
      for (NSO* value in array) {
        NSO* computed = iterator ? iterator(value) : value;
        if (!minComputed) {
          min = value;
          minComputed = computed;
        }
        else if ([minComputed compare: computed] == NSOrderedDescending) {
          min = value;
          minComputed = computed;
        }
      }
      return min;
    }
    
    else
    {
      __block O* result = OKV({@"computed", ((NSD*)list).objectEnumerator.nextObject});
      _.each(list, ^(NSO* value, ... /* KEY, LIST */) {
        NSO* computed = iterator ? iterator(value) : value;
        computed >= result.get(@"computed") && (result = OKV({@"value", value}, {@"computed", computed}));
      });
      return (NSO*) result.get(@"value");
    }
  };
}

+ (id(^)(id list, id iteratorOrKey /* _SortByBlock or id */))sortBy
{
  return ^(id list, id iteratorOrKey) {
#ifdef DEBUG
    NSAssert(_.isArray(list) || _.isDictionary(list), @"each expecting NSArray or NSDictionary");
#endif

    _SortByBlock iterator = _.isBlock(iteratorOrKey) ? (_SortByBlock) iteratorOrKey : ^(NSO* value, ...){
      return value.get(iteratorOrKey); 
    };

    return _.chain(list)
      .map(^(NSO* value, ... /* KEY, LIST */) {
        ARGS_KEY_LIST(value, collection);
        return OKV({@"value", value}, {@"criteria", iterator(value, key, collection)});
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

+ (O*(^)(id list, id iteratorOrKey /* _GroupByBlock or id */))groupBy
{
  return ^(id list, id iteratorOrKey) {
#ifdef DEBUG
    NSAssert(_.isArray(list) || _.isDictionary(list), @"each expecting NSArray or NSDictionary");
#endif

    _GroupByBlock iterator = _.isBlock(iteratorOrKey) ? (_GroupByBlock) iteratorOrKey : ^(NSO* value, ... /* KEY, LIST */){
      return value.get(iteratorOrKey); 
    };
    
    __block O* result = O.new;
    _.each(list, ^(id value, ... /* KEY, LIST */) {
      ARGS_KEY(value);
      key = iterator(value, key, list);
      A* values = (A*) result.getOrAdd(key, ^{ return A.new; });
      values.push(value);
    });
    return result;
  };
}

+ (UI(^)(NSA* array, id list, _SortedIndexBlock iterator))sortedIndex
{
  return ^(NSA* array, id list, _SortedIndexBlock iterator) {
    if (!iterator)
      iterator = ^(id value, ...) { return value; };
      
    id value = iterator(list);
    UI low = 0, high = array.length;
    while (low < high) {
      UI mid = (low + high) >> 1;
      ([iterator(array.getAt(mid)) compare:value] == NSOrderedAscending) ? (low = mid + 1) : (high = mid);
    }
    return low;
  };
}

+ (A*(^)(id list))shuffle
{
  return ^(id list) {
    __block A* shuffled = _.isArray(list) ? ((NSA*)list).mutableCopy : _.values(list);
    _.each(list, ^(id value, ... /* KEY, LIST */) {
      ARGS_INDEX(value);
      I rand = arc4random() % (index + 1);
      [shuffled exchangeObjectAtIndex:rand withObjectAtIndex:index];
    });
    return shuffled;
  };
}

+ (NSA*(^)(id list))toArray
{
  return ^NSA*(id list) {
    if (!list)                                         return NSA.new;
    if (_.isArray(list))                               return ((NSA*)list).copy;
//    if (_.isArguments(list))                           return ((NSA*)list).copy;  /* NOT NEEDED: Arguments are an array */
    if ([list respondsToSelector:@selector(toArray)])  return [list performSelector:@selector(toArray)];
    if (_.isFunction(@"toArray", list))                return @"toArray".call(list, nil);
    return _.values(list);
  };
}

+ (UI(^)(id list))size {
  return ^UI(id list) {
    if (_.isArray(list))          return ((NSA*)list).count;
    if (_.isDictionary(list))     return ((NSD*)list).count;
    return 0;
  };
}

@end
