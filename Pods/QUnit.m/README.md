[![Build Status](https:secure.travis-ci.org/kmalakoff/QUnit.m.png)](http:travis-ci.org/kmalakoff/QUnit.m)

````
QUnit.m
````
QUnit.m brings [QUnit.js](http://qunitjs.com/) syntax to SenTestingKit for testing Objective-C projects. The is useful if you are trying to port JavaScript libraries to Objective-C or want a more familiar testing syntax.

I wrote this to help me port Underscore.js to Objective-C in [_.m](https://github.com/kmalakoff/_.m) and to make Objective-C a little more script in [Subjective-Script](https://github.com/kmalakoff/SubjectiveScript.m) so you will find some good examples in those project's tests.

**Note:** the library is still in its early days so please submit pull requests with corresponding tests to fix any issues and to bring the feature set up to the level of QUnit.js!

Examples (some from _.m and Subjective-Script)
------------

equal

```
equal(AI(1,2,3).reverse().join(@","), @"3,2,1", @"reverse works");
```

strictEqual

```
strictEqual(_.chain(array).find(^B(N* n) { return n.I > 2; }).N, N.I(3), @"should return first found `value`");
```

deepEqual

```
_WrappedBlock wrapped = _.wrap(noop, ^A*(_WrappedBlock fn, id arg1, ...){ ARGS_AO(arguments, arg1); return A.newNSO(fn).concat(arguments); });
A* ret     = wrapped(AO(@"whats", @"your"), @"vector", @"victor", nil);
deepEqual(ret, AO(noop, AO(@"whats", @"your"), @"vector", @"victor"), @"deep wrapping");
```

notEqual

```
notEqual(AI(1,2,3).reverse().join(@","), @"1,2,3", @"reverse works");
```

ok

```
ok(OKV({@"int", N.I(1)}, {@"float", N.F(2.0)}).hasOwnProperty(@"int"), @"has an int");
```

raises

```
raises(^{ _.reduce(A.new, ^(N* memo, N* num, ...){ return memo; }, 0); }, @"TypeError", @"throws an error for empty arrays with no initial value");
```

asyncTest

```
asyncTest(^{
  __block BOOL called1 = false;
  SSTimeout* timeout1 = SS.setTimeout(^{ called1 = true; }, NSEC_PER_SEC*1);
  SS.clearTimeout(timeout1);

  __block BOOL called2 = false;
  SS.setTimeout(^{ called2 = true; start(); }, NSEC_PER_SEC*2);
});
```
