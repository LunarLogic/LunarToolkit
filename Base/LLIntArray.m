// -------------------------------------------------------
// LLIntArray.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#import "LLIntArray.h"
#import "LLMacros.h"

@implementation LLIntArray

@synthesize count;

+ (LLIntArray *) arrayWithIntegers: (NSInteger) first, ... {
  if (first == LLIntArrayStop) {
    return [[[LLIntArray alloc] initWithCapacity: 0] autorelease];
  } else {
    NSMutableArray *nsarray = [[NSMutableArray alloc] init];
    [nsarray addObject: LLInt(first)];
    va_list args;
    va_start(args, first);
    NSInteger next;
    for (;;) {
      next = va_arg(args, NSInteger);
      if (next == LLIntArrayStop) {
        break;
      }
      [nsarray addObject: LLInt(next)];
    }
    va_end(args);

    LLIntArray *array = [[LLIntArray alloc] initWithCapacity: nsarray.count];
    for (NSInteger i = 0; i < nsarray.count; i++) {
      [array setInteger: [[nsarray objectAtIndex: i] intValue] atIndex: i];
    }
    [nsarray release];
    return [array autorelease];
  }
}

+ (LLIntArray *) emptyArray {
  return [LLIntArray arrayWithIntegers: LLIntArrayStop];
}

- (id) initWithCapacity: (NSInteger) capacity {
  self = [super init];
  if (self) {
    values = malloc(sizeof(NSInteger) * capacity);
    count = capacity;
  }
  return self;
}

- (void) setInteger: (NSInteger) value atIndex: (NSInteger) index {
  if (index >= 0 && index < count) {
    values[index] = value;
  } else {
    NSString *reason = LLFormat(@"Index outside range (index = %d, count = %d)", index, count);
    NSException *exception = [NSException exceptionWithName: NSRangeException reason: reason userInfo: nil];
    @throw(exception);
  }
}

- (NSInteger) integerAtIndex: (NSInteger) index {
  if (index >= 0 && index < count) {
    return values[index];
  } else {
    NSString *reason = LLFormat(@"Index outside range (index = %d, count = %d)", index, count);
    NSException *exception = [NSException exceptionWithName: NSRangeException reason: reason userInfo: nil];
    @throw(exception);
  }
}

@end
