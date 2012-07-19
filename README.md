[![Build Status](https:secure.travis-ci.org/kmalakoff/_.m.png)](http:travis-ci.org/kmalakoff/_.m)

````
_.m
````
_.m is a port of Underscore.js to Objective-C


Global Changes
------------
NSObject -> integers, bools are NSNumbers -> use N* and N.i, N.b, etc when iterating and IA, etc for arrays
null -> nil
'' and "" to @""
_> _O({k, v}, {k, v}) syntax

Arrays
------------

first
_.first = _.head = _.take = function(array, n, guard)
+ (id(^)(A* array, N* n))first;
Changes: 
-> optional parameter not possible. Use: _NoneInt or nil?? // TODO: decide on the default version -> mappable or not?

initial
_.initial = function(array, n, guard)
+ (NSArray*(^)(A* array, N* n))initial;

last
_.last = function(array, n, guard)
+ (id (^)(A* array, N* n))last;

rest
_.rest = _.tail = function(array, index, guard)
+ (NSArray*(^)(A* array, N* index))rest;

compact
_.compact = function(array)
+ (NSArray*(^)(A* array))compact;

flatten
_.flatten = function(array, shallow)
+ (NSArray*(^)(A* array, N* shallow))flatten;
// CHANGE: shallow is mandatory or should have two versions? (N* used for compatiblity with map not as an index)

without
_.without = function(array, ...)
+ (NSArray*(^)(A* array, id value1, ...))without;

union
_.union = function(...)
+ (NSArray*(^)(A* array1, ...))union;

intersection
_.intersection = function(...)
+ (NSArray*(^)(A* array1, ...))intersection;

difference
_.difference = function(array)
+ (NSArray*(^)(A* array, A* array1, ...))difference;

uniq
_.uniq = _.unique = function(array, isSorted, iterator)
+ (id (^)(A* array, array, B isSorted, _MapBlock iterator))uniq;

zip
_.zip = function(...)
+ (NSArray*(^)(A* array1, A* array2, ...))zip;

indexOf
_.indexOf = function(array, item, isSorted)
+ (NSInteger (^)(A* array, id value, B isSorted))indexOf;

lastIndexOf
_.lastIndexOf = function(array, item)
+ (NSInteger (^)(A* array, id value))lastIndexOf;

range
_.range = function(start, stop, step)
+ (NSInteger (^)(NSInteger start, NSInteger stop, NSInteger step))range;

Chaining
------------

chain
value

Collections
------------

each
  var each = _.each = _.forEach = function(obj, iterator, context)
+ (void(^)(id obj, _IteratorBlock block))each;
+ (void(^)(id obj, _IteratorWithContextBlock block, id context))eachWithContext; // CHANGE

map
_.map = _.collect = function(obj, iterator, context)
+ (id(^)(id obj, _MapBlock block))map;
+ (id(^)(id obj, _MapWithContextBlock block, id context))mapWithContext; // CHANGE

reduce
reduceRight
find
filter
reject
all
any
include
invoke
pluck
max
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

