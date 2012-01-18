// -------------------------------------------------------
// LLRouter.h
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

/*
  Defines the minimum requirements for a class to be used as a routing helper in LLConnector
  (used by the CRUD methods ***RequestForObject). Implemented by LLRestRouter.
*/

#import <Foundation/Foundation.h>

@class LLModel;

@protocol LLRouter <NSObject>

- (NSString *) pathForModel: (Class) model;
- (NSString *) pathForObject: (LLModel *) object;

@end
