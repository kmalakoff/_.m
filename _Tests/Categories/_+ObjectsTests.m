//
//  _+ObjectsTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_+ObjectsTests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

// For isEqual test
@interface LocalizedString : NSObject
- (id)initWithId:(I)stringId;
- (B(^)(NSO* that))isEqual;
@end

@implementation LocalizedString
{
  I mId;
  NSS* mString;
}

- (id)initWithId:(I)stringId
{
  self = [super init];
  if (!self) return self;
  mId = stringId;
  mString = (mId==10) ? @"Bonjour" : @"";
  return self;
}
- (B(^)(NSO* that))isEqual
{
  return ^B(NSO* that) {
    if (_.isString(that)) return [mString isEqualToString:(NSS*)that];
    else if (that.instanceof(@"LocalizedString")) return mId == ((LocalizedString*)that)->mId;
    return false;
  };
}
@end

@implementation __ObjectsTests

- (void)test_keys
{
  self.equal(_.keys(OKV({@"one", N.I(1)}, {@"two", N.I(2)})).join(@", "), @"one, two", @"can extract the keys from an object");
  // the test above is not safe because it relies on for-in enumeration order
  A* a = A.new; a.setAt(1, N.I(0));
//  self.equal(_.keys(a).join(@", "), @"1", @"is not fooled by sparse arrays; see issue #95"); /* NOT SUPPORTED: strict type checking */
  self.raises(^() { _.keys(nil); }, @"TypeError", @"throws an error for `null` values");
//  self.raises(^() { _.keys(void 0); }, TypeError, @"throws an error for `undefined` values"); /* NOT SUPPORTED: JavaScript-only because of undefined */
//  self.raises(^() { _.keys(1); }, TypeError, @"throws an error for number primitives");
//  self.raises(^() { _.keys(@"a"); }, TypeError, @"throws an error for string primitives");
//  self.raises(^() { _.keys(true); }, TypeError, @"throws an error for boolean primitives"); /* NOT SUPPORTED: strict type checking */
}

- (void)test_values
{
  self.equal(_.values(OKV({@"one", N.I(1)}, {@"two", N.I(2)})).join(@", "), @"1, 2", @"can extract the values from an object");
}

- (void)test_functions
{
  O* obj = OKV({@"a", @"dash"}, {@"b", _.map}, /*{@"c", (/yo/)},*/ {@"d", _.reduce});
  self.ok(_.isEqual(AO(@"b", @"d"), _.functions(obj)), @"can grab the function names of any passed-in object");

  /* NOT SUPPORTED: JavaScript-only because of prototype */
//  void(^Animal)() = ^(){};
//  Animal.prototype.run = ^(){};
//  self.equal(_.functions(new Animal).join(@""), @"run", @"also loself.oks up functions on the prototype");
}

- (void)test_extend
{
  O* result;
  self.equal(_.extend(O.new, OKV({@"a",@"b"}), /* NIL TERMINATED */ nil).get(@"a"), @"b", @"can extend an object with the attributes of another");
  self.equal(_.extend(OKV({@"a",@"x"}, {@"a",@"b"}), /* NIL TERMINATED */ nil).get(@"a"), @"b", @"properties in source override destination");
  self.equal(_.extend(OKV({@"x",@"x"}, {@"a",@"b"}), /* NIL TERMINATED */ nil).get(@"x"), @"x", @"properties not in source dont get overriden");
  result = _.extend(OKV({@"x",@"x"}), OKV({@"a",@"a"}), OKV({@"b",@"b"}), /* NIL TERMINATED */ nil);
  self.ok(_.isEqual(result, OKV({@"x",@"x"}, {@"a",@"a"}, {@"b",@"b"})), @"can extend from multiple source objects");
  result = _.extend(OKV({@"x",@"x"}), OKV({@"a",@"a"}, {@"x",N.I(2)}), OKV({@"a",@"b"}));
  self.ok(_.isEqual(result, OKV({@"x",N.I(2)}, {@"a",@"b"})), @"extending from multiple source objects last property trumps");
  result = _.extend(O.new, OKV(/*{@"a", void 0},*/ {@"a", NSNull.null}, {@"b", nil}), /* NIL TERMINATED */ nil);
  self.equal(_.keys(result).join(@""), @"ab", @"extend does not copy undefined values");
}

- (void)test_pick
{
  O* result;
  result = _.pick(OKV({@"a",N.I(1)}, {@"b",N.I(2)}, {@"c",N.I(3)}), @"a", @"c", /* NIL TERMINATED */ nil);
  self.ok(_.isEqual(result, OKV({@"a",N.I(1)}, {@"c",N.I(3)})), @"can restrict properties to those named");
  result = _.pick(OKV({@"a",N.I(1)}, {@"b",N.I(2)}, {@"c",N.I(3)}), AO(@"b", @"c"));
  self.ok(_.isEqual(result, OKV({@"b",N.I(2)}, {@"c",N.I(3)})), @"can restrict properties to those named in an array");
  result = _.pick(OKV({@"a",N.I(1)}, {@"b",N.I(2)}, {@"c",N.I(3)}), AO(@"a"), @"b");
  self.ok(_.isEqual(result, OKV({@"a",N.I(1)}, {@"b",N.I(2)})), @"can restrict properties to those named in mixed args");
}

- (void)test_defaults
{
  O* options = OKV({@"zero", N.I(0)}, {@"one", N.I(1)}, {@"empty", @""}, {@"nan", NF_NaN}, {@"string", @"string"});

  _.defaults(options, OKV({@"zero", N.I(1)}, {@"one", N.I(10)}, {@"twenty", N.I(20)}), /* NIL_TERMINATED */ nil);
  self.equal(options.get(@"zero"), N.I(0), @"value exists");
  self.equal(options.get(@"one"), N.I(1), @"value exists");
  self.equal(options.get(@"twenty"), N.I(20), @"default applied");

  _.defaults(options, OKV({@"empty", @"full"}), OKV({@"nan", @"nan"}), OKV({@"word", @"word"}), OKV({@"word", @"dog"}), /* NIL TERMINATED */ nil);
  self.equal(options.get(@"empty"), @"", @"value exists");
  self.ok(_.isNaN(options.get(@"nan")), @"NaN isn't overridden");
  self.equal(options.get(@"word"), @"word", @"new value is added, first one wins");
}

- (void)test_clone
{
  O* moe = OKV({@"name", @"moe"}, {@"lucky", AI(13, 27, 34)});
  O* clone = (O*) _.clone(moe);
  self.equal(clone.get(@"name"), @"moe", @"the clone as the attributes of the original");

  clone.set(@"name", @"curly");
  self.ok([(NSS*)clone.get(@"name") isEqualToString:@"curly"] && [(NSS*)moe.get(@"name") isEqualToString:@"moe"], @"clones can change shallow attributes without affecting the original");

  clone.get(@"lucky").push(N.I(101));
  self.equal(_.last((A*)moe.get(@"lucky"), /* MANDATORY */ -1), N.I(101), @"changes to deep attributes are shared with the original");

//  self.equal(_.clone(undefined), void 0, @"non objects should not be changed by clone"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  self.equal(_.clone(N.I(1)), N.I(1), @"non objects should not be changed by clone");
  self.equal(_.clone(nil), nil, @"non objects should not be changed by clone");
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

  // Basic self.equality and identity comparisons.
  self.ok(_.isEqual(nil, nil), @"`null` is self.equal to `null`");
//  self.ok(_.isEqual(), @"`undefined` is self.equal to `undefined`"); /* NOT SUPPORTED: JavaScript-only because of undefined */

  self.ok(/* ! CHANGE: equal */ _.isEqual(N.I(0), N.I(-0)), @"`0` is self.equal to `-0`");
  self.ok(/* ! CHANGE: equal */ _.isEqual(N.I(-0), N.I(0)), @"Commutative self.equality is implemented for `0` and `-0`");
//  self.ok(!_.isEqual(null, undefined), @"`null` is not self.equal to `undefined`"); /* NOT SUPPORTED: JavaScript-only because of undefined */
//  self.ok(!_.isEqual(undefined, null), @"Commutative self.equality is implemented for `null` and `undefined`"); /* NOT SUPPORTED: JavaScript-only because of undefined */

  // String object and primitive comparisons.
  self.ok(_.isEqual(@"Curly", @"Curly"), @"Identical string primitives are self.equal");
  self.ok(_.isEqual(S.newS(@"Curly"), S.newS(@"Curly")), @"String objects with identical primitive values are self.equal");
  self.ok(_.isEqual(S.newS(@"Curly"), @"Curly"), @"String primitives and their corresponding object wrappers are self.equal");
  self.ok(_.isEqual(@"Curly", S.newS(@"Curly")), @"Commutative self.equality is implemented for string objects and primitives");

  self.ok(!_.isEqual(@"Curly", @"Larry"), @"String primitives with different values are not self.equal");
  self.ok(!_.isEqual(S.newS(@"Curly"), S.newS(@"Larry")), @"String objects with different primitive values are not self.equal");
  self.ok(!_.isEqual(S.newS(@"Curly"), OKV({@"toString", ^(){ return "Curly"; }})), @"String objects and objects with a custom `toString` method are not self.equal");

  // Number object and primitive comparisons.
//  self.ok(_.isEqual(75, 75), @"Identical number primitives are self.equal");
  self.ok(_.isEqual(N.I(75), N.I(75)), @"Number objects with identical primitive values are self.equal");
//  self.ok(_.isEqual(75, new Number(75)), @"Number primitives and their corresponding object wrappers are self.equal"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  self.ok(_.isEqual(new Number(75), 75), @"Commutative self.equality is implemented for number objects and primitives"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  self.ok(!_.isEqual(new Number(0), -0), @"`new Number(0)` and `-0` are not self.equal"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  self.ok(!_.isEqual(0, new Number(-0)), @"Commutative self.equality is implemented for `new Number(0)` and `-0`"); /* NOT SUPPORTED: JavaScript-only because of primitives */

  self.ok(!_.isEqual(N.I(75), N.I(63)), @"Number objects with different primitive values are not self.equal");
  self.ok(!_.isEqual(N.I(63), OKV({@"valueOf", ^(){ return 63; }})), @"Number objects and objects with a `valueOf` method are not self.equal");

  // Comparisons involving `NaN`.
  self.ok(_.isEqual(NF_NaN, NF_NaN), @"`NaN` is self.equal to `NaN`");
  self.ok(!_.isEqual(N.F(61), NF_NaN), @"A number primitive is not self.equal to `NaN`");
  self.ok(!_.isEqual(N.F(79), NF_NaN), @"A number object is not self.equal to `NaN`");
  self.ok(!_.isEqual(NF_POS_INFINITY, NF_NaN), @"`Infinity` is not self.equal to `NaN`");

  // Boolean object and primitive comparisons.
  self.ok(_.isEqual(N.B(true), N.B(true)), @"Identical boolean primitives are self.equal");
//  self.ok(_.isEqual(new Boolean, new Boolean), @"Boolean objects with identical primitive values are self.equal"); /* NOT SUPPORTED: JavaScript-only because of default new */
//  self.ok(_.isEqual(true, new Boolean(true)), @"Boolean primitives and their corresponding object wrappers are self.equal"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  self.ok(_.isEqual(new Boolean(true), true), @"Commutative self.equality is implemented for booleans"); /* NOT SUPPORTED: JavaScript-only because of primitives */
//  self.ok(!_.isEqual(new Boolean(true), new Boolean), @"Boolean objects with different primitive values are not self.equal"); /* NOT SUPPORTED: JavaScript-only because of default new */

  // Common type coercions.
//  self.ok(!_.isEqual(true, new Boolean(false)), @"Boolean objects are not self.equal to the boolean primitive `true`");
  self.ok(!_.isEqual(@"75", N.I(75)), @"String and number primitives with like values are not self.equal");
  self.ok(!_.isEqual(N.I(63), S.newS(@"63")), @"String and number objects with like values are not self.equal");
  self.ok(!_.isEqual(N.I(75), @"75"), @"Commutative self.equality is implemented for like string and number values");
  self.ok(!_.isEqual(N.I(0), @""), @"Number and string primitives with like values are not self.equal");
  self.ok(!_.isEqual(N.I(1), N.B(true)), @"Number and boolean primitives with like values are not self.equal");
  self.ok(!_.isEqual(N.B(false), N.I(0)), @"Boolean and number objects with like values are not self.equal");
  self.ok(!_.isEqual(N.B(false), S.newS(@"")), @"Boolean primitives and string objects with like values are not self.equal");
//  self.ok(!_.isEqual(12564504e5, new Date(2009, 9, 25)), @"Dates and their corresponding numeric primitive values are not self.equal");

  // Dates.
  self.ok(_.isEqual(D.newYMD(2009, 9, 25), D.newYMD(2009, 9, 25)), @"Date objects referencing identical times are self.equal");
  self.ok(!_.isEqual(D.newYMD(2009, 9, 25), D.newYMD(2009, 11, 13)), @"Date objects referencing different times are not self.equal");
  self.ok(!_.isEqual(D.newYMD(2009, 11, 13), OKV({
    @"getTime", ^(){
      return 12606876e5;
    }
  })), @"Date objects and objects with a `getTime` method are not self.equal");
//  self.ok(!_.isEqual(new Date(@"Curly"), new Date(@"Curly")), @"Invalid dates are not self.equal");

  // Functions.
//  self.ok(!_.isEqual(First, Second), @"Different functions with identical bodies and source code representations are not self.equal");

  // RegExps.
//  self.ok(_.isEqual(/(?:)/gim, /(?:)/gim), @"RegExps with equivalent patterns and flags are self.equal");
//  self.ok(!_.isEqual(/(?:)/g, /(?:)/gi), @"RegExps with equivalent patterns and different flags are not self.equal");
//  self.ok(!_.isEqual(/Moe/gim, /Curly/gim), @"RegExps with different patterns and equivalent flags are not self.equal");
//  self.ok(!_.isEqual(/(?:)/gi, /(?:)/g), @"Commutative self.equality is implemented for RegExps");
//  self.ok(!_.isEqual(/Curly/g, {source: "Larry", global: true, ignoreCase: false, multiline: false}), @"RegExps and RegExp-like objects are not self.equal");

  // Empty arrays, array-like objects, and object literals.
  self.ok(_.isEqual(O.new, O.new), @"Empty object literals are self.equal");
  self.ok(_.isEqual(A.new, A.new), @"Empty array literals are self.equal");
  self.ok(_.isEqual(AO(O.new), AO(O.new)), @"Empty nested arrays and objects are self.equal");
  self.ok(!_.isEqual(OKV({@"length", N.I(0)}), A.new), @"Array-like objects and arrays are not self.equal.");
  self.ok(!_.isEqual(A.new, OKV({@"length", N.I(0)})), @"Commutative self.equality is implemented for array-like objects");

  self.ok(!_.isEqual(O.new, A.new), @"Object literals and array literals are not self.equal");
  self.ok(!_.isEqual(A.new, O.new), @"Commutative self.equality is implemented for objects and arrays");

  // Arrays with primitive and object values.
  self.ok(_.isEqual(AO(N.I(1), @"Larry", N.B(true)), AO(N.I(1), @"Larry", N.B(true))), @"Arrays containing identical primitives are self.equal");
  self.ok(_.isEqual(AO(/*(/Moe/g),*/ D.newYMD(2009, 9, 25)), AO(/*(/Moe/g),*/ D.newYMD(2009, 9, 25))), @"Arrays containing equivalent elements are self.equal");

  // Multi-dimensional arrays.
  A* aA = AO(N.I(47), N.B(false), @"Larry", /*/Moe/,*/ D.newYMD(2009, 11, 13), AO(@"running", @"biking", S.newS(@"programming")), OKV({@"a", N.I(47)}));
  A* bA = AO(N.I(47), N.B(false), @"Larry", /*/Moe/,*/ D.newYMD(2009, 11, 13), AO(@"running", @"biking", S.newS(@"programming")), OKV({@"a", N.I(47)}));
  self.ok(_.isEqual(aA, bA), @"Arrays containing nested arrays and objects are recursively compared");

//  // Overwrite the methods defined in ES 5.1 section 15.4.4.
//  a.forEach = a.map = a.filter = a.every = a.indexOf = a.lastIndexOf = a.some = a.reduce = a.reduceRight = null;
//  b.join = b.pop = b.reverse = b.shift = b.slice = b.splice = b.concat = b.sort = b.unshift = null;

  // Array elements and properties.
  self.ok(_.isEqual(aA, bA), @"Arrays containing equivalent elements and different non-numeric properties are self.equal");
  aA.push(@"White Rocks");
  self.ok(!_.isEqual(aA, bA), @"Arrays of different lengths are not self.equal");
  aA.push(@"East Boulder");
  bA.push(@"Gunbarrel Ranch").push(@"Teller Farm");
  self.ok(!_.isEqual(aA, bA), @"Arrays of identical lengths containing different elements are not self.equal");

  // Sparse arrays.
  self.ok(_.isEqual(A.newSparse(3), A.newSparse(3)), @"Sparse arrays of identical lengths are self.equal");
  self.ok(!_.isEqual(A.newSparse(3), A.newSparse(6)), @"Sparse arrays of different lengths are not self.equal when both are empty");

  // According to the Microsoft deviations spec, section 2.1.26, JScript 5.x treats `undefined`
  // elements in arrays as elisions. Thus, sparse arrays and dense arrays containing `undefined`
  // values are equivalent.
//  if (0 in [undefined]) {
//    self.ok(!_.isEqual(Array(3), [undefined, undefined, undefined]), @"Sparse and dense arrays are not self.equal");
//    self.ok(!_.isEqual([undefined, undefined, undefined], Array(3)), @"Commutative self.equality is implemented for sparse and dense arrays");
//  }

  // Simple objects.
  self.ok(_.isEqual(OKV({@"a", @"Curly"}, {@"b", N.I(1)}, {@"c", N.B(true)}), OKV({@"a", @"Curly"}, {@"b", N.I(1)}, {@"c", N.B(true)})), @"Objects containing identical primitives are self.equal");
  self.ok(_.isEqual(OKV(/*{@"a", /Curly/g},*/ {@"b", D.newYMD(2009, 11, 13)}), OKV(/*{@"a", /Curly/g},*/ {@"b", D.newYMD(2009, 11, 13)})), @"Objects containing equivalent members are self.equal");
  self.ok(!_.isEqual(OKV({@"a", N.I(63)}, {@"b", N.I(75)}), OKV({@"a", N.I(61)}, {@"b", N.I(55)})), @"Objects of identical sizes with different values are not self.equal");
  self.ok(!_.isEqual(OKV({@"a", N.I(63)}, {@"b", N.I(75)}), OKV({@"a", N.I(61)}, {@"c", N.I(55)})), @"Objects of identical sizes with different property names are not self.equal");
  self.ok(!_.isEqual(OKV({@"a", N.I(1)}, {@"b", N.I(2)}), OKV({@"a", N.I(1)})), @"Objects of different sizes are not self.equal");
  self.ok(!_.isEqual(OKV({@"a", N.I(1)}), OKV({@"a", N.I(1)}, {@"b", N.I(2)})), @"Commutative self.equality is implemented for objects");
  self.ok(!_.isEqual(OKV({@"x", N.I(1)}, {@"y", /*undefined*/ nil}), OKV({@"x", N.I(1)}, {@"z", N.I(2)})), @"Objects with identical keys and different values are not equivalent");

  // `A` contains nested objects and arrays.
  O* aO = OKV(
    {@"name", S.newS(@"Moe Howard")},
    {@"age", N.I(77)},
    {@"stooge", N.B(true)},
    {@"hobbies", AO(@"acting")},
    {@"film", OKV(
      {@"name", @"Sing a Song of Six Pants"},
      {@"release", D.newYMD(1947, 9, 30)},
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
      {@"release", D.newYMD(1947, 9, 30)},
      {@"stars", AO(S.newS(@"Larry Fine"), @"Shemp Howard")},
      {@"minutes", N.I(16)},
      {@"seconds", N.I(54)}
    )}
  );
  self.ok(_.isEqual(aO, bO), @"Objects with nested equivalent members are recursively compared");

//  // Instances.
//  self.ok(_.isEqual(new First, new First), @"Object instances are self.equal");
//  self.ok(!_.isEqual(new First, new Second), @"Objects with different constructors and identical own properties are not self.equal");
//  self.ok(!_.isEqual({value: 1}, new First), @"Object instances and objects sharing equivalent properties are not self.equal");
//  self.ok(!_.isEqual({value: 2}, new Second), @"The prototype chain of objects should not be examined");

  // TODO: support circular structure?

//  // Circular Arrays.
//  (aA = A.new).push(aA);
//  (bA = A.new).push(bA);
//  self.ok(_.isEqual(aA, bA), @"Arrays containing circular references are self.equal");
//  aA.push(S.newS(@"Larry"));
//  bA.push(S.newS(@"Larry"));
//  self.ok(_.isEqual(aA, bA), @"Arrays containing circular references and equivalent properties are self.equal");
//  aA.push(@"Shemp");
//  bA.push(@"Curly");
//  self.ok(!_.isEqual(aA, bA), @"Arrays containing circular references and different properties are not self.equal");
//
//  // Circular Objects.
//  aO = OKV({@"abc", nil});
//  bO = OKV({@"abc", nil});
//  aO.set(@"abc", aO);
//  bO.set(@"abc", bO);
//  self.ok(_.isEqual(aO, bO), @"Objects containing circular references are self.equal");
//  aO.set(@"def", N.I(75));
//  bO.set(@"def", N.I(75));
//  self.ok(_.isEqual(aO, bO), @"Objects containing circular references and equivalent properties are self.equal");
//  aO.set(@"def", N.I(75));
//  bO.set(@"def", N.I(63));
//  self.ok(!_.isEqual(aO, bO), @"Objects containing circular references and different properties are not self.equal");
//
//  // Cyclic Structures.
//  aA = AO(OKV({@"abc", nil}));
//  bA = AO(OKV({@"abc", nil}));
//  aA.getAt(0).set(@"abc", aA).push(aA);
//  bA.getAt(0).set(@"abc", bA).push(bA);
//  self.ok(_.isEqual(aA, bA), @"Cyclic structures are self.equal");
//  aA.getAt(0).set(@"def", @"Larry");
//  bA.getAt(0).set(@"def", @"Larry");
//  self.ok(_.isEqual(aA, bA), @"Cyclic structures containing equivalent properties are self.equal");
//  aA.getAt(0).set(@"def", S.newS(@"Larry"));
//  bA.getAt(0).set(@"def", S.newS(@"Curly"));
//  self.ok(!_.isEqual(aA, bA), @"Cyclic structures containing different properties are not self.equal");
//
//  // Complex Circular References.
//  aO = OKV({@"foo", OKV({@"b", OKV({@"foo", OKV({@"c", OKV({@"foo", nil})})})})});
//  bO = OKV({@"foo", OKV({@"b", OKV({@"foo", OKV({@"c", OKV({@"foo", nil})})})})});
//  aO.get(@"foo").get(@"b").get(@"foo").get(@"c").set(@"foo", aO);
//  bO.get(@"foo").get(@"b").get(@"foo").get(@"c").set(@"foo", bO);
//  self.ok(_.isEqual(aO, bO), @"Cyclic structures with nested and identically-named properties are self.equal");

  // Chaining.
  self.ok(!_.isEqual(__(OKV({@"x", N.I(1)}, {@"y", /*undefined*/ nil})).chain(), __(OKV({@"x", N.I(1)}, {@"z", N.I(2)})).chain()), @"Chained objects containing different values are not self.equal");
  self.equalI(__(OKV({@"x", N.I(1)}, {@"y", N.I(2)})).chain().isEqual(__(OKV({@"x", N.I(1)}, {@"y", N.I(2)})).chain()).valueB(), YES, @"`isEqual` can be chained");

  // Custom `isEqual` methods.
  __block O* isEqualObj = OKV({@"isEqual", ^(O* o){ return o.get(@"isEqual") == isEqualObj.get(@"isEqual"); }}, {@"unique", O.new});
  O* isEqualObjClone = OKV({@"isEqual", isEqualObj.get(@"isEqual")}, {@"unique", O.new});

  self.ok(_.isEqual(isEqualObj, isEqualObjClone), @"Both objects implement identical `isEqual` methods");
  self.ok(_.isEqual(isEqualObjClone, isEqualObj), @"Commutative self.equality is implemented for objects with custom `isEqual` methods");
  self.ok(!_.isEqual(isEqualObj, O.new), @"Objects that do not implement equivalent `isEqual` methods are not self.equal");
  self.ok(!_.isEqual(O.new, isEqualObj), @"Commutative self.equality is implemented for objects with different `isEqual` methods");

  // TODO: needed in ObjectiveC? Slows down comparison
  // Custom `isEqual` methods - comparing different types
//  LocalizedString* localized_string1 = [[LocalizedString alloc] initWithId:10];
//  LocalizedString* localized_string2 = [[LocalizedString alloc] initWithId:10];
//  LocalizedString* localized_string3 = [[LocalizedString alloc] initWithId:11];
//  self.ok(_.isEqual(localized_string1, localized_string2), @"comparing same typed instances with same ids");
//  self.ok(!_.isEqual(localized_string1, localized_string3), @"comparing same typed instances with different ids");
//  self.ok(_.isEqual(localized_string1, @"Bonjour"), @"comparing different typed instances with same values");
//  self.ok(_.isEqual(@"Bonjour", localized_string1), @"comparing different typed instances with same values");
//  self.ok(!_.isEqual(@"Bonjour", localized_string3), @"comparing two localized strings with different ids");
//  self.ok(!_.isEqual(localized_string1, @"Au revoir"), @"comparing different typed instances with different values");
//  self.ok(!_.isEqual(@"Au revoir", localized_string1), @"comparing different typed instances with different values");

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
//  self.ok(_.isEqual(date_json, date), @"serialized date matches date");
//  self.ok(_.isEqual(date, date_json), @"date matches serialized date");
}

- (void)test_isEmpty
{
  self.ok(!_.isEmpty(AI(1)), @"[1] is not empty"); //  self.ok(!__(AI(1)).isEmpty(), @"[1] is not empty");
  self.ok(_.isEmpty(A.new), @"[] is empty");
  self.ok(!_.isEmpty(OKV({@"one", N.I(1)})), @"{one : 1} is not empty");
  self.ok(_.isEmpty(O.new), @"{} is empty");
//  self.ok(_.isEmpty(new RegExp(@"")), @"objects with prototype properties are empty");
  self.ok(_.isEmpty(nil), @"null is empty");
//  self.ok(_.isEmpty(), @"undefined is empty");
  self.ok(_.isEmpty(@""), @"the empty string is empty");
  self.ok(!_.isEmpty(@"moe"), @"but other strings are not");

  O* obj = OKV({@"one", N.I(1)});
  obj.delete_(@"one");
  self.ok(_.isEmpty(obj), @"deleting all the keys from an object empties it");
}

/* NOT SUPPORTED: JavaScript-only because of DOM elements */
//// Setup remote variables for iFrame tests.
//var iframe = document.createElement(@"iframe");
//jQuery(iframe).appendTo(document.body);
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
//  self.ok(!_.isElement(@"div"), @"strings are not dom elements");
//  self.ok(_.isElement($(@"html")[0]), @"the html tag is a DOM element");
//  self.ok(_.isElement(iElement), @"even from another frame");
//}

- (void)test_isArguments {
  A* args = (^(I arg1, ...){ ARGS_AI(arguments, arg1); return arguments; })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
  self.ok(!_.isArguments(@"string"), @"a string is not an arguments object");
  self.ok(!_.isArguments(_.isArguments), @"a function is not an arguments object");
  self.ok(_.isArguments(args), @"but the arguments object is an arguments object");
  self.ok(!_.isArguments(_.toArray(args)), @"but not when it\"s converted into an array");
  self.ok(!_.isArguments(AI(1,2,3)), @"and not vanilla arrays.");
//  self.ok(_.isArguments(iArguments), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isObject
{
  (^(I arg1, ...){ ARGS_AI(arguments, arg1); self.ok(_.isObject(arguments), @"the arguments object is object"); })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
  self.ok(_.isObject(AI(1, 2, 3)), @"and arrays");
//  self.ok(_.isObject($(@"html")[0]), @"and DOM element"); /* NOT SUPPORTED: JavaScript-only because of DOM elements */
//  self.ok(_.isObject(iElement), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
  self.ok(_.isObject(^ () {}), @"and functions");
//  self.ok(_.isObject(iFunction), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
  self.ok(!_.isObject(nil), @"but not null");
//  self.ok(!_.isObject(undefined), @"and not undefined"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  self.ok(/* CHANGE: string literals are objects since they can use NSString functions ! */ _.isObject(@"string"), @"and not string");
  self.ok(!_.isObject(N.I(12)), @"and not number");
  self.ok(!_.isObject(N.B(YES)), @"and not boolean");
  self.ok(_.isObject(S.newS(@"string")), @"but S.newS()");
}

- (void)test_isArray
{
  (^(I arg1, ...){ ARGS_AI(arguments, arg1); self.ok(/* CHANGE: Arguments are arrays! */_.isArray(arguments), @"the arguments object is not an array"); })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
  self.ok(_.isArray(AI(1, 2, 3)), @"but arrays are");
//  self.ok(_.isArray(iArray), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isString
{
//  self.ok(!_.isString(document.body), @"the document body is not a string"); /* NOT SUPPORTED: JavaScript-only because of DOM */
  self.ok(_.isString(AI(1, 2, 3).join(@", ")), @"but strings are");
//  self.ok(_.isString(iString), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isNumber
{
  self.ok(!_.isNumber(@"string"), @"a string is not a number");
  (^(I arg1, ...){ ARGS_AI(arguments, arg1); self.ok(!_.isNumber(arguments), @"the arguments object is not a number"); })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
//  self.ok(!_.isNumber(undefined), @"undefined is not a number"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  self.ok(_.isNumber(N.F(3 * 4 - 7 / 10)), @"but numbers are");
  self.ok(_.isNumber(NF_NaN), @"NaN *is* a number");
  self.ok(_.isNumber([NSNumber numberWithFloat:INFINITY]), @"Infinity is a number");
//  self.ok(_.isNumber(iNumber), @"even from another frame");  /* NOT SUPPORTED: JavaScript-only because of frame */
  self.ok(!_.isNumber(@"1"), @"numeric strings are not numbers");
}

- (void)test_isBoolean
{
  self.ok(!_.isBoolean(N.I(2)), @"a number is not a boolean");
  self.ok(!_.isBoolean(@"string"), @"a string is not a boolean");
  self.ok(!_.isBoolean(@"false"), @"the string 'false' is not a boolean");
  self.ok(!_.isBoolean(@"true"), @"the string 'true' is not a boolean");
  
  (^(I arg1, ...){ ARGS_AI(arguments, arg1); self.ok(!_.isBoolean(arguments), @"the arguments object is not a boolean"); })(1, 2, 3, /* NI_END TERMINATED */ AI_END);
//  self.ok(!_.isBoolean(undefined), @"undefined is not a boolean"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  self.ok(!_.isBoolean(NF_NaN), @"NaN is not a boolean");
  self.ok(!_.isBoolean(nil), @"null is not a boolean");
  self.ok(_.isBoolean(N.B(true)), @"but true is");
  self.ok(_.isBoolean(N.B(false)), @"and so is false");
//  self.ok(_.isBoolean(iBoolean), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isFunction
{
  self.ok(!_.isFunction(AI(1, 2, 3), /* MANDATORY */ nil), @"arrays are not functions");
  self.ok(!_.isFunction(@"moe", /* MANDATORY */ nil), @"strings are not functions");
  self.ok(_.isFunction(_.isFunction, /* MANDATORY */ nil), @"but functions are");
//  self.ok(_.isFunction(iFunction), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isDate
{
  self.ok(!_.isDate(N.I(100)), @"numbers are not dates");
  self.ok(!_.isDate(O.new), @"objects are not dates");
  self.ok(_.isDate(D.new), @"but dates are");
//  self.ok(_.isDate(iDate), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

/* NOT SUPPORTED: JavaScript-only because of built-in regular expressions */
//- (void)test_isRegExp {
//  self.ok(!_.isRegExp(_.identity), @"functions are not RegExps");
//  self.ok(_.isRegExp(/identity/), @"but RegExps are");
//  self.ok(_.isRegExp(iRegExp), @"even from another frame");
//}

- (void)test_isFinite
{
//  self.ok(!_.isFinite(undefined), @"undefined is not Finite"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  self.ok(!_.isFinite(nil), @"null is not Finite");
  self.ok(!_.isFinite(NF_NaN), @"NaN is not Finite");
  self.ok(!_.isFinite([NSNumber numberWithFloat:INFINITY]), @"Infinity is not Finite");
  self.ok(!_.isFinite([NSNumber numberWithFloat:-INFINITY]), @"-Infinity is not Finite");
  self.ok(!_.isFinite(@"12"), @"Strings are not numbers");
  N* obj = N.I(5);
  self.ok(_.isFinite(obj), @"Number instances can be finite");
  self.ok(_.isFinite(N.I(0)), @"0 is Finite");
  self.ok(_.isFinite(N.I(123)), @"Ints are Finite");
  self.ok(_.isFinite(N.F(-12.44)), @"Floats are Finite");
}

- (void)test_isNaN
{
//  self.ok(!_.isNaN(undefined), @"undefined is not NaN"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  self.ok(!_.isNaN(nil), @"null is not NaN");
  self.ok(!_.isNaN(0), @"0 is not NaN");
  self.ok(_.isNaN(NF_NaN), @"but NaN is");
//  self.ok(_.isNaN(iNaN), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

- (void)test_isNull
{
//  self.ok(!_.isNull(undefined), @"undefined is not null"); /* NOT SUPPORTED: JavaScript-only because of undefined */
  self.ok(!_.isNull(NF_NaN), @"NaN is not null");
  self.ok(_.isNull(NSNull.null), @"but null is"); // ADDED
  self.ok(_.isNull(nil), @"but null is");
//  self.ok(_.isNull(iNull), @"even from another frame"); /* NOT SUPPORTED: JavaScript-only because of frame */
}

/* NOT SUPPORTED: JavaScript-only because of undefined */
//- (void)test_isUndefined
//{
//  self.ok(!_.isUndefined(1), @"numbers are defined");
//  self.ok(!_.isUndefined(null), @"null is defined");
//  self.ok(!_.isUndefined(false), @"false is defined");
//  self.ok(!_.isUndefined(NaN), @"NaN is defined");
//  self.ok(_.isUndefined(), @"nothing is undefined");
//  self.ok(_.isUndefined(undefined), @"undefined is undefined");
//  self.ok(_.isUndefined(iUndefined), @"even from another frame");
//}

/* NOT SUPPORTED: JavaScript-only because of browser feature */
//if (window.ActiveXObject) {
//  - (void)test_IE host objects {
//    var xml = new ActiveXObject(@"Msxml2.DOMDocument.3.0");
//    self.ok(!_.isNumber(xml));
//    self.ok(!_.isBoolean(xml));
//    self.ok(!_.isNaN(xml));
//    self.ok(!_.isFunction(xml));
//    self.ok(!_.isNull(xml));
//    self.ok(!_.isUndefined(xml));
//  }
//}

- (void)test_tap
{
  __block id intercepted = nil;
 _TapBlock interceptor = ^(id obj) { intercepted = obj; };
  N* returned = (N*) _.tap(N.I(1), interceptor);
  self.equal(intercepted, N.I(1), @"passes tapped object to interceptor");
  self.equal(returned, N.I(1), @"returns tapped object");

  // TODO - chaining
//  returned = __(AI(1,2,3)).chain().
//    map(^(N* n){ return N.I(n.I * 2); }).
//    max().
//    tap(interceptor).
//    valueN();
//  self.ok(returned == N.I(6) && intercepted == N.I(6), @"can use tapped objects in a chain");
}
  
@end
