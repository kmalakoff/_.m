````
SubjectiveScript.m
````
Subjective-Script makes Objective-C more scripty!

**Note:** Subjective-Script requires ARC to be enabled on your Objective-C project.

The Idea
========

My language of preference is CoffeeScript and whenever I develop in Objective-C, I find myself often having to look up [NSSomething reallyLongFunctionName:YES withAVerboseParameterName:YES and:[NSSomethingElse whichAddsMoreBrackets]] and it isn't very enjoyable or speedy!

While I was porting a test for [_.m](https://github.com/kmalakoff/_.m) from the original [Underscore.js](http://underscorejs.org/) that was easy to read:

```JavaScript
var people = [{name : 'curly', age : 50}, {name : 'moe', age : 30}];
people = _.sortBy(people, function(person){ return person.age; });
equal(_.pluck(people, 'name').join(', '), 'moe, curly', 'stooges sorted by age');
```

It looked like this in Objective-C:

```
NSArray *people = [NSArray arrayWithObjects:
  [NSDictionary dictionaryWithObjectsAndKeys: @"moe", @"name", [NSNumber numberWithInt:30], @"age", nil],
  [NSDictionary dictionaryWithObjectsAndKeys: @"curly", @"name", [NSNumber numberWithInt:50], @"age", nil],
  nil];

STAssertEqualObjects([_.pluck(people, @"name") componentsJoinedByString:@", "],
                     @"moe, curly",
                     @"stooges sorted by age");
```

The keys were in the wrong order, there was too much typing involved, and it became unreadable. So I wrote [Subjective-Script](https://github.com/kmalakoff/SubjectiveScript.m) and ported [QUnit.m](https://github.com/kmalakoff/QUnit.m) to end up with this:

```
A* people = AO(OKV({@"name", @"curly"}, {@"age", N.I(50)}), OKV({@"name", @"moe"}, {@"age", N.I(30)}));
people = _.sortBy(people, ^(O* person){ return person.get(@"age"); });
equal(_.pluck(people, @"name").join(@", "), @"moe, curly", @"stooges sorted by age");
```

Much better! And best of all, I can reuse my knowledge of JavaScript for function names so I can stop looking things up and get stuff done!

The Syntax
==========

Types
-----
While JavaScript allows flexibility in variable types, Objective-C requires explicit variable types. To try to keep it brief, I tried to condense types down to the shortest name possible:

```
typedef BOOL            B;
typedef NSInteger       I;
typedef NSUInteger      UI;
typedef float           F;
typedef double          D;
typedef id              KV[2]; // key-value pair

#define NSO             NSObject
#define A               NSMutableArray
#define NSA             NSArray
#define O               NSMutableDictionary
#define NSD             NSDictionary
#define S               NSMutableString
#define NSS             NSString
#define Date            NSDate
#define N               NSNumber
#define E               NSException
```

and I tried to shorten NSNumbers, too, using the above abbreviations (B, I, UI, F, D):

```
N* value = N.B(true);
equal(value.B, true, @"YES it is!")
```

Using Aggregate Types
-----
I tried many different ways, but this seemed to be easy-to-read and brief (with key-value pair matching checked by the compiler):

```
A* arrayOfInts = AI(1, 2, 3);
A* arrayOfObjects = AO(N.I(1), N.F(2.0), @"hello", nil, O.new);
I intValue = arrayOfInts.getAt(0).I;    // or: intValue = arrayOfInts.get(@"1").I;
arrayOfInts.setAt(0, N.I(intValue+1));  // or: arrayOfInts.set(@"1", N.I(intValue+1));

O* obj = OKV({@"int", N.I(1)}, {@"float", N.F(2.0)}, {@"string", @"hello"}, {@"nil", nil}, {@"dictionary", O.new});
intValue = obj.get(@"int").I;
obj.set(@"int", N.I(intValue+1));
```

would be equivalent to the following Javascript:

```
var arrayOfInts = [1, 2, 3];
var arrayOfObjects = [1, 2.0, 'hello', null, {}];
var intValue = arrayOfInts[0];
arrayOfInts[0] = intValue+1;

var obj = {int: 1, float: 2.0, string: 'hello', nil: null, dictionary:{}};
intValue = obj.int;       // or: intValue = obj['int'];
obj.int = intValue+1;     // or: obj['int'] = intValue+1;
```

and if you are interested, Objective-C may make the syntax even lighter using [Objective-C literals](http://clang.llvm.org/docs/ObjectiveCLiterals.html) in the future:

```
NSA* arrayOfInts = @[@1, @2, @3];
NSA* arrayOfObjects = @[@1, @2.0, @"hello", NSNull.null, @{}];
NSD* obj = @{@int: @1, @float: @2.0, @string: @"hello", @nil: NSNull.null, @dictionary:@{}};
```

The JavaScript-Inspired Library
==========

To be able to reuse my JavaScript knowledge and not have to look through StackOverflow for really basic things that are hard to remember in Objective-C, I've ported some common JavaScript functions.


All Objects
-------

```
N.I(1).instanceof(N.class);
// true

(A.new).instanceof(NSA.class);
// true

N.B(true).toString();
// @"true"

OKV({@"key1", @"value1"}).toString();
// @"[object Object]"

AO(AI(1,2,3),N.F(4.5),OKV({@"five", @"5"})).toString();
// @"[[1,2,3],4.5,[object Object]]
```

Arrays
--------

```
AI(1,2,3).length;
// 3

AI(1,2,3).hasOwnProperty(@"2");
// true

AI(1,2,3).get(@"2");
// N.I(3)

AI(1,2,3).concat(AI(1,2,4);
// [1,2,3,1,2,4]

AO(@"Banana", @"Orange", @"Lemon", @"Apple", @"Mango").slice(-3,-1);
// [Lemon,Apple]

AI(1,2,3).reverse();
// [3,2,1]

AO(N.I(1),AI(2,3)).flatten(true);
// [1,2,3]

AI(1,2,3).pop();
// N.I(3)

AI(1,2,3).push(N.I(4)).push(@"out the door");
// [1,2,3,4,out the door]

AI(3,2,1,2).sort(nil);
// [1,2,2,3]

AO(@"Banana", @"Orange", @"Apple", @"Lemon").splice(2,1, @"Kiwi", @"Mango", nil);
// [Banana,Orange,Kiwi,Mango,Lemon]

AI(3,4,5).unshift(N.I(1),N.I(2),nil);
// [1,2,3,4,5]

AI(1,2,3,4,5).shift();
// [2,3,4,5]
```

Objects/Dictionaries
--------

```
OKV({@"int", N.I(1)}, {@"float", N.F(2.0)}).hasOwnProperty(@"int");
// true

OKV({@"int", N.I(1)}, {@"float", N.F(2.0)}).delete_(@"int").hasOwnProperty(@"int");
// false

@"int".in(OKV({@"int", N.I(1)}, {@"float", N.F(2.0)}));
// true
```

```
delete obj.key or delete obj['key'] -> obj.delete_(@"key") -> what is the delete resevered word for..can it be used?
```

Strings
--------

```
@"hello world!".split(@" ")
// [@"hello", @"world!"]

@"hello world!".split(@"");
// [@"h", @"e", @"l", @"l", @"o", @"w", @"o", @"r", @"l", @"d", @"!"]

@"hello".add(@"world!");
// @"hello world!"

S* message = S.newS(@"hello"); message.append(@" world!");
// message == @"hello world!"
```

Dates
--------

```
SS.stringify(Date.newYMD_JS(2012, 7, 31));
// @"2012-08-30T15:00:00.000Z"
```

Functions
--------

```
O* obj = OKV({@"mirror", ^(NSS* string){return string.add(@" mirror"); }});
@"mirror".call(obj, @"hello", nil);
// @"hello mirror"

@"mirror".apply(obj, AO(@"hello"));
// @"hello mirror"
```

Utilities
--------

There are a few utilities on the Subjective-Script base object rather than making them global as in JavaScript.

```
SS.stringify(AO(N.I(1), N.F(2.0), N.F(3.1), @"hello", nil, O.new));
// @"[1,2,3.1,\"hello\",null,{}]"

SS.parseInt(@"123");
// N.I(123)

SS.typeof_(N.B(true));
// @"boolean"

SS.typeof_(@"string");
// @"string"

SS.typeof_(Date.new);
// @"object"

__block BOOL called1 = false;
SSTimeout* timeout1 = SS.setTimeout(^{ called1 = true; }, NSEC_PER_SEC*1);
SS.clearTimeout(timeout1);
// not called

__block BOOL called2 = false;
SS.setTimeout(^{ called2 = true; }, NSEC_PER_SEC*2);
// called
```

Just One More Thing
---------------

You can also easily add named properties on your own objects:

```
@interface MyObject : O
  @property (strong) NSS* name;
@end
@implementation MyObject : O
  @dynamic name;
  IMPLEMENT_NAMED_PROPERTIES
@end

MyObject* obj = MyObject.new;
obj.name = @"Steve";
// they call me Steve
```

So you can write the initial example like:
```
@interface Stooge : O
  @property (strong) NSS* name;
  @property (strong) N* age;
@end
@implementation Stooge
  @dynamic name, age;
  IMPLEMENT_NAMED_PROPERTIES
@end

A* people = AO(OTKV(Stooge, {@"name", @"curly"}, {@"age", N.I(50)}), OTKV(Stooge, {@"name", @"moe"}, {@"age", N.I(30)}));
people = _.sortBy(people, ^(Stooge* person){ return person.age; }); // no get(@"age") required
equal(_.pluck(people, @"name").join(@", "), @"moe, curly", @"stooges sorted by age");
```

Please Contribute to SubjectiveScript.m
---------------

Currently, this is still early days and there is a lot to add and test. Please help out!

If there is anything else you would like added, just implement it in a good place, write the appropriate tests, and submit a pull request on [GitHub](https://github.com/kmalakoff/SubjectiveScript.m/pulls).

Also, feel free to submit your favorite features from other languages as long as they are easy to remember and help speed up development!
