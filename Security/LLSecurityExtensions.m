// -------------------------------------------------------
// LLSecurityExtensions.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#ifdef LUNAR_TOOLKIT_ENABLE_SECURITY

#if TARGET_OS_IPHONE
  #import "SFHFKeychainUtils.h"
#else
  #import "SDKeychain.h"
#endif

@interface NSUserDefaults (LunarToolkitPrivate)
- (NSString *) llKeychainServiceNameForKey: (NSString *) key;
@end

@implementation NSUserDefaults (LunarToolkitPrivate)

- (NSString *) llKeychainServiceNameForKey: (NSString *) key {
  return LLFormat(@"%@/%@", [[NSBundle mainBundle] bundleIdentifier], key);
}

@end

@implementation NSUserDefaults (LunarToolkit)

- (NSString *) llPasswordForKey: (NSString *) key andUsername: (NSString *) username {
  if (username) {
    #if TARGET_OS_IPHONE
      NSError *error;
      NSString *serviceName = [self llKeychainServiceNameForKey: key];
      return [SFHFKeychainUtils getPasswordForUsername: username andServiceName: serviceName error: &error];
    #else
      return [SDKeychain securePasswordForIdentifier: username];
    #endif
  } else {
    return nil;
  }
}

- (void) llSetPassword: (NSString *) password forKey: (NSString *) key andUsername: (NSString *) username {
  #if TARGET_OS_IPHONE
    NSError *error;
    NSString *serviceName = [self llKeychainServiceNameForKey: key];
    if (password) {
      [SFHFKeychainUtils storeUsername: username
                           andPassword: password
                        forServiceName: serviceName
                        updateExisting: YES
                                 error: &error];
    } else {
      [SFHFKeychainUtils deleteItemForUsername: username
                                andServiceName: serviceName
                                         error: &error];
    }
  #else
    [SDKeychain setSecurePassword: password forIdentifier: username];
  #endif
}

@end

#endif
