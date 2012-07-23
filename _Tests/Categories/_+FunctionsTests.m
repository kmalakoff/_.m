//
//  _+FunctionsTests.m
//  _.m
//
//  Created by Kevin Malakoff on 7/18/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//

#import "_+FunctionsTests.h"
#import "Underscore.h"
#import "SubjectiveScript.h"

@implementation __FunctionsTests

/* NOT SUPPORTED: JavaScript-only */
//- (void)test_bind {
//  var context = {name : "moe"};
//  var func = ^(arg) { return "name: " + (this.name || arg); };
//  var bound = _.bind(func, context);
//  self.equal(bound(), @"name: moe", @"can bind a function to a context");
//
//  bound = _(func).bind(context);
//  self.equal(bound(), @"name: moe", @"can do OO-style binding");
//
//  bound = _.bind(func, null, @"curly");
//  self.equal(bound(), @"name: curly", @"can bind without specifying a context");
//
//  func = ^(salutation, name) { return salutation + ": " + name; };
//  func = _.bind(func, this, @"hello");
//  self.equal(func("moe"), @"hello: moe", @"the function was partially applied in advance");
//
//  var func = _.bind(func, this, @"curly");
//  self.equal(func(), @"hello: curly", @"the function was completely applied in advance");
//
//  var func = ^(salutation, firstname, lastname) { return salutation + ": " + firstname + " " + lastname; };
//  func = _.bind(func, this, @"hello", @"moe", @"curly");
//  self.equal(func(), @"hello: moe curly", @"the function was partially applied in advance and can accept multiple arguments");
//
//  func = ^(context, message) { self.equal(this, context, message); };
//  _.bind(func, 0, 0, @"can bind a function to `0`")();
//  _.bind(func, @"", @"", @"can bind a function to an empty string")();
//  _.bind(func, false, false, @"can bind a function to `false`")();
//
//  // These tests are only meaningful when using a browser without a native bind function
//  // To test this with a modern browser, set underscore"s nativeBind to undefined
//  var F = ^ () { return this; };
//  var Boundf = _.bind(F, {hello: "moe curly"});
//  self.equal(new Boundf().hello, undefined, @"function should not be bound to the context, to comply with ECMAScript 5");
//  self.equal(Boundf().hello, @"moe curly", @"When called without the new operator, it"s OK to be bound to the context");
//}

/* NOT SUPPORTED: JavaScript-only */
//- (void)test_bindAll {
//  var curly = {name : "curly"}, moe = {
//    name    : "moe",
//    getName : ^() { return "name: " + this.name; },
//    sayHi   : ^() { return "hi: " + this.name; }
//  };
//  curly.getName = moe.getName;
//  _.bindAll(moe, @"getName", @"sayHi");
//  curly.sayHi = moe.sayHi;
//  self.equal(curly.getName(), @"name: curly", @"unbound function is bound to current object");
//  self.equal(curly.sayHi(), @"hi: moe", @"bound function is still bound to original object");
//
//  curly = {name : "curly"};
//  moe = {
//    name    : "moe",
//    getName : ^() { return "name: " + this.name; },
//    sayHi   : ^() { return "hi: " + this.name; }
//  };
//  _.bindAll(moe);
//  curly.sayHi = moe.sayHi;
//  self.equal(curly.sayHi(), @"hi: moe", @"calling bindAll with no arguments binds all functions to the object");
//}

- (void)test_memoize {
  __block _MemoizeBlock _fib = nil;
  _MemoizeBlock fib = ^N*(N* nNumber, ...) {
    I n = nNumber.I;
    if (n < 2) return nNumber;
    N* n1 = _fib(N.I(n - 1)); // can't refer to itself -> use _{name}
    N* n2 = _fib(N.I(n - 2)); // can't refer to itself -> use _{name}
    return N.I(n1.I + n2.I);
  };
  _fib = fib; // can't refer to itself -> use _{name}
  
  _MemoizedBlock fastFib = _.memoize(fib, /* MANDATORY */ nil);
  self.equal(fib(N.I(10)), N.I(55), @"a memoized version of fibonacci produces identical results");
  self.equal(fastFib(N.I(10), /* MANDATORY */ nil), N.I(55), @"a memoized version of fibonacci produces identical results");

  _MemoizeBlock o = ^(NSS* str, ...) {
    return str;
  };
  _MemoizedBlock fastO = _.memoize(o, /* MANDATORY */ nil);
  self.equal(o(@"toString"), @"toString", @"checks hasOwnProperty");
  self.equal(fastO(@"toString", /* MANDATORY */ nil), @"toString", @"checks hasOwnProperty");
}

- (void)test_delay 
{
  self.asyncTestExpected(N.I(2), ^(QUnitTest* test) {
    __block B delayed = false;
    _.delay(^(){ delayed = true; }, 100);
    SS.setTimeout(^(){ self.self.ok(!delayed, @"didn't delay the function quite yet"); }, 50);
    SS.setTimeout(^(){ self.self.ok(delayed, @"delayed the function"); test.start(); }, 150);
    
    return N.I(2);
  });
}

- (void)test_defer 
{
  self.asyncTest(^(QUnitTest* test) {
    __block B deferred = false;
//    _.defer(^(B value){ deferred = value; }, true);
    _.defer(^(){ deferred = true; });
    _.delay(^(){ self.self.ok(deferred, @"deferred the function"); test.start(); }, 50);
  });
}

- (void)test_throttle 
{
  self.asyncTest(^(QUnitTest* test) {
    __block I counter = 0;
    _ThrottleBlock incr = ^id(id arg1, /* MANDATORY */ ...){ counter++; /* MANDATORY */ return nil; };
    _ThrottledBlock throttledIncr = _.throttle(incr, 100, /* MANDATORY */ nil );  // TODO: rename BLOCK?
    throttledIncr(); throttledIncr(); throttledIncr();
    SS.setTimeout(^{ throttledIncr(); }, 70);
    SS.setTimeout(^{ throttledIncr(); }, 120);
    SS.setTimeout(^{ throttledIncr(); }, 140);
    SS.setTimeout(^{ throttledIncr(); }, 190);
    SS.setTimeout(^{ throttledIncr(); }, 220);
    SS.setTimeout(^{ throttledIncr(); }, 240);
    _.delay(^(){ 
      self.equalI(counter, 1, @"incr was called immediately"); 
    }, 30);
    _.delay(^(){ self.equalI(counter, 4, @"incr was throttled"); test.start(); }, 400);
  });
}

- (void)test_throttle_arguments 
{
  self.asyncTest(^(QUnitTest* test) {
    __block N* value = nil;
    _ThrottleBlock update = ^id(N* val, /* MANDATORY */ ...){ value = val; /* MANDATORY */ return nil; };
    _ThrottledBlock throttledUpdate = _.throttle(update, 100, /* MANDATORY */ nil );
    throttledUpdate(N.I(1), nil); throttledUpdate(N.I(2), nil); throttledUpdate(N.I(3), nil);
    SS.setTimeout(^(){ throttledUpdate(N.I(4)); }, 120);
    SS.setTimeout(^(){ throttledUpdate(N.I(5)); }, 140);
    SS.setTimeout(^(){ throttledUpdate(N.I(6)); }, 250);
    _.delay(^(){ self.equal(value, N.I(1), @"updated to latest value"); }, 40);
    _.delay(^(){ self.equal(value, N.I(6), @"updated to latest value"); test.start(); }, 400);
  });
}

- (void)test_throttle_once
{
  self.asyncTest(^(QUnitTest* test) {
    __block I counter = 0;
    _ThrottleBlock incr = ^N*(id arg1, /* MANDATORY */ ...){ return N.I(++counter); };
    _ThrottledBlock throttledIncr = _.throttle(incr, 100, /* MANDATORY */ nil );
    N* result = throttledIncr();
    _.delay(^(){
      self.equalI(result.I, 1, @"throttled ^s return their value");
      self.equalI(counter, 1, @"incr was called once"); test.start();
    }, 220);
  });
}

- (void)test_throttle_twice
{
  self.asyncTest(^(QUnitTest* test) {
    __block I  counter = 0;
    _ThrottleBlock incr = ^id(id arg1, /* MANDATORY */ ...){ counter++; /* MANDATORY */ return nil; };
    _ThrottledBlock throttledIncr = _.throttle(incr, 100, /* MANDATORY */ nil);
    throttledIncr(); throttledIncr();
    _.delay(^(){ self.equalI(counter, 2, @"incr was called twice"); test.start(); }, 220);
  });
}

- (void)test_throttle_debounce
{
  self.asyncTest(^(QUnitTest* test) {
    __block I  counter = 0;
    _DebounceBlock incr = ^(id arg1, /* MANDATORY */ ...){ counter++; };
    _DebouncedBlock debouncedIncr = _.debounce(incr, 50, /* MANDATORY */ false, /* NIL TERMINATED */ nil);
    debouncedIncr(); debouncedIncr(); debouncedIncr();
    SS.setTimeout(^{ debouncedIncr(); }, 30);
    SS.setTimeout(^{ debouncedIncr(); }, 60);
    SS.setTimeout(^{ debouncedIncr(); }, 90);
    SS.setTimeout(^{ debouncedIncr(); }, 120);
    SS.setTimeout(^{ debouncedIncr(); }, 150);
    _.delay(^(){ self.equalI(counter, 1, @"incr was debounced"); test.start(); }, 220);
  });
}

- (void)test_throttle_asap
{
  self.asyncTest(^(QUnitTest* test) {
    __block I counter = 0;
    _DebounceBlock incr = ^(id arg1, /* MANDATORY */ ...){ 
      counter++; 
    };
    _DebouncedBlock debouncedIncr = _.debounce(incr, 50, true, /* NIL TERMINATED */ nil);
    debouncedIncr(); debouncedIncr(); debouncedIncr();
    self.equalI(counter, 1, @"incr was called immediately");
    SS.setTimeout(^{ debouncedIncr(); }, 30);
    SS.setTimeout(^{ debouncedIncr(); }, 60);
    SS.setTimeout(^{ debouncedIncr(); }, 90);
    SS.setTimeout(^{ debouncedIncr(); }, 120);
    SS.setTimeout(^{ debouncedIncr(); }, 150);
    _.delay(^(){ self.equalI(counter, 1, @"incr was debounced"); test.start(); }, 220);
  });
}

- (void)test_throttle_asap_recursively
{
  self.asyncTest(^(QUnitTest* test) {
    __block I counter = 0;
    __block _DebouncedBlock _debouncedIncr = nil;
    _DebouncedBlock debouncedIncr = _.debounce(^(id arg1, /* MANDATORY */ ...){
      counter++;
      if (counter < 5) _debouncedIncr(); // can't refer to itself -> use _{name}
    }, 50, true, /* NIL TERMINATED */ nil);
    _debouncedIncr = debouncedIncr; // can't refer to itself -> use _{name}
    debouncedIncr();
    self.equalI(counter, 1, @"incr was called immediately");
    _.delay(^(){ self.equalI(counter, 1, @"incr was debounced"); test.start(); }, 70);
  });
}

- (void)test_once {
  __block I num = 0;
  _OncedBlock increment = _.once(^id(/* MANDATORY */ id arg1, ...){ num++; /* MANDATORY */ return nil; }, /* NIL TERMINATED */ nil);
  increment();
  increment();
  self.equalI(num, 1, @"once");
}

- (void)test_wrap {
  _WrappedBlock greet = ^S*(NSS* name, /* MANDATORY */ ...){ return @"hi: ".add(name); };
  _WrappedBlock backwards = _.wrap(greet, ^S*(_WrappedBlock func, NSS* name, /* MANDATORY */ ...){ 
    return ((S*)func(name)).append(@" ").append(name.split(@"").reverse().join(@"")); 
  });
  self.equal(backwards(@"moe", /* MANDATORY */ nil), @"hi: moe eom", @"wrapped the saluation function");

  _WrappedBlock inner = ^(/* MANDATORY */ id arg1, ...){ return @"Hello "; };
  O* obj   = OKV({@"name", @"Moe"});
  obj.set(@"hi", _.wrap(inner, ^(_WrappedBlock fn, /* MANDATORY */ id arg1, ...){ return ((S*)fn(nil)).add((NSS*)obj.get(@"name")); /* REMOVED 'this' CONTEXT */ })); 
  self.equal(((_WrappedBlock)obj.get(@"hi"))(/* NIL TERMINATED */ nil), @"Hello Moe", @"wrapped in property");

  _WrappedBlock noop    = ^id(/* MANDATORY */ id arg1, ...){ 
    return NSNull.null; 
  };
  _WrappedBlock wrapped = _.wrap(noop, ^A*(_WrappedBlock fn, /* MANDATORY */ id arg1, ...){ ARGS_AO(arguments, arg1); return A.newNSO(fn).concat(arguments); });
  A* ret     = wrapped(AO(@"whats", @"your"), @"vector", @"victor", /* MANDATORY */ nil);
  self.deepEqual(ret, AO(noop, AO(@"whats", @"your"), @"vector", @"victor"), @"deep wrapping");
}

- (void)test_compose {
  _ComposeBlock greet = ^S*(NSS* name, /* MANDATORY */ ...){ return @"hi: ".add(name); };
  _ComposeBlock exclaim = ^S*(NSS* sentence, /* MANDATORY */ ...){ return sentence.add(@"!"); };
  _ComposeBlock composed = _.compose(exclaim, greet, /* NIL TERMINATION */ nil);
  self.equal(composed(@"moe"), @"hi: moe!", @"can compose a function that takes another");

  composed = _.compose(greet, exclaim, /* MANDATORY */ nil);
  self.equal(composed(@"moe"), @"hi: moe!", @"in this case, the functions are also commutative");
}

- (void)test_after {
  _AfterBlock testAfter = ^(N* afterAmount, ...) {
    ARG_N(timesCalled, afterAmount); 
    __block N* afterCalled = N.I(0);
    _AfterBlock after = _.after(afterAmount.I, ^(id arg1, ...) {
      afterCalled = N.I(afterCalled.I+1);
      return (id) nil;
    }, /* NIL TERMINATION */ nil); 
    while (timesCalled.I) {
      after(/* NIL TERMINATED*/ nil);
      timesCalled = N.I(timesCalled.I-1);
    }
    return afterCalled;
  };

  self.equal(testAfter(N.I(5), N.I(5)), N.I(1), @"after(N) should fire after being called N times");
  self.equal(testAfter(N.I(5), N.I(4)), N.I(0), @"after(N) should not fire unless called N times");
  self.equal(testAfter(N.I(0), N.I(0)), N.I(1), @"after(0) should fire immediately");
}

@end
