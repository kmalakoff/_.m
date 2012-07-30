//
//  _Wrapper+ObjectsTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_Wrapper+ObjectsTests.h"
#import "QUnit.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation _WrapperObjectsTests

- (void)test_keys
{
  equal(_.chain(OKV({@"one", N.I(1)}, {@"two", N.I(2)})).keys().NSA.join(@", "), @"one, two", @"can extract the keys from an object");
  // the test above is not safe because it relies on for-in enumeration order
  A* a = A.new; a.setAt(1, N.I(0));
//  equal(_.keys(a).join(@", "), @"1", @"is not fooled by sparse arrays; see issue #95"); /* NOT SUPPORTED: strict type checking */
  raises(^() { _.chain(nil).keys(); }, @"TypeError", @"throws an error for `null` values");
//  raises(^() { _.keys(void 0); }, TypeError, @"throws an error for `undefined` values"); /* NOT SUPPORTED: JavaScript-only because of undefined */
//  raises(^() { _.keys(1); }, TypeError, @"throws an error for number primitives");
//  raises(^() { _.keys(@"a"); }, TypeError, @"throws an error for string primitives");
//  raises(^() { _.keys(true); }, TypeError, @"throws an error for boolean primitives"); /* NOT SUPPORTED: strict type checking */
}

- (void)test_values
{
  equal(_.chain(OKV({@"one", N.I(1)}, {@"two", N.I(2)})).values().NSA.join(@", "), @"1, 2", @"can extract the values from an object");
}

- (void)test_functions
{
  O* obj = OKV({@"a", @"dash"}, {@"b", _.map}, /*{@"c", (/yo/)},*/ {@"d", _.reduce});
  ok(_.isEqual(AO(@"b", @"d"), _.chain(obj).functions().NSA), @"can grab the function names of any passed-in object");

  /* NOT SUPPORTED: JavaScript-only because of prototype */
//  void(^Animal)() = ^(){};
//  Animal.prototype.run = ^(){};
//  equal(_.functions(new Animal).join(@""), @"run", @"also looks up functions on the prototype");
}

- (void)test_extend
{
  O* result;
  equal(_.chain(O.new).extend(OKV({@"a",@"b"}), /* NIL TERMINATED */ nil).O.get(@"a"), @"b", @"can extend an object with the attributes of another");
  equal(_.chain(OKV({@"a",@"x"})).extend(OKV({@"a",@"b"}), /* NIL TERMINATED */ nil).O.get(@"a"), @"b", @"properties in source override destination");
  equal(_.chain(OKV({@"x",@"x"})).extend(OKV({@"a",@"b"}), /* NIL TERMINATED */ nil).O.get(@"x"), @"x", @"properties not in source dont get overriden");
  result = _.chain(OKV({@"x",@"x"})).extend(OKV({@"a",@"a"}), OKV({@"b",@"b"}), /* NIL TERMINATED */ nil).O;
  ok(_.isEqual(result, OKV({@"x",@"x"}, {@"a",@"a"}, {@"b",@"b"})), @"can extend from multiple source objects");
  result = _.chain(OKV({@"x",@"x"})).extend(OKV({@"a",@"a"}, {@"x",N.I(2)}), OKV({@"a",@"b"}), /* NIL TERMINATED */ nil).O;
  ok(_.isEqual(result, OKV({@"x",N.I(2)}, {@"a",@"b"})), @"extending from multiple source objects last property trumps");
  result = _.chain(O.new).extend(OKV(/*{@"a", void 0},*/ {@"a", NSNull.null}, {@"b", nil}), /* NIL TERMINATED */ nil).O;
  equal(_.keys(result).join(@""), @"ab", @"extend does not copy undefined values");
}

- (void)test_pick
{
  O* result;
  result = _.chain(OKV({@"a",N.I(1)}, {@"b",N.I(2)}, {@"c",N.I(3)})).pick(@"a", @"c", /* NIL TERMINATED */ nil).O;
  ok(_.isEqual(result, OKV({@"a",N.I(1)}, {@"c",N.I(3)})), @"can restrict properties to those named");
  result = _.chain(OKV({@"a",N.I(1)}, {@"b",N.I(2)}, {@"c",N.I(3)})).pick(AO(@"b", @"c"), /* NIL TERMINATED */ nil).O;
  ok(_.isEqual(result, OKV({@"b",N.I(2)}, {@"c",N.I(3)})), @"can restrict properties to those named in an array");
  result = _.chain(OKV({@"a",N.I(1)}, {@"b",N.I(2)}, {@"c",N.I(3)})).pick(AO(@"a"), @"b", /* NIL TERMINATED */ nil).O;
  ok(_.isEqual(result, OKV({@"a",N.I(1)}, {@"b",N.I(2)})), @"can restrict properties to those named in mixed args");
}

- (void)test_defaults
{
  O* options = OKV({@"zero", N.I(0)}, {@"one", N.I(1)}, {@"empty", @""}, {@"nan", NF_NaN}, {@"string", @"string"});

  _.chain(options).defaults(OKV({@"zero", N.I(1)}, {@"one", N.I(10)}, {@"twenty", N.I(20)}), /* NIL_TERMINATED */ nil);
  equal(options.get(@"zero"), N.I(0), @"value exists");
  equal(options.get(@"one"), N.I(1), @"value exists");
  equal(options.get(@"twenty"), N.I(20), @"default applied");

  _.chain(options).defaults(OKV({@"empty", @"full"}), OKV({@"nan", @"nan"}), OKV({@"word", @"word"}), OKV({@"word", @"dog"}), /* NIL TERMINATED */ nil);
  equal(options.get(@"empty"), @"", @"value exists");
  ok(_.isNaN(options.get(@"nan")), @"NaN isn't overridden");
  equal(options.get(@"word"), @"word", @"new value is added, first one wins");
}

- (void)test_clone
{
  O* moe = OKV({@"name", @"moe"}, {@"lucky", AI(13, 27, 34)});
  O* clone = _.chain(moe).clone().O;
  equal(clone.get(@"name"), @"moe", @"the clone as the attributes of the original");

  clone.set(@"name", @"curly");
  ok([(NSS*)clone.get(@"name") isEqualToString:@"curly"] && [(NSS*)moe.get(@"name") isEqualToString:@"moe"], @"clones can change shallow attributes without affecting the original");

  clone.get(@"lucky").push(N.I(101));
  equal(_.last((A*)moe.get(@"lucky"), /* REQUIRED */ -1), N.I(101), @"changes to deep attributes are shared with the original");

//  equal(_.clone(undefined), void 0, @"non objects should not be changed by clone"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  equal(_.chain(N.I(1)).clone().N, N.I(1), @"non objects should not be changed by clone");
  equal(_.chain(nil).clone().value(), nil, @"non objects should not be changed by clone");
}

- (void)test_isEqual
{
  /* NOT SUPPORTED: JavaScript-only because of prototype */
//  function First() {
//    this.value = 1;
//  }
//  First.prototype.value = 1;
//  function Second() {
//    this.value = 1;
//  }
//  Second.prototype.value = 2;

  // Basic equality and identity comparisons.
  ok(_.chain(nil).isEqual(nil).B, @"`null` is equal to `null`");
//  ok(_.isEqual(), @"`undefined` is equal to `undefined`"); /* NOT SUPPORTED: JavaScript-only because of undefined */

  ok(/* ! CHANGE: equal */ _.isEqual(N.I(0), N.I(-0)), @"`0` is equal to `-0`");
  ok(/* ! CHANGE: equal */ _.isEqual(N.I(-0), N.I(0)), @"Commutative equality is implemented for `0` and `-0`");
//  ok(!_.isEqual(null, undefined), @"`null` is not equal to `undefined`"); /* NOT SUPPORTED: JavaScript-only because of undefined */
//  ok(!_.isEqual(undefined, null), @"Commutative equality is implemented for `null` and `undefined`"); /* NOT SUPPORTED: JavaScript-only because of undefined */

  // String object and primitive comparisons.
  ok(_.chain(@"Curly").isEqual(@"Curly").B, @"Identical string primitives are equal");
  ok(_.chain(S.newS(@"Curly")).isEqual(S.newS(@"Curly")).B, @"String objects with identical primitive values are equal");
  ok(_.chain(S.newS(@"Curly")).isEqual(@"Curly").B, @"String primitives and their corresponding object wrappers are equal");
  ok(_.chain(@"Curly").isEqual(S.newS(@"Curly")).B, @"Commutative equality is implemented for string objects and primitives");

  ok(!_.chain(@"Curly").isEqual(@"Larry").B, @"String primitives with different values are not equal");
  ok(!_.chain(S.newS(@"Curly")).isEqual(S.newS(@"Larry")).B, @"String objects with different primitive values are not equal");
  ok(!_.chain(S.newS(@"Curly")).isEqual(OKV({@"toString", ^(){ return "Curly"; }})).B, @"String objects and objects with a custom `toString` method are not equal");

  // Number object and primitive comparisons.
//  ok(_.isEqual(75, 75), @"Identical number primitives are equal");
  ok(_.chain(N.I(75)).isEqual(N.I(75)).B, @"Number objects with identical primitive values are equal");
//  ok(_.isEqual(75, new Number(75)), @"Number primitives and their corresponding object wrappers are equal"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  ok(_.isEqual(new Number(75), 75), @"Commutative equality is implemented for number objects and primitives"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  ok(!_.isEqual(new Number(0), -0), @"`new Number(0)` and `-0` are not equal"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  ok(!_.isEqual(0, new Number(-0)), @"Commutative equality is implemented for `new Number(0)` and `-0`"); /* NOT SUPPORTED: JavaScript-only because of primitives */

  ok(!_.chain(N.I(75)).isEqual(N.I(63)).B, @"Number objects with different primitive values are not equal");
  ok(!_.chain(N.I(63)).isEqual(OKV({@"Of", ^(){ return 63; }})).B, @"Number objects and objects with a `Of` method are not equal");

  // Comparisons involving `NaN`.
  ok(_.chain(NF_NaN).isEqual(NF_NaN).B, @"`NaN` is equal to `NaN`");
  ok(!_.chain(N.F(61)).isEqual(NF_NaN).B, @"A number primitive is not equal to `NaN`");
  ok(!_.chain(N.F(79)).isEqual(NF_NaN).B, @"A number object is not equal to `NaN`");
  ok(!_.chain(NF_POS_INFINITY).isEqual(NF_NaN).B, @"`Infinity` is not equal to `NaN`");

  // Boolean object and primitive comparisons.
  ok(_.chain(N.B(true)).isEqual(N.B(true)).B, @"Identical boolean primitives are equal");
//  ok(_.isEqual(new Boolean, new Boolean), @"Boolean objects with identical primitive values are equal"); /* NOT SUPPORTED: JavaScript-only because of default new */
//  ok(_.isEqual(true, new Boolean(true)), @"Boolean primitives and their corresponding object wrappers are equal"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  ok(_.isEqual(new Boolean(true), true), @"Commutative equality is implemented for booleans"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  ok(!_.isEqual(new Boolean(true), new Boolean), @"Boolean objects with different primitive values are not equal"); /* NOT SUPPORTED: JavaScript-only because of default new */

  // Common type coercions.
//  ok(!_.isEqual(true, new Boolean(false)), @"Boolean objects are not equal to the boolean primitive `true`");
  ok(!_.chain(@"75").isEqual(N.I(75)).B, @"String and number primitives with like values are not equal");
  ok(!_.chain(N.I(63)).isEqual(S.newS(@"63")).B, @"String and number objects with like values are not equal");
  ok(!_.chain(N.I(75)).isEqual(@"75").B, @"Commutative equality is implemented for like string and number values");
  ok(!_.chain(N.I(0)).isEqual(@"").B, @"Number and string primitives with like values are not equal");
  ok(!_.chain(N.I(1)).isEqual(N.B(true)).B, @"Number and boolean primitives with like values are not equal");
  ok(!_.chain(N.B(false)).isEqual(N.I(0)).B, @"Boolean and number objects with like values are not equal");
  ok(!_.chain(N.B(false)).isEqual(S.newS(@"")).B, @"Boolean primitives and string objects with like values are not equal");
//  ok(!_.isEqual(12564504e5, new Date(2009, 9, 25)), @"Dates and their corresponding numeric primitive values are not equal");

  // Dates.
  ok(_.chain(Date.newYMD(2009, 9, 25)).isEqual(Date.newYMD(2009, 9, 25)).B, @"Date objects referencing identical times are equal");
  ok(!_.chain(Date.newYMD(2009, 9, 25)).isEqual(Date.newYMD(2009, 11, 13)).B, @"Date objects referencing different times are not equal");
  ok(!_.chain(Date.newYMD(2009, 11, 13)).isEqual(OKV({
    @"getTime", ^(){
      return 12606876e5;
    }
  })).B, @"Date objects and objects with a `getTime` method are not equal");
//  ok(!_.isEqual(new Date(@"Curly"), new Date(@"Curly")), @"Invalid dates are not equal");

  // Functions.
//  ok(!_.isEqual(First, Second), @"Different functions with identical bodies and source code representations are not equal");

  // RegExps.
//  ok(_.isEqual(/(?:)/gim, /(?:)/gim), @"RegExps with equivalent patterns and flags are equal");
//  ok(!_.isEqual(/(?:)/g, /(?:)/gi), @"RegExps with equivalent patterns and different flags are not equal");
//  ok(!_.isEqual(/Moe/gim, /Curly/gim), @"RegExps with different patterns and equivalent flags are not equal");
//  ok(!_.isEqual(/(?:)/gi, /(?:)/g), @"Commutative equality is implemented for RegExps");
//  ok(!_.isEqual(/Curly/g, {source: "Larry", global: true, ignoreCase: false, multiline: false}), @"RegExps and RegExp-like objects are not equal");

  // Empty arrays, array-like objects, and object literals.
  ok(_.chain(O.new).isEqual(O.new).B, @"Empty object literals are equal");
  ok(_.chain(A.new).isEqual(A.new).B, @"Empty array literals are equal");
  ok(_.chain(AO(O.new)).isEqual(AO(O.new)).B, @"Empty nested arrays and objects are equal");
  ok(!_.chain(OKV({@"length", N.I(0)})).isEqual(A.new).B, @"Array-like objects and arrays are not equal.");
  ok(!_.chain(A.new).isEqual(OKV({@"length", N.I(0)})).B, @"Commutative equality is implemented for array-like objects");

  ok(!_.chain(O.new).isEqual(A.new).B, @"Object literals and array literals are not equal");
  ok(!_.chain(A.new).isEqual(O.new).B, @"Commutative equality is implemented for objects and arrays");

  // Arrays with primitive and object values.
  ok(_.chain(AO(N.I(1), @"Larry", N.B(true))).isEqual(AO(N.I(1), @"Larry", N.B(true))).B, @"Arrays containing identical primitives are equal");
  ok(_.chain(AO(/*(/Moe/g),*/ Date.newYMD(2009, 9, 25))).isEqual(AO(/*(/Moe/g),*/ Date.newYMD(2009, 9, 25))).B, @"Arrays containing equivalent elements are equal");

  // Multi-dimensional arrays.
  A* aA = AO(N.I(47), N.B(false), @"Larry", /*/Moe/,*/ Date.newYMD(2009, 11, 13), AO(@"running", @"biking", S.newS(@"programming")), OKV({@"a", N.I(47)}));
  A* bA = AO(N.I(47), N.B(false), @"Larry", /*/Moe/,*/ Date.newYMD(2009, 11, 13), AO(@"running", @"biking", S.newS(@"programming")), OKV({@"a", N.I(47)}));
  ok(_.chain(aA).isEqual(bA).B, @"Arrays containing nested arrays and objects are recursively compared");

//  // Overwrite the methods defined in ES 5.1 section 15.4.4.
//  a.forEach = a.map = a.filter = a.every = a.indexOf = a.lastIndexOf = a.some = a.reduce = a.reduceRight = null;
//  b.join = b.pop = b.reverse = b.shift = b.slice = b.splice = b.concat = b.sort = b.unshift = null;

  // Array elements and properties.
  ok(_.chain(aA).isEqual(bA).B, @"Arrays containing equivalent elements and different non-numeric properties are equal");
  aA.push(@"White Rocks");
  ok(!_.chain(aA).isEqual(bA).B, @"Arrays of different lengths are not equal");
  aA.push(@"East Boulder");
  bA.push(@"Gunbarrel Ranch").push(@"Teller Farm");
  ok(!_.chain(aA).isEqual(bA).B, @"Arrays of identical lengths containing different elements are not equal");

  // Sparse arrays.
  ok(_.chain(A.newSparse(3)).isEqual(A.newSparse(3)).B, @"Sparse arrays of identical lengths are equal");
  ok(!_.chain(A.newSparse(3)).isEqual(A.newSparse(6)).B, @"Sparse arrays of different lengths are not equal when both are empty");

  // According to the Microsoft deviations spec, section 2.1.26, JScript 5.x treats `undefined`
  // elements in arrays as elisions. Thus, sparse arrays and dense arrays containing `undefined`
  // values are equivalent.
//  if (0 in [undefined]) {
//    ok(!_.isEqual(Array(3), [undefined, undefined, undefined]), @"Sparse and dense arrays are not equal");
//    ok(!_.isEqual([undefined, undefined, undefined], Array(3)), @"Commutative equality is implemented for sparse and dense arrays");
//  }

  // Simple objects.
  ok(_.chain(OKV({@"a", @"Curly"}, {@"b", N.I(1)}, {@"c", N.B(true)})).isEqual(OKV({@"a", @"Curly"}, {@"b", N.I(1)}, {@"c", N.B(true)})).B, @"Objects containing identical primitives are equal");
  ok(_.chain(OKV(/*{@"a", /Curly/g},*/ {@"b", Date.newYMD(2009, 11, 13)})).isEqual(OKV(/*{@"a", /Curly/g},*/ {@"b", Date.newYMD(2009, 11, 13)})).B, @"Objects containing equivalent members are equal");
  ok(!_.chain(OKV({@"a", N.I(63)}, {@"b", N.I(75)})).isEqual(OKV({@"a", N.I(61)}, {@"b", N.I(55)})).B, @"Objects of identical sizes with different values are not equal");
  ok(!_.chain(OKV({@"a", N.I(63)}, {@"b", N.I(75)})).isEqual(OKV({@"a", N.I(61)}, {@"c", N.I(55)})).B, @"Objects of identical sizes with different property names are not equal");
  ok(!_.chain(OKV({@"a", N.I(1)}, {@"b", N.I(2)})).isEqual(OKV({@"a", N.I(1)})).B, @"Objects of different sizes are not equal");
  ok(!_.chain(OKV({@"a", N.I(1)})).isEqual(OKV({@"a", N.I(1)}, {@"b", N.I(2)})).B, @"Commutative equality is implemented for objects");
  ok(!_.chain(OKV({@"x", N.I(1)}, {@"y", /*undefined*/ nil})).isEqual(OKV({@"x", N.I(1)}, {@"z", N.I(2)})).B, @"Objects with identical keys and different values are not equivalent");

  // `A` contains nested objects and arrays.
  O* aO = OKV(
    {@"name", S.newS(@"Moe Howard")},
    {@"age", N.I(77)},
    {@"stooge", N.B(true)},
    {@"hobbies", AO(@"acting")},
    {@"film", OKV(
      {@"name", @"Sing a Song of Six Pants"},
      {@"release", Date.newYMD(1947, 9, 30)},
      {@"stars", AO(S.newS(@"Larry Fine"), @"Shemp Howard")},
      {@"minutes", N.I(16)},
      {@"seconds", N.I(54)}
    )}
  );

  // `B` contains equivalent nested objects and arrays.
  O* bO = OKV(
    {@"name", S.newS(@"Moe Howard")},
    {@"age", N.I(77)},
    {@"stooge", N.B(true)},
    {@"hobbies", AO(@"acting")},
    {@"film", OKV(
      {@"name", @"Sing a Song of Six Pants"},
      {@"release", Date.newYMD(1947, 9, 30)},
      {@"stars", AO(S.newS(@"Larry Fine"), @"Shemp Howard")},
      {@"minutes", N.I(16)},
      {@"seconds", N.I(54)}
    )}
  );
  ok(_.chain(aO).isEqual(bO).B, @"Objects with nested equivalent members are recursively compared");

//  // Instances.
//  ok(_.isEqual(new First, new First), @"Object instances are equal");
//  ok(!_.isEqual(new First, new Second), @"Objects with different constructors and identical own properties are not equal");
//  ok(!_.isEqual({value: 1}, new First), @"Object instances and objects sharing equivalent properties are not equal");
//  ok(!_.isEqual({value: 2}, new Second), @"The prototype chain of objects should not be examined");

  // REVIEW: support circular structure?

//  // Circular Arrays.
//  (aA = A.new).push(aA);
//  (bA = A.new).push(bA);
//  ok(_.isEqual(aA, bA), @"Arrays containing circular references are equal");
//  aA.push(S.newS(@"Larry"));
//  bA.push(S.newS(@"Larry"));
//  ok(_.isEqual(aA, bA), @"Arrays containing circular references and equivalent properties are equal");
//  aA.push(@"Shemp");
//  bA.push(@"Curly");
//  ok(!_.isEqual(aA, bA), @"Arrays containing circular references and different properties are not equal");
//
//  // Circular Objects.
//  aO = OKV({@"abc", nil});
//  bO = OKV({@"abc", nil});
//  aO.set(@"abc", aO);
//  bO.set(@"abc", bO);
//  ok(_.isEqual(aO, bO), @"Objects containing circular references are equal");
//  aO.set(@"def", N.I(75));
//  bO.set(@"def", N.I(75));
//  ok(_.isEqual(aO, bO), @"Objects containing circular references and equivalent properties are equal");
//  aO.set(@"def", N.I(75));
//  bO.set(@"def", N.I(63));
//  ok(!_.isEqual(aO, bO), @"Objects containing circular references and different properties are not equal");
//
//  // Cyclic Structures.
//  aA = AO(OKV({@"abc", nil}));
//  bA = AO(OKV({@"abc", nil}));
//  aA.getAt(0).set(@"abc", aA).push(aA);
//  bA.getAt(0).set(@"abc", bA).push(bA);
//  ok(_.isEqual(aA, bA), @"Cyclic structures are equal");
//  aA.getAt(0).set(@"def", @"Larry");
//  bA.getAt(0).set(@"def", @"Larry");
//  ok(_.isEqual(aA, bA), @"Cyclic structures containing equivalent properties are equal");
//  aA.getAt(0).set(@"def", S.newS(@"Larry"));
//  bA.getAt(0).set(@"def", S.newS(@"Curly"));
//  ok(!_.isEqual(aA, bA), @"Cyclic structures containing different properties are not equal");
//
//  // Complex Circular References.
//  aO = OKV({@"foo", OKV({@"b", OKV({@"foo", OKV({@"c", OKV({@"foo", nil})})})})});
//  bO = OKV({@"foo", OKV({@"b", OKV({@"foo", OKV({@"c", OKV({@"foo", nil})})})})});
//  aO.get(@"foo").get(@"b").get(@"foo").get(@"c").set(@"foo", aO);
//  bO.get(@"foo").get(@"b").get(@"foo").get(@"c").set(@"foo", bO);
//  ok(_.isEqual(aO, bO), @"Cyclic structures with nested and identically-named properties are equal");

  // Chaining.
  ok(!_.chain(_.chain(OKV({@"x", N.I(1)}, {@"y", /*undefined*/ nil})).chain()).isEqual(_.chain(OKV({@"x", N.I(1)}, {@"z", N.I(2)})).chain()).B, @"Chained objects containing different values are not equal");
  equalI(_.chain(OKV({@"x", N.I(1)}, {@"y", N.I(2)})).chain().isEqual(_.chain(OKV({@"x", N.I(1)}, {@"y", N.I(2)})).chain()).B, true, @"`isEqual` can be chained");

  // Custom `isEqual` methods.
  __block O* isEqualObj = OKV({@"isEqual", ^(O* o){ return o.get(@"isEqual") == isEqualObj.get(@"isEqual"); }}, {@"unique", O.new});
  O* isEqualObjClone = OKV({@"isEqual", isEqualObj.get(@"isEqual")}, {@"unique", O.new});

  ok(_.chain(isEqualObj).isEqual(isEqualObjClone).B, @"Both objects implement identical `isEqual` methods");
  ok(_.chain(isEqualObjClone).isEqual(isEqualObj).B, @"Commutative equality is implemented for objects with custom `isEqual` methods");
  ok(!_.chain(isEqualObj).isEqual(O.new).B, @"Objects that do not implement equivalent `isEqual` methods are not equal");
  ok(!_.chain(O.new).isEqual(isEqualObj).B, @"Commutative equality is implemented for objects with different `isEqual` methods");

  // REVIEW: needed in ObjectiveC? Slows down comparison
  // Custom `isEqual` methods - comparing different types
//  LocalizedString* localized_string1 = [[LocalizedString alloc] initWithId:10];
//  LocalizedString* localized_string2 = [[LocalizedString alloc] initWithId:10];
//  LocalizedString* localized_string3 = [[LocalizedString alloc] initWithId:11];
//  ok(_.isEqual(localized_string1, localized_string2), @"comparing same typed instances with same ids");
//  ok(!_.isEqual(localized_string1, localized_string3), @"comparing same typed instances with different ids");
//  ok(_.isEqual(localized_string1, @"Bonjour"), @"comparing different typed instances with same values");
//  ok(_.isEqual(@"Bonjour", localized_string1), @"comparing different typed instances with same values");
//  ok(!_.isEqual(@"Bonjour", localized_string3), @"comparing two localized strings with different ids");
//  ok(!_.isEqual(localized_string1, @"Au revoir"), @"comparing different typed instances with different values");
//  ok(!_.isEqual(@"Au revoir", localized_string1), @"comparing different typed instances with different values");

//  // Custom `isEqual` methods - comparing with serialized data
//  Date.prototype.toJSON = ^() {
//    return {
//      _type:"Date",
//      year:this.getUTCFullYear(),
//      month:this.getUTCMonth(),
//      day:this.getUTCDate(),
//      hours:this.getUTCHours(),
//      minutes:this.getUTCMinutes(),
//      seconds:this.getUTCSeconds()
//    };
//  };
//  Date.prototype.isEqual = ^(that) {
//    var this_date_components = this.toJSON();
//    var that_date_components = (that instanceof Date) ? that.toJSON() : that;
//    delete this_date_components["_type"]; delete that_date_components["_type"];
//    return _.isEqual(this_date_components, that_date_components);
//  };
//
//  var date = new Date();
//  var date_json = {
//    _type:"Date",
//    year:date.getUTCFullYear(),
//    month:date.getUTCMonth(),
//    day:date.getUTCDate(),
//    hours:date.getUTCHours(),
//    minutes:date.getUTCMinutes(),
//    seconds:date.getUTCSeconds()
//  };
//
//  ok(_.isEqual(date_json, date), @"serialized date matches date");
//  ok(_.isEqual(date, date_json), @"date matches serialized date");
}

- (void)test_isEmpty
{
  ok(!_.chain(AI(1)).isEmpty().B, @"[1] is not empty"); //  ok(!_.chain(AI(1)).isEmpty(), @"[1] is not empty");
  ok(_.chain(A.new).isEmpty().B, @"[] is empty");
  ok(!_.chain(OKV({@"one", N.I(1)})).isEmpty().B, @"{one : 1} is not empty");
  ok(_.chain(O.new).isEmpty().B, @"{} is empty");
//  ok(_.isEmpty(new RegExp(@"")), @"objects with prototype properties are empty");
  ok(_.chain(nil).isEmpty().B, @"null is empty");
//  ok(_.isEmpty(), @"undefined is empty");
  ok(_.chain(@"").isEmpty().B, @"the empty string is empty");
  ok(!_.chain(@"moe").isEmpty().B, @"but other strings are not");

  O* obj = OKV({@"one", N.I(1)});
  obj.delete_(@"one");
  ok(_.chain(obj).isEmpty().B, @"deleting all the keys from an object empties it");
}

/* NOT SUPPORTED: JavaScript-only because of DOM elements */
//// Setup remote variables for iFrame tests.
//var iframe = document.createElement(@"iframe");
//jQuery(iframe).addTo(document.body);
//var iDoc = iframe.contentDocument || iframe.contentWindow.document;
//iDoc.write(
//  "<script>\
//    parent.iElement   = document.createElement(@"div");\
//    parent.iArguments = (^(){ return arguments; })(1, 2, 3);\
//    parent.iArray     = [1, 2, 3];\
//    parent.iString    = S.newS(@"hello");\
//    parent.iNumber    = new Number(100);\
//    parent.iFunction  = (^(){});\
//    parent.iDate      = new Date();\
//    parent.iRegExp    = /hi/;\
//    parent.iNaN       = NaN;\
//    parent.iNull      = null;\
//    parent.iBoolean   = new Boolean(false);\
//    parent.iUndefined = undefined;\
//  </script>"
//);
//iDoc.close();
//
//- (void)test_isElement {
//  ok(!_.isElement(@"div"), @"strings are not dom elements");
//  ok(_.isElement($(@"html")[0]), @"the html tag is a DOM element");
//  ok(_.isElement(iElement), @"even from another frame");
//}

- (void)test_isArguments {
  A* args = (^(I arg1, ...){ ARGS_AI(arguments, arg1); return arguments; })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
  ok(!_.chain(@"string").isArguments().B, @"a string is not an arguments object");
  ok(!_.chain(_.isArguments).isArguments().B, @"a function is not an arguments object");
  ok(_.chain(args).isArguments().B, @"but the arguments object is an arguments object");
  ok(!_.chain(_.toArray(args)).isArguments().B, @"but not when it\"s converted into an array");
  ok(!_.chain(AI(1,2,3)).isArguments().B, @"and not vanilla arrays.");
//  ok(_.isArguments(iArguments), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isObject
{
  (^(I arg1, ...){ ARGS_AI(arguments, arg1); ok(_.chain(arguments).isObject().B, @"the arguments object is object"); })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
  ok(_.chain(AI(1, 2, 3)).isObject().B, @"and arrays");
//  ok(_.isObject($(@"html")[0]), @"and DOM element"); /* NOT SUPPORTED: JavaScript-only because of DOM elements */
//  ok(_.isObject(iElement), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
  ok(_.chain(^ () {}).isObject().B, @"and functions");
//  ok(_.isObject(iFunction), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
  ok(!_.chain(nil).isObject().B, @"but not null");
//  ok(!_.isObject(undefined), @"and not undefined"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  ok(/* CHANGE: string literals are objects since they can use NSString functions ! */ _.chain(@"string").isObject().B, @"and not string");
  ok(!_.chain(N.I(12)).isObject().B, @"and not number");
  ok(!_.chain(N.B(true)).isObject().B, @"and not boolean");
  ok(_.chain(S.newS(@"string")).isObject().B, @"but S.newS()");
}

- (void)test_isArray
{
  (^(I arg1, ...){ ARGS_AI(arguments, arg1); ok(/* CHANGE: Arguments are arrays! */_.chain(arguments).isArray().B, @"the arguments object is not an array"); })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
  ok(_.chain(AI(1, 2, 3)).isArray().B, @"but arrays are");
//  ok(_.isArray(iArray), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isString
{
//  ok(!_.isString(document.body), @"the document body is not a string"); /* NOT SUPPORTED: JavaScript-only because of DOM */
  ok(_.chain(AI(1, 2, 3).join(@", ")).isString().B, @"but strings are");
//  ok(_.isString(iString), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isNumber
{
  ok(!_.chain(@"string").isNumber().B, @"a string is not a number");
  (^(I arg1, ...){ ARGS_AI(arguments, arg1); ok(!_.chain(arguments).isNumber().B, @"the arguments object is not a number"); })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
//  ok(!_.isNumber(undefined), @"undefined is not a number"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  ok(_.chain(N.F(3 * 4 - 7 / 10)).isNumber().B, @"but numbers are");
  ok(_.chain(NF_NaN).isNumber().B, @"NaN *is* a number");
  ok(_.chain([NSNumber numberWithFloat:INFINITY]).isNumber().B, @"Infinity is a number");
//  ok(_.isNumber(iNumber), @"even from another frame");  /* NOT SUPPORTED: JavaScript-only because of frame */
  ok(!_.chain(@"1").isNumber().B, @"numeric strings are not numbers");
}

- (void)test_isBoolean
{
  ok(!_.chain(N.I(2)).isBoolean().B, @"a number is not a boolean");
  ok(!_.chain(@"string").isBoolean().B, @"a string is not a boolean");
  ok(!_.chain(@"false").isBoolean().B, @"the string 'false' is not a boolean");
  ok(!_.chain(@"true").isBoolean().B, @"the string 'true' is not a boolean");
  
  (^(I arg1, ...){ ARGS_AI(arguments, arg1); ok(!_.chain(arguments).isBoolean().B, @"the arguments object is not a boolean"); })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
//  ok(!_.isBoolean(undefined), @"undefined is not a boolean"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  ok(!_.chain(NF_NaN).isBoolean().B, @"NaN is not a boolean");
  ok(!_.chain(nil).isBoolean().B, @"null is not a boolean");
  ok(_.chain(N.B(true)).isBoolean().B, @"but true is");
  ok(_.chain(N.B(false)).isBoolean().B, @"and so is false");
//  ok(_.isBoolean(iBoolean), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isFunction
{
  ok(!_.chain(AI(1, 2, 3)).isFunction(/* REQUIRED */ nil).B, @"arrays are not functions");
  ok(!_.chain(@"moe").isFunction(/* REQUIRED */ nil).B, @"strings are not functions");
  ok(_.chain(_.isFunction).isFunction(/* REQUIRED */ nil).B, @"but functions are");
//  ok(_.isFunction(iFunction), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isDate
{
  ok(!_.chain(N.I(100)).isDate().B, @"numbers are not dates");
  ok(!_.chain(O.new).isDate().B, @"objects are not dates");
  ok(_.chain(Date.new).isDate().B, @"but dates are");
//  ok(_.isDate(iDate), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

/* NOT SUPPORTED: JavaScript-only because of built-in regular expressions */
//- (void)test_isRegExp {
//  ok(!_.isRegExp(_.identity), @"functions are not RegExps");
//  ok(_.isRegExp(/identity/), @"but RegExps are");
//  ok(_.isRegExp(iRegExp), @"even from another frame");
//}

- (void)test_isFinite
{
//  ok(!_.isFinite(undefined), @"undefined is not Finite"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  ok(!_.chain(nil).isFinite().B, @"null is not Finite");
  ok(!_.chain(NF_NaN).isFinite().B, @"NaN is not Finite");
  ok(!_.chain([NSNumber numberWithFloat:INFINITY]).isFinite().B, @"Infinity is not Finite");
  ok(!_.chain([NSNumber numberWithFloat:-INFINITY]).isFinite().B, @"-Infinity is not Finite");
  ok(!_.chain(@"12").isFinite().B, @"Strings are not numbers");
  N* obj = N.I(5);
  ok(_.chain(obj).isFinite().B, @"Number instances can be finite");
  ok(_.chain(N.I(0)).isFinite().B, @"0 is Finite");
  ok(_.chain(N.I(123)).isFinite().B, @"Ints are Finite");
  ok(_.chain(N.F(-12.44)).isFinite().B, @"Floats are Finite");
}

- (void)test_isNaN
{
//  ok(!_.isNaN(undefined), @"undefined is not NaN"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  ok(!_.chain(nil).isNaN().B, @"null is not NaN");
  ok(!_.chain(0).isNaN().B, @"0 is not NaN");
  ok(_.chain(NF_NaN).isNaN().B, @"but NaN is");
//  ok(_.isNaN(iNaN), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isNull
{
//  ok(!_.isNull(undefined), @"undefined is not null"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  ok(!_.chain(NF_NaN).isNull().B, @"NaN is not null");
  ok(_.chain(NSNull.null).isNull().B, @"but null is"); // ADDED
  ok(_.chain(nil).isNull().B, @"but null is");
//  ok(_.isNull(iNull), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

/* NOT SUPPORTED: JavaScript-only because of undefined */
//- (void)test_isUndefined
//{
//  ok(!_.isUndefined(1), @"numbers are defined");
//  ok(!_.isUndefined(null), @"null is defined");
//  ok(!_.isUndefined(false), @"false is defined");
//  ok(!_.isUndefined(NaN), @"NaN is defined");
//  ok(_.isUndefined(), @"nothing is undefined");
//  ok(_.isUndefined(undefined), @"undefined is undefined");
//  ok(_.isUndefined(iUndefined), @"even from another frame");
//}

/* NOT SUPPORTED: JavaScript-only because of browser feature */
//if (window.ActiveXObject) {
//  - (void)test_IE host objects {
//    var xml = new ActiveXObject(@"Msxml2.DOMDocument.3.0");
//    ok(!_.isNumber(xml));
//    ok(!_.isBoolean(xml));
//    ok(!_.isNaN(xml));
//    ok(!_.isFunction(xml));
//    ok(!_.isNull(xml));
//    ok(!_.isUndefined(xml));
//  }
//}

- (void)test_tap
{
  __block id intercepted = nil;
 _TapBlock interceptor = ^(id obj) { intercepted = obj; };
  N* returned = _.chain(N.I(1)).tap(interceptor).N;
  equal(intercepted, N.I(1), @"passes tapped object to interceptor");
  equal(returned, N.I(1), @"returns tapped object");

  returned = _.chain(AI(1,2,3)).chain()
    .map(^(N* n, /* REQUIRED */ ...){ return N.I(n.I * 2); })
    .max(/* REQUIRED*/ nil)
    .tap(interceptor)
    .N;
  ok(returned == N.I(6) && intercepted == N.I(6), @"can use tapped objects in a chain");
}

@end
