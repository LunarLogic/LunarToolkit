// -------------------------------------------------------
// LLConnectorAccount.h
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

/*
  Defines the minimum requirements for a class to be used as an account in LLConnector for HTTP authentication.
*/

@protocol LLConnectorAccount <NSObject>

- (NSString *) username;
- (NSString *) password;

@end
