// -------------------------------------------------------
// LLRestRouter.h
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

/*
  Implementation of LLRouter that uses REST-style routing (e.g. /articles/1 for Article record with id 1).
  Used internally by LLConnector in CRUD-style methods.
*/

#import <Foundation/Foundation.h>
#import "LLRouter.h"

@interface LLRestRouter : NSObject <LLRouter> {}

@end
