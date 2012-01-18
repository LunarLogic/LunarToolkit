// -------------------------------------------------------
// LLMacros.h
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#define LLArray(...)      [NSArray arrayWithObjects: __VA_ARGS__, nil]
#define LLBool(...)       [NSNumber numberWithBool: __VA_ARGS__]
#define LLFloat(i)        [NSNumber numberWithFloat: i]
#define LLFormat(...)     [NSString stringWithFormat: __VA_ARGS__]
#define LLHash(...)       [NSDictionary llDictionaryWithKeysAndObjects: __VA_ARGS__, nil]
#define LLInt(i)          [NSNumber numberWithInteger: i]
#define LLIndex(sec, row) [NSIndexPath indexPathForRow: row inSection: sec]
#define LLNull            [NSNull null]

#define LLTranslate(text) NSLocalizedString(text, @"")
#define LLIsBlank(x)      (![(x) llIsPresent])
#define LLiPadDevice      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define LLiPhoneDevice    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define LLAbstractMethod(returnType) { [self doesNotRecognizeSelector: _cmd]; return (returnType) 0; }

// from http://www.cimgf.com/2009/01/24/dropping-nslog-in-release-builds/
#ifdef DEBUG
  #define LLLog(...) NSLog(__VA_ARGS__)
#else
  #define LLLog(...) do {} while (0)
#endif

#define LLObserve(sender, notification, callback) \
  [[NSNotificationCenter defaultCenter] addObserver: self \
                                           selector: @selector(callback) \
                                               name: (notification) \
                                             object: (sender)]

#define LLStopObserving(sender, notification) \
  [[NSNotificationCenter defaultCenter] removeObserver: self \
                                                  name: (notification) \
                                                object: (sender)]

#define LLStopObservingAll() [[NSNotificationCenter defaultCenter] removeObserver: self]

#define LLNotifyWithData(notification, data) \
  [[NSNotificationCenter defaultCenter] postNotificationName: (notification) \
                                                      object: self \
                                                    userInfo: (data)]

#define LLNotify(notification) LLNotifyWithData((notification), nil)

#define LLRelease(...) \
  NSArray *_releaseList = [[NSArray alloc] initWithObjects: __VA_ARGS__, nil]; \
  for (NSObject *object in _releaseList) { \
    [object release]; \
  } \
  [_releaseList release];

// best used right below "@synthesize" line
#define LLReleaseOnDealloc(...) \
  - (void) dealloc { \
    LLRelease(__VA_ARGS__); \
    [super dealloc]; \
  }

// synthesize + LLModel's propertyList
#define LLModelProperties(...) \
  @synthesize __VA_ARGS__;  \
  + (NSArray *) propertyList { \
    static NSArray *list = nil; \
    if (!list) { \
      NSArray *superlist = [super propertyList]; \
      NSArray *mylist = [[@#__VA_ARGS__ componentsSeparatedByString: @","] llArrayByCalling: @selector(llTrimmedString)]; \
      list = [[superlist arrayByAddingObjectsFromArray: mylist] retain]; \
    } \
    return list; \
  }
