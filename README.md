````
_.m
````

_.m is a port of [Underscore.js](http://underscorejs.org/) to Objective-C. It strives to provide the fullest feature set possible in a way that is familiar to JavaScript developers (despite the differences between JavaScript and Objective-C).

To help achieve this vision, _.m uses [SubjectiveScript.m](https://github.com/kmalakoff/SubjectiveScript.m) to bring JavaScript-like syntax and features into Objective-C, and [QUnit.m](https://github.com/kmalakoff/QUnit.m) to port unit tests from JavaScript to Objective-C. You should check them out, too!

Full documentation can be found on the [_.m Website](http://http://kmalakoff.github.com/_.m/)

A Quick Taster
------------

You can use familiar Underscore.js functions:

```
N* result = (N*) _.detect(AI(1, 2, 3), ^B(N* num){ return num.I * 2 == 4; });
equal(result.I, 2, @"found the first '2' and broke the loop");
```

and you can even use chaining:

```
A* lyrics = AO(
  @"I'm a lumberjack and I'm okay",
  @"I sleep all night and I work all day",
  @"He's a lumberjack and he's okay",
  @"He sleeps all night and he works all day"
);
O* counts = (O*) __(lyrics)
  .map(^(NSS* line, ...) { return line.split(@""); })
  .flatten(/* REQUIRED */ false )
  .reduce(^(O* hash, N* l, ... /* KEY, LIST */) {
    N* value = (N*) hash.getOrAdd(l, ^{ return N.I(0); });
    hash.set(l, N.I(value.I+1));
    return hash;
}, O.new).value();
ok(counts.get(@"a").I == 16 && counts.get(@"e").I == 10, @"counted all the letters in the song");
```

Installing
---------

#Install From GitHub Source
  + Clone the [_.m from GitHub](https://github.com/kmalakoff/_.m)
  + Add all the files from the Lib directory to your project
  + Clone the [SubjectiveScript.m from GitHub](hhttps://github.com/kmalakoff/SubjectiveScript.m)
  + Add all the files from the Lib directory to your project

#Install From CocoaPods
  + Install [Ruby](http://www.ruby-lang.org/en/downloads/) and [CocoaPods](href='http://cocoapods.org/#install)
  + [Configure a Podfile](href='http://cocoapods.org/#get_started) in the root directory of your XCode project. For example:

```
      platform :ios
      pod '_.m',                  '~> 0.1.1'
      pod 'SubjectiveScript.m',   '~> 0.1.1'
```

  + Install the pods from the Podfile 'pod install {YourProject}.xcodeproj'
  + Use the generated '{YourProject}.xcworkspace' file instead of '{YourProject}.xcodeproj'
