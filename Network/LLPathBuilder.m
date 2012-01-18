// -------------------------------------------------------
// LLPathBuilder.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#ifdef LUNAR_TOOLKIT_ENABLE_NETWORK

#import "LLPathBuilder.h"

@implementation LLPathBuilder

+ (LLPathBuilder *) builderWithBasePath: (NSString *) path {
  LLPathBuilder *builder = [[LLPathBuilder alloc] initWithBasePath: path];
  return [builder autorelease];
}

- (id) initWithBasePath: (NSString *) path {
  self = [super init];
  if (self) {
    fullPath = [[NSMutableString alloc] initWithString: path];
    hasParams = [fullPath llContainsString: @"?"];
  }
  return self;
}

- (void) addParameterWithName: (NSString *) name value: (id) value {
  [fullPath appendString: (hasParams ? @"&" : @"?")];
  [fullPath appendString: LLFormat(@"%@=%@", name, [value description])];
  hasParams = YES;
}

- (void) addParameterWithName: (NSString *) name integerValue: (NSInteger) value {
  [self addParameterWithName: name value: LLInt(value)];
}

- (NSString *) path {
  return fullPath;
}

@end

#endif
