//
//  SS-System.h
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/22/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
// Technique from http://stackoverflow.com/questions/3339722/check-iphone-ios-version
//

#import "SS+System.h"
#import "NSString+Versioning.h"

#include "TargetConditionals.h"
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

@implementation SS (System)

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (NSS*)systemVersion { return [[UIDevice currentDevice] systemVersion]; }
#elif TARGET_OS_MAC
+ (NSS*)systemVersion {
 SInt32 versionMajor = 0;
 SInt32 versionMinor = 0;
 SInt32 versionBugFix = 0;
 Gestalt( gestaltSystemVersionMajor, &versionMajor );
 Gestalt( gestaltSystemVersionMinor, &versionMinor );
 Gestalt( gestaltSystemVersionBugFix, &versionBugFix );
 return [NSString stringWithFormat:@"%d.%d.%d", versionMajor, versionMinor, versionBugFix];
}
#endif

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (B)macSystem { return NO; }
+ (B)iOSSystem { return YES; }
#elif TARGET_OS_MAC
+ (B)macSystem { return YES; }
+ (B)iOSSystem { return NO; }
#endif

+ (A*)_runningTaskList
{
  static NSMutableArray *singleton = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    singleton = A.new;
  });
  return singleton;
}

+ (SSTaskId*(^)(SSTaskIdBlock block, I waitNS, BOOL background))addTask
{
  return ^(SSTaskIdBlock block, I waitNS, BOOL background) {
    SSTaskId* taskId;
    
    @synchronized(self) {
      static I id = 0; id++;
      
      taskId = [NSNumber numberWithInteger:id];
      [[SS _runningTaskList] addObject:taskId];
    }

    dispatch_queue_t dispatchQueue;
    
    if (background) {
      if (SS.iOSSystem && SS.systemVersion.VersionLessThan(@"5.0"))
        dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0UL);
      else
        dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0UL);
    }
    else
      dispatchQueue =  dispatch_get_main_queue();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, waitNS), dispatchQueue, ^{
      @synchronized(self) {
        A* runningList = [SS _runningTaskList];
        UI index = [runningList indexOfObject:taskId];
        if (index == NSNotFound) // not running, exit
          return;
        
        // still running, remove and call
        [runningList removeObjectAtIndex:index];
        block();
     }
    });
    return taskId;
  };
}

+ (void(^)(SSTaskId* taskId))stopTask
{
  return ^(SSTaskId* taskId) {
    if (!taskId) return; // no timeout
    
    @synchronized(self) {
      A* runningList = [SS _runningTaskList];
      UI index = [runningList indexOfObject:taskId];
      if (index == NSNotFound) // not running, exit
        return;
      
      // running, remove from running list
      [runningList removeObjectAtIndex:index];
    }
  };
}

@end
