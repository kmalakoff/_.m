[![Build Status](https:secure.travis-ci.org/kmalakoff/_.m.png)](http:travis-ci.org/kmalakoff/_.m)

````
_.m
````
_.m is a port of Underscore.js to Objective-C


Global Changes
------------
NSObject -> integers, bools are NSNumbers -> use N* and N.I, N.B, etc when iterating and AI, etc for arrays
null -> nil
'' and "" to @""
_> OKV({k, v}, {k, v}) syntax
-> terminators and ignorers AO_, AF_ and _FNone
-> removed all context
explain the reason for and use of KH
variable length: add nil termination requirement -> look for /* NIL_TERMINATION */ in the function definition or test
no context 'this'
how to use _ARGS_KEY and ARGS_AO, etc

Other Changes
------------
_() 
_Wrapper* __(id); -> two underscores

Arrays
------------

first
_.first = _.head = _.take = function(array, n, guard)
+ (id(^)(A* array, I n))first;  // mandatory second parameter: -1 replaces missing paramter
+ (id(^)(A* array, ... /* KEY, COLLECTION */))firstIterator; // CHANGE 


initial
_.initial = function(array, n, guard)
+ (A*(^)(A* array, I n))initial; // mandatory second parameter: -1 replaces missing paramter
+ (A*(^)(A* array, ... /* KEY, COLLECTION */))initialIterator; // CHANGE

last
_.last = function(array, n, guard)
+ (id(^)(A* array, I n))last; // mandatory second parameter: -1 replaces missing paramter
+ (A*(^)(A* array, ... /* KEY, COLLECTION */))lastIterator; // CHANGE

rest
_.rest = _.tail = function(array, index, guard)
+ (A*(^)(A* array, I index))rest; // mandatory second parameter: -1 replaces missing paramter
+ (A*(^)(A* array, ... /* KEY, COLLECTION */))restIterator; // CHANGE

compact
_.compact = function(array)
+ (A*(^)(A* array))compact;

flatten
_.flatten = function(array, shallow)
+ (A*(^)(A* array, BOOL shallow))flatten;
// CHANGE: shallow is mandatory or should have two versions? (N* used for compatiblity with map not as an index)

without
_.without = function(array, ...)
+ (A*(^)(A* array, id value1, ... /* NIL_TERMINATED*/))without;

union
_.union = function(...)
+ (A*(^)(A* array, ... /* NIL_TERMINATED*/))union;

intersection
_.intersection = function(...)
+ (A*(^)(A* array, ... /* NIL_TERMINATED*/))intersection;

difference
_.difference = function(array)
+ (A*(^)(A* array, A* array1, ... /* NIL_TERMINATED*/))difference;

uniq
_.uniq = _.unique = function(array, isSorted, iterator)
+ (id(^)(A* array, array))uniq;
+ (id(^)(A* array, array, B isSorted, _MapBlock iterator))uniq3;

zip
_.zip = function(...)
+ (A*(^)(A* array, A* array1, ... /* NIL_TERMINATED*/))zip;

_.zipObject = function(keys, values)
+ (O*(^)(NSA* keys, NSA* values))zipObject //ADDED

indexOf
_.indexOf = function(array, item, isSorted)
+ (I (^)(A* array, id value, B isSorted))indexOf;
+ (I(^)(NSA* array, id value))indexOf; // CHANGE: specialized sorted method -> TODO: check others with sorting
+ (I(^)(NSA* array, id value))indexOfSorted;

lastIndexOf
_.lastIndexOf = function(array, item)
+ (I (^)(A* array, id value))lastIndexOf;

range
_.range = function(start, stop, step)
+ (I (^)(I start, I stop, I step))range;

Chaining
------------

chain
value

Collections
------------

each
  var each = _.each = _.forEach = function(obj, iterator, context)
+ (void(^)(id obj, _EachBlock iterator))each;
CHANGE: no collection (was used for guard, but removed due to variable arguments not possible). Context is a JS language feature

map
_.map = _.collect = function(obj, iterator, context)
+ (id(^)(id obj, _MapBlock iterator))map;
CHANGE: no collection (was used for guard, but removed due to variable arguments not possible). Context is a JS language feature

reduce
reduceRight
find

filter
  _.filter = _.select = function(obj, iterator, context) {
+ (A*(^)(id obj, _CollectionItemTestBlock iterator))filter;
CHANGE: Context is a JS language feature

reject
all
any

include



invoke
pluck

max
CHANGE: Context is a JS language feature

min
sortBy
groupBy
sortedIndex
shuffle
toArray
size


Functions
------------

bind
bindAll
memoize
delay
defer
throttle
debounce
once
after
wrap
compose

Objects
------------

keys
values
functions
extend
pick
defaults
clone
tap
has
isEqual
isEmpty
isElement

isArray
_.isArray = function(obj)
+ (B(^)(id obj))isArray;

isObject
_.isObject = function(obj)
+ (B(^)(id obj))isObject;

isArguments
isFunction
isString
isNumber
isFinite
isBoolean
isDate
_.isDate = function(obj)
+ (B(^)(id obj))isDate;

isRegExp
isNaN

isNull
_.isNull = function(obj)
+ (B(^)(id obj))isNull;

isUndefined

// ADDED
+ (B(^)(id obj))isDictionary
+ (B(^)(id obj))isTruthy
+ (B(^)(id obj))isFalsy

Utility
------------

noConflict
identity
times
mixin
uniqueId
escape
result
template


Arguments
------------
Added new category


***************
SS:

delete obj.key or delete obj['key'] -> obj.delete_(@"key") -> what is the delete resevered word for..can it be used?