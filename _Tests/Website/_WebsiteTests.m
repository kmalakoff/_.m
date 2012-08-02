//
//  _WebsiteTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_WebsiteTests.h"
#import "Underscore.h"
#import "QUnit.h"

@implementation _WebsiteTests

- (void)test_collections
{
  // each
  _.each(AI(1, 2, 3), ^(N* num, ...){ /*SS.alert(num);*/ });
  _.each(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}), ^(N* num, ...){ /*SS.alert(num);*/ });
  _.eachWithStop(AI(1, 2, 3), ^B(N* num, ...){ /*SS.alert(num);*/ return (num.I<3); });

  // map
  A* nums = _.map(AI(1, 2, 3), ^(N* num, ...){ return N.I(num.I * 3); });
  equal(nums.toString(), @"[3,6,9]", @"map array");
  nums = _.map(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}), ^id(N* num, ...){ return N.I(num.I * 3); });
  equal(nums.toString(), @"[3,6,9]", @"map object");

  // reduce
  N* sum = _.reduce(AI(1, 2, 3), ^(N* memo, N* num, ...){ return N.I(memo.I + num.I); }, N.I(0));
  equal(sum.I, 6, @"reduce");

  // reduceRight
  A* list = AO(AI(0, 1), AI(2, 3), AI(4, 5));
  A* flat = _.reduceRight(list, ^(A* a, A* b, ...) { return a.concat(b); }, A.new);
  equal(flat, AI(4, 5, 2, 3, 0, 1), @"reduceRight");
  
  // find
  N* even = _.find(AI(1, 2, 3, 4, 5, 6), ^B(N* num){ return num.I % 2 == 0; });
  equal(even.I, 2, @"find");
  
  // filter
  A* evens = _.filter(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ...){ return num.I % 2 == 0; });
  equal(evens.toString(), @"[2,4,6]", @"filter");

  // reject
  A* odds = _.reject(AI(1, 2, 3, 4, 5, 6), ^B(N* num, ...){ return num.I % 2 == 0; });
  equal(odds.toString(), @"[1,3,5]", @"reject");

  // all
  B all = _.all(AO(N.B(true), N.I(1), nil, @"yes"), _.identityTruthy);
  equal(all, false, @"all");
  
  // any
  B any = _.any(AO(nil, N.I(0), @"yes", N.B(false)), nil);
  equal(any, true, @"any");
  
  // include
  B include = _.include(AI(1, 2, 3), N.I(3));
  equal(include, true, @"include");
  
  // invoke
  A* invoke = _.invoke(AO(AI(5, 1, 7), AI(3, 2, 1)), @"sort", nil);
  equal(invoke.toString(), @"[[1,5,7],[1,2,3]]", @"invoke");

  // pluck
  A* stooges = AO(OKV({@"name", @"moe"}, {@"age", N.I(40)}), OKV({@"name", @"larry"}, {@"age", N.I(50)}), OKV({@"name", @"curly"}, {@"age", N.I(60)}));
  id pluck = _.pluck(stooges, @"name");
  equal(SS.stringify(pluck), @"[\"moe\",\"larry\",\"curly\"]", @"pluck");

  // max
  id max = _.max(stooges, ^(O* stooge){ return stooge.get(@"age"); });
  equal(max, OKV({@"name", @"curly"}, {@"age", N.I(60)}), @"pluck");

  // min
  A* numbers = AI(10, 5, 100, 2, 1000);
  N* min = _.min(numbers, nil);
  equal(min.I, 2, @"min")
  
  // sortBy
  A* sortBy = _.sortBy(AI(1, 2, 3, 4, 5, 6), ^(N* num, ...){ return N.F(sin(num.I)); });
  equal(sortBy, AI(5, 4, 6, 3, 1, 2), @"sortBy")
  
  // groupBy
  O* groupBy = _.groupBy(AF(1.3, 2.1, 2.4), ^(N* num, ...){ return N.I(floor(num.F)); });
  equal(groupBy, OKV({N.I(1), AF(1.3)}, {N.I(2), AF(2.1, 2.4)}), @"groupBy numbers")
  groupBy = _.groupBy(AO(@"one", @"two", @"three"), @"length");
  equal(groupBy, OKV({N.I(3), AO(@"one",@"two")}, {N.I(5), AO(@"three")}), @"groupBy string length")

  // sortedIndex
  UI sortedIndex = _.sortedIndex(AI(10, 20, 30, 40, 50), N.I(35), nil);
  equal(sortedIndex, 3, @"sortedIndex")
  
  // shuffle
  A* shuffle = _.shuffle(AI(1, 2, 3, 4, 5, 6));
  equal(shuffle.length, 6, @"shuffle")
  for (N* item in AI(1, 2, 3, 4, 5, 6)) {
    ok(_.include(shuffle, item), @"shuffle includes")
  }
  
  // toArray
  NSA* toArray = (^(I arg1, ...){ ARGS_AI(arguments, arg1); return _.toArray(arguments).slice(1, 0); })(1, 2, 3, 4, AI_END);
  equal(toArray.toString(), @"[2,3,4]", @"toArray")

  // size
  UI size = _.size(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}));
  equal(size, 3, @"size")
}

- (void)test_arrays
{
  // first
  N* first = (N*) _.first(AI(5, 4, 3, 2, 1), -1);
  equal(first.I, 5, @"first")
  
  // firstIterator
  NSA* firstIterator = (NSA*) _.map(AO(AI(2, 1), AI(3, 1)), _.firstIterator);
  equal(firstIterator, AI(2, 3), @"firstIterator")
 
  // initial
  NSA* initial = _.initial(AI(5, 4, 3, 2, 1), -1);
  equal(initial, AI(5, 4, 3, 2), @"initial")
  
  // initialIterator
  NSA* initialIterator = (NSA*) _.map(AO(AI(2, 1, 3), AI(3, 1, 2)), _.initialIterator);
  equal(initialIterator, AO(AI(2, 1), AI(3, 1)), @"initialIterator")

  // last
  N* last = (N*) _.last(AI(5, 4, 3, 2, 1), -1);
  equal(last.I, 1, @"last")
  
  // lastIterator
  NSA* lastIterator = (NSA*) _.map(AO(AI(2, 1), AI(3, 1)), _.lastIterator);
  equal(lastIterator, AI(1, 1), @"lastIterator")

  // rest
  NSA* rest = _.rest(AI(5, 4, 3, 2, 1), -1);
  equal(rest, AI(4, 3, 2, 1), @"rest")
  
  // restIterator
  NSA* restIterator = (NSA*) _.map(AO(AI(2, 1, 3), AI(3, 1, 2)), _.restIterator);
  equal(restIterator, AO(AI(1, 3), AI(1, 2)), @"restIterator")
  
  // compact
  A* compact = _.compact(AO(N.I(0), N.I(1), N.B(false), N.I(2), @"", N.I(3)));
  equal(compact, AI(1, 2, 3), @"compact")
 
  // flatten
  A* flatten = _.flatten(AO(N.I(1), AI(2), AO(N.I(3), AO(AI(4)))), false);
  equal(flatten, AI(1, 2, 3, 4), @"flatten deep")
  flatten = _.flatten(AO(N.I(1), AI(2), AO(N.I(3), AO(AI(4)))), true);
  equal(flatten, AO(N.I(1), N.I(2), N.I(3), AO(AI(4))), @"flatten shallow")
  
  // without
  A* without = _.without(AI(1, 2, 1, 0, 3, 1, 4), N.I(0), N.I(1), nil);
  equal(without, AI(2, 3, 4), @"without")
  
  // union
  A* union_ = _.union_(AI(1, 2, 3), AI(101, 2, 1, 10), AI(2, 1), nil);
  equal(union_, AI(1, 2, 3, 101, 10), @"union_")
  
  // intersection
  A* intersection = _.intersection(AI(1, 2, 3), AI(101, 2, 1, 10), AI(2, 1), nil);
  equal(intersection, AI(1, 2), @"intersection")
  
  // difference
  A* difference = _.difference(AI(1, 2, 3, 4, 5), AI(5, 2, 10), nil);
  equal(difference, AI(1, 3, 4), @"difference")
  
  // uniq
  A* uniq = _.uniq(AI(1, 2, 1, 3, 1, 4));
  equal(uniq, AI(1, 2, 3, 4), @"uniq")
  
  // uniqAdvanced
  A* uniqAdvanced = _.uniqAdvanced(AI(1, 2, 2, 3, 4, 4), true, ^(N* value, ...) { return N.I(value.I + 1); });
  equal(uniqAdvanced.join(@", "), @"1, 2, 3, 4", @"uniqAdvanced");
 
  // zip
  A* zip = _.zip(AO(@"moe", @"larry", @"curly"), AI(30, 40, 50), AB(true, false, false), nil);
  equal(SS.stringify(zip), @"[[\"moe\",30,true],[\"larry\",40,false],[\"curly\",50,false]]", @"zip");

  // zipObject
  O* zipObject = _.zipObject(AO(@"moe", @"larry", @"curly"), AI(30, 40, 50));
  O* shouldBe = OKV({@"moe", N.I(30)}, {@"larry", N.I(40)}, {@"curly", N.I(50)});
  equal(zipObject, shouldBe, @"zipObject");
  
  // indexOf
  I indexOf = _.indexOf(AI(1, 2, 3), N.I(2));
  equal(indexOf, 1, @"indexOf");

  // indexOfSorted
  I indexOfSorted = _.indexOfSorted(AI(10, 20, 30, 40, 50), N.I(30));
  equal(indexOfSorted, 2, @"indexOfSorted");
  
  // lastIndexOf
  I lastIndexOf = _.lastIndexOf(AI(1, 2, 3, 1, 2, 3), N.I(2));
  equal(lastIndexOf, 4, @"lastIndexOf");
  
  // range
  A* range = _.range(1, 11, 1);
  equal(range, AI(1, 2, 3, 4, 5, 6, 7, 8, 9, 10), @"range");
  range = _.range(0, 30, 5);
  equal(range, AI(0, 5, 10, 15, 20, 25), @"range");
  range = _.range(0, -10, -1);
  equal(range, AI(0, -1, -2, -3, -4, -5, -6, -7, -8, -9), @"range");
  
  // rangeSimple
  A* rangeSimple = _.rangeSimple(10);
  equal(rangeSimple, AI(0, 1, 2, 3, 4, 5, 6, 7, 8, 9), @"rangeSimple");
  rangeSimple = _.rangeSimple(0);
  equal(rangeSimple, A.new, @"rangeSimple");
}

- (void)test_functions
{
  // memoize
  __block _MemoizedBlock fibonacci = _.memoize(^N*(N* n, ...) {
    return n.I < 2 ? n : N.I(fibonacci(N.I(n.I - 1), nil).I + fibonacci(N.I(n.I - 2), nil).I);
  }, nil);
  equal(fibonacci(N.I(10), /* REQUIRED */ nil), N.I(55), @"memoize");

  // delay
  asyncTest(^{
    _.delay(^{ NSLog(@"%d", 1000); ok(true, @"delayed"); start(); }, NSEC_PER_SEC*1);
  });

  // delayBackground
  asyncTest(^{
    _.delayBackground(^{ NSLog(@"%d", 1000); ok(true, @"deferBackground"); start(); }, NSEC_PER_SEC*1);
  });
  
  // defer
  asyncTest(^{
    _.defer(^{ /*SS.alert(@"deferred");*/ ok(true, @"defer"); start(); });
  });

  // deferBackground
  asyncTest(^{
    _.deferBackground(^{ /*SS.alert(@"deferBackground");*/ ok(true, @"deferBackground"); start(); });
  });
  
  // throttle
  _ThrottledBlock throttled = _.throttle(^id(id arg1, ...){ /* updatePosition */ return nil; }, 100, nil);
  throttled();
  
  // debounce
  _DebouncedBlock lazyLayout = _.debounce(^(id arg1, ...){ /* calculateLayout */ }, 300, true, nil);
  lazyLayout();

  // once
  _OncedBlock initialize = _.once(^id(id arg1, ...){ /* createApplication */ return nil; }, nil);
  initialize(nil);
  initialize(nil);
  
  // after
//  A* notes = AI(1,2,3);
//  _AfteredBlock renderNotes = _.after(notes.length, ^id(id arg1, ...){ /* render */ return nil; }, nil);
//  _.each(notes, ^(N* note, ...) {
//    note.asyncSave(OKV({@"success", renderNotes}));
//  });

  _WrappedBlock hello = ^NSS*(NSS* name, ...) { return @"hello: ".add(name); };
  hello = _.wrap(hello, ^NSS*(_WrappedBlock func, id arg1, ...) {
    return @"before, ".add(func(@"moe", nil)).add(@", after");
  });
  NSS* wrap = hello(nil, nil);
  equal(wrap, @"before, hello: moe, after", @"wrap")
  
  // compose
  _ComposeBlock greet = ^(NSS* name, ...){ return @"hi: ".add(name); };
  _ComposeBlock exclaim  = ^(NSS* statement, ...){ return statement.add(@"!"); };
  _ComposedBlock welcome = _.compose(exclaim, greet, nil);
  NSS* compose = welcome(@"moe");
  equal(compose, @"hi: moe!", @"compose")
}

- (void)test_objects
{
  // keys
  NSA* keys = _.keys(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}));
  equal(keys, AO(@"one", @"two", @"three"), @"keys")
  
  // values
  NSA* values = _.values(OKV({@"one", N.I(1)}, {@"two", N.I(2)}, {@"three", N.I(3)}));
  equal(values, AI(1,2,3), @"values")
  
  // functions
  O* obj = OKV({@"map", _.map}, {@"reduce", _.reduce});
  ok(_.isEqual(AO(@"map", @"reduce"), _.functions(obj)), @"functions");

  // extend
  O* extend = _.extend(OKV({@"name", @"moe"}), OKV({@"age", N.I(50)}), nil);
  equal(extend, OKV({@"name", @"moe"}, {@"age", N.I(50)}), @"extend");
  
  // pick
  O* pick = _.pick(OKV({@"name", @"moe"}, {@"age", N.I(50)}, {@"userid", @"moe1"}), @"name", @"age", nil);
  equal(pick, OKV({@"name", @"moe"}, {@"age", N.I(50)}), @"pick");
  
  // defaults
  O* iceCream = OKV({@"flavor", @"chocolate"});
  _.defaults(iceCream, OKV({@"flavor", @"vanilla"}, {@"sprinkles", @"lots"}), nil);
  equal(iceCream, OKV({@"flavor", @"chocolate"}, {@"sprinkles", @"lots"}), @"defaults");

  // clone
  O* clone = _.clone(OKV({@"name", @"moe"}));
  equal(clone, OKV({@"name", @"moe"}), @"clone");

  // tap
  NSA* tap = (NSA*) _.chain(AI(1,2,3,200))
    .filter(^B(N* num, ...) { return num.I % 2 == 0; })
    .tap(^(id value){/*SS.alert*/})
    .map(^(N* num, ...) { return N.I(num.I * num.I); })
    .value();
  equal(tap, AI(4, 40000), @"tap");
  tap = _.chain(AI(1,2,3,200))
    .filter(^B(N* num, ...) { return num.I % 2 == 0; })
    .tap(^(id value){/*SS.alert*/})
    .map(^(N* num, ...) { return N.I(num.I * num.I); })
    .NSA;
  equal(tap, AI(4, 40000), @"tap");

  // has
  B has = _.has(OKV({@"a", N.I(1)}, {@"b", N.I(2)}, {@"c", N.I(3)}), @"b");
  ok(has, @"has");
  
  // isEqual
  O* moe = OKV({@"name", @"moe"}, {@"luckyNumbers", AI(13, 27, 34)});
  O* moe_clone = OKV({@"name", @"moe"}, {@"luckyNumbers", AI(13, 27, 34)});
  ok(moe!=moe_clone, @"isEqual: not pointers")
  B isEqual = _.isEqual(moe, moe_clone);
  ok(isEqual, @"isEqual: true")

  // isEmpty
  B isEmpty = _.isEmpty(AI(1, 2, 3));
  ok(!isEmpty, @"isEmpty: false")
  isEmpty = _.isEmpty(O.new);
  ok(isEmpty, @"isEmpty: true")

  // isArray
  (^(id arg1, ...){ ARGS_AO(arguments, arg1); ok(_.isArray(arguments), @"isArray"); })(nil);
  B isArray = _.isArray(AI(1,2,3));
  ok(isArray, @"isArray: true")

  // isObject
  B isObject = _.isObject(O.new);
  ok(isObject, @"isObject: true")
  isObject = _.isObject(N.I(1));
  ok(!isObject, @"isObject: false")
  
  // isArguments
  (^(I arg1, ...){ ARGS_AI(arguments, arg1); ok(_.isArguments(arguments), @"isArguments"); })(1, 2, 3, AI_END);
  B isArguments = _.isArguments(AI(1,2,3));
  ok(!isArguments, @"isArguments: false")
 
  // isString
  B isString = _.isString(@"moe");
  ok(isString, @"isString: true")
  
  // isNumber
  B isNumber = _.isNumber(N.F(8.4 * 5));
  ok(isNumber, @"isNumber: true")
  
  // isFinite
  B isFinite = _.isFinite(N.I(-101));
  ok(isFinite, @"isFinite: true")
  isFinite = _.isFinite(NF_NEG_INFINITY);
  ok(!isFinite, @"isFinite: false")
  
  // isBoolean
  B isBoolean = _.isBoolean(nil);
  ok(!isBoolean, @"isBoolean: false")
  
  // isDate
  B isDate = _.isDate(Date.new);
  ok(isDate, @"isDate: true")
  
  // isNaN
  B isNaN = _.isNaN(NF_NaN);
  ok(isNaN, @"isNaN: true")
  
  // isNull
  B isNull = _.isNull(nil);
  ok(isNull, @"isNull: true")
  isNull = _.isNull(NSNull.null);
  ok(isNull, @"isNull: true")
}

- (void)test_utility
{
  // identity
  O* moe = OKV({@"name", @"moe"});
  ok(moe == _.identity(moe), @"identity");
  // identityTruthy
  ok(_.identityTruthy(moe), @"identityTruthy");

  // times
  __(N.I(3)).times(^(UI index){ /*genie.grantWish();*/ });
  
  // uniqueId
  NSS* uniqueId = _.uniqueId(@"contact_");
  ok(uniqueId.startsWith(@"contact_"), @"uniqueId");
  
  // result
  O* object = OKV({@"cheese", @"crumpets"}, {@"stuff", ^(){ return @"nonsense"; }});
  id result = _.result(object, @"cheese");
  equal(result, @"crumpets", @"result crumpets");
  result = _.result(object, @"stuff");
  equal(result, @"nonsense", @"result nonsense");
}

- (void)test_chaining
{
  // chaining example
  NSA* map = _.map(AI(1, 2, 3), ^(N* n, ...){ return N.I(n.I * 2); });
  equal(map, AI(2,4,6), @"chaining example map");
  
  NSA* chaining = __(AI(1, 2, 3)).map(^(N* n, ...){ return N.I(n.I * 2); }).NSA;
  equal(chaining, AI(2,4,6), @"chaining example");

  // chaining
  A* stooges = AO(OKV({@"name", @"curly"}, {@"age", N.I(25)}), OKV({@"name", @"moe"}, {@"age", N.I(21)}), OKV({@"name", @"larry"}, {@"age", N.I(23)}));
  NSS* youngest = (NSS*) _.chain(stooges)
    .sortBy(^(O* stooge, ...){ return stooge.get(@"age"); })
    .map(^(O* stooge, ...){ return stooge.get(@"name").add(@" is ").add(stooge.get(@"age").toString()); })
    .first(-1)
    .value();
  equal(youngest, @"moe is 21", @"chaining");

  // chaining 2
  youngest = _.chain(stooges)
    .sortBy(^(O* stooge, ...){ return stooge.get(@"age"); })
     .map(^(O* stooge, ...){ return stooge.get(@"name").add(@" is ").add(stooge.get(@"age").toString()); })
    .first(-1)
    .NSS;
  equal(youngest, @"moe is 21", @"chaining2");
 
  // value
  A* value = (A*) __(AI(1, 2, 3)).value();
  equal(value, AI(1, 2, 3), @"value");
  
  equal(__(N.I(-1)).I, -1, @"I");
  equal(__(N.I(1)).UI, 1, @"UI");
  equal(__(N.B(true)).B, true, @"B");
  equal(__(N.F(1.2f)).F, 1.2f, @"F");
  equal(__(N.D(3.14159)).D, 3.14159, @"D");

  equal(__(@"bob").NSS, @"bob", @"NSS");
  equal(__(@"bob").S, @"bob", @"S");
  equal(__(AI(1, 2, 3)).NSA, AI(1, 2, 3), @"NSA");
  equal(__(AI(1, 2, 3)).A, AI(1, 2, 3), @"A");
  equal(__(OKV({@"key", N.I(1)})).NSD, OKV({@"key", N.I(1)}), @"NSD");
  equal(__(OKV({@"key", N.I(1)})).O, OKV({@"key", N.I(1)}), @"O");
  ok(__(Date.new).Date != nil, @"Date");
}

@end
