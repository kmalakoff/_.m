//
//  _Wrapper+Collections.m
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

#import "_Wrapper+Collections.h"
#import "_Wrapper+Private.h"
#import "_+Collections.h"
#import "_+Objects.h"
#import "SubjectiveScript.h"

@implementation _Wrapper (Collections)

- (_Wrapper*(^)(_EachBlock iterator))each
{
  return ^(_EachBlock iterator) {
    _.each(self.value(), iterator);
    return self;
  };
}
- (_Wrapper*(^)(_EachBlock iterator))forEach { return self.each; } // ALIAS
- (_Wrapper*(^)(_EachWithStopBlock iterator))eachWithStop /* SPECIALIZED: returns YES if processed all elements without a request to stop */
{
  return ^(_EachWithStopBlock iterator) {
    _.eachWithStop(self.value(), iterator);
    return self;
  };
}

- (_Wrapper*(^)(_MapBlock iterator))map
{
  return ^(_MapBlock iterator) {
    return _.chain(_.map(self.value(), iterator));
  };
}
- (_Wrapper*(^)(_MapBlock iterator))collect { return self.map; } // ALIAS

- (_Wrapper*(^)(_ReduceBlock iterator, id memo))reduce
{
  return ^(_ReduceBlock iterator, id memo) {
    return _.chain(_.reduce(self.value(), iterator, memo));
  };
}
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))foldl { return self.reduce; } // ALIAS
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))inject { return self.reduce; } // ALIAS

- (_Wrapper*(^)(_ReduceBlock iterator, id memo))reduceRight
{
  return ^(_ReduceBlock iterator, id memo) {
    return _.chain(_.reduceRight(self.value(), iterator, memo));
  };
}
- (_Wrapper*(^)(_ReduceBlock iterator, id memo))foldr { return self.reduceRight; } // ALIAS

- (_Wrapper*(^)(_FindBlock iterator))find
{
  return ^(_FindBlock iterator) {
    return _.chain(_.find(self.value(), iterator));
  };
}
- (_Wrapper*(^)(_FindBlock iterator))detect {return self.find; } // ALIAS

- (_Wrapper*(^)(_CollectionItemTestBlock iterator))filter 
{
  return ^(_CollectionItemTestBlock iterator) {
    return _.chain(_.filter(self.value(), iterator));
  };
}
- (_Wrapper*(^)(_CollectionItemTestBlock iterator))select { return self.filter; } // ALIAS

- (_Wrapper*(^)(_CollectionItemTestBlock iterator))reject
{
  return ^(_CollectionItemTestBlock iterator) {
    return _.chain(_.reject(self.value(), iterator));
  };
}

- (_Wrapper*(^)(_CollectionItemTestBlock iterator))all
{
  return ^(_CollectionItemTestBlock iterator) {
    return _.chain(N.B(_.all(self.value(), iterator)));
  };
}
- (_Wrapper*(^)(_CollectionItemTestBlock iterator))every { return self.all; } // ALIAS

- (_Wrapper*(^)(/* REQUIRED */ _CollectionItemTestBlock iterator))any
{
  return ^(_CollectionItemTestBlock iterator) {
    return _.chain(N.B(_.any(self.value(), iterator)));
  };
}
- (_Wrapper*(^)(_CollectionItemTestBlock iterator))some { return self.any; } // ALIAS

- (_Wrapper*(^)(id target))include
{
  return ^(id target) {
    return _.chain(N.B(_.include(self.value(), target)));
  };
}
- (_Wrapper*(^)(id target))contains { return self.include; } // ALIAS

- (_Wrapper*(^)(NSS* methodName, id arg1, ... /* NIL_TERMINATION */))invoke
{
  return ^(NSS* methodName, id arg1, ... /* NIL_TERMINATION */) {
    ARGS_AO(arguments, arg1);

    return _.chain(_.map(self.value(), ^(NSO* value, ... /* KEY, COLLECTION */) {
      return methodName.apply(value, arguments);
    }));
  };
}

- (_Wrapper*(^)(NSString *keyPath))pluck {
  return ^(NSString *keyPath) {
    return _.chain(_.pluck(self.value(), keyPath));
  };
}

- (_Wrapper*(^)(_MaxBlock iterator))max
{
  return ^(_MaxBlock iterator) {
    return _.chain(_.max(self.value(), iterator));
  };
}

- (_Wrapper*(^)(_MinBlock iterator))min
{
  return ^(_MinBlock iterator) {
    return _.chain(_.min(self.value(), iterator));
  };
}

- (_Wrapper*(^)(_SortBlock iterator))sort { /* ADDED to allow sorting in chaining */
  return ^(_SortBlock iterator) {
#ifdef DEBUG
    NSAssert(_.isArray(self.value()), @"sort expecting NSArray");
#endif

    return _.chain(self.valueA().sort(iterator));
  };
}

- (_Wrapper*(^)(id iteratorOrKey /* _SortByBlock or key */))sortBy
{
  return ^(id iteratorOrKey /* _SortByBlock or key */) {
    return _.chain(_.sortBy(self.value(), iteratorOrKey));
  };
}

- (_Wrapper*(^)(id iteratorOrKey /* _GroupByBlock or key */))groupBy
{
  return ^(id iteratorOrKey /* _SortByBlock or key */) {
    return _.chain(_.groupBy(self.value(), iteratorOrKey));
  };
}

- (_Wrapper*(^)(id obj, _SortedIndexBlock iterator))sortedIndex
{
  return ^(id obj, _SortedIndexBlock iterator) {
    return _.chain(N.I(_.sortedIndex(self.valueNSA(), obj, iterator)));
  };
}

- (_Wrapper*(^)())shuffle
{
  return ^() {
    return _.chain(_.shuffle(self.value()));
  };
}

- (_Wrapper*(^)())toArray
{
  return ^() {
    return _.chain(_.toArray(self.value()));
  };
}

- (_Wrapper*(^)())size
{
  return ^() {
    return _.chain(N.UI(_.size(self.value())));
  };
}

@end
