// -------------------------------------------------------
// LLModelManager.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#ifdef LUNAR_TOOLKIT_ENABLE_MODELS

#import "LLModelManager.h"

static NSMutableDictionary *managers;

@implementation LLModelManager

@synthesize list, identityMap, propertyList;

- (id) init {
  self = [super init];
  if (self) {
    list = [[NSMutableArray alloc] initWithCapacity: 100];
    identityMap = [[NSMutableDictionary alloc] initWithCapacity: 100];
  }
  return self;
}

+ (void) initialize {
  managers = [[NSMutableDictionary alloc] initWithCapacity: 5];
}

+ (LLModelManager *) managerForClass: (NSString *) className {
  LLModelManager *manager = [managers objectForKey: className];
  if (!manager) {
    manager = [[LLModelManager alloc] init];
    [managers setObject: manager forKey: className];
    [manager release];
  }
  return manager;
}

@end

#endif
