[![Build Status](https:secure.travis-ci.org/kmalakoff/_.m.png)](http:travis-ci.org/kmalakoff/_.m)

````
_.m
````
_.m is a port of Underscore.js to Objective-C


Global Changes
------------
NSObject -> integers, bools are NSNumbers -> use N* and N.i, N.b, etc when iterating and Ai1, _IA, etc for arrays
null -> nil
'' and "" to @""


Arrays
------------

first
_.first = _.head = _.take = function(array, n, guard)
+ (id(^)(NSArray *array, NSUInteger n))first;
Changes: 
-> optional parameter not possible. Use: _NoneInt

initial
_.initial = function(array, n, guard)
+ (NSArray *(^)(NSArray *array))initial;

last
_.last = function(array, n, guard)
+ (id (^)(NSArray *array, NSUInteger n))last;

rest
_.rest = _.tail = function(array, index, guard)
+ (NSArray *(^)(NSArray *array, NSUInteger n))rest;

compact
_.compact = function(array)
+ (NSArray *(^)(NSArray *array))compact;

flatten
_.flatten = function(array, shallow)
+ (NSArray *(^)(NSArray *array, BOOL shallow))flatten;

without
_.without = function(array, ...)
+ (NSArray *(^)(NSArray *array, NSArray *values))without;

union
_.union = function(...)
+ (NSArray *(^)(NSArray *arrays))union;

intersection
_.intersection = function(...)
+ (NSArray *(^)(NSArray *arrays))intersection;

difference
_.difference = function(array)
+ (NSArray*(^)(NSArray *array, NSArray *arrays))difference;

uniq
_.uniq = _.unique = function(array, isSorted, iterator)
+ (id (^)(NSArray *array, array, BOOL isSorted, _MapBlock iterator))uniq;

zip
_.zip = function(...)

indexOf
_.indexOf = function(array, item, isSorted)
+ (NSInteger (^)(NSArray *array, id value, BOOL isSorted))indexOf;

lastIndexOf
_.lastIndexOf = function(array, item)
+ (NSInteger (^)(NSArray *array, id value))lastIndexOf;

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
+ (void(^)(id collection, _IteratorBlock block))each;
-> no context

map
_.map = _.collect = function(obj, iterator, context)
+ (id(^)(id collection, _MapBlock block))map;
-> no context

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
+ (BOOL(^)(id obj))isArray;

isObject
_.isObject = function(obj)
+ (BOOL(^)(id obj))isObject;

isArguments
isFunction
isString
isNumber
isFinite
isBoolean
isDate
_.isDate = function(obj)
+ (BOOL(^)(id obj))isDate;

isRegExp
isNaN

isNull
_.isNull = function(obj)
+ (BOOL(^)(id obj))isNull;

isUndefined

// ADDED
+ (BOOL(^)(id obj))isDictionary

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

