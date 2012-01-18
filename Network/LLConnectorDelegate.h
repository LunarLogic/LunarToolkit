// -------------------------------------------------------
// LLConnectorDelegate.h
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

/*
  These methods might be called on any object that acts as a LLConnector request target
  (you don't have to explicitly declare the class as implementing the protocol).
*/

@class LLRequest;

@protocol LLConnectorDelegate

- (void) requestFailed: (LLRequest *) request withError: (NSError *) error;
- (void) authenticationFailedInRequest: (LLRequest *) request;

@end
