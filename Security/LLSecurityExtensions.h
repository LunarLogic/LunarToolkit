// -------------------------------------------------------
// LLSecurityExtensions.h
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

/*
  These helpers let you set and read a password property securely from the Keychain
  (works for iPhone device, iPhone simulator and on MacOSX).
*/

@interface NSUserDefaults (LunarToolkit)
- (NSString *) llPasswordForKey: (NSString *) key andUsername: (NSString *) username;
- (void) llSetPassword: (NSString *) password forKey: (NSString *) key andUsername: (NSString *) username;
@end
