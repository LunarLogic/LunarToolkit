// -------------------------------------------------------
// LLAccount.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#if defined(LUNAR_TOOLKIT_ENABLE_MODELS) && defined(LUNAR_TOOLKIT_ENABLE_SECURITY)

#import "LLAccount.h"

@implementation LLAccount

@synthesize username, password;
LLReleaseOnDealloc(username, password);

+ (NSArray *) propertyList {
  return LLArray(@"username", @"password");
}

+ (NSArray *) propertiesSavedInSettings {
  return [self propertyList];
}

+ (BOOL) isPropertySavedSecurely: (NSString *) property {
  return ([property isEqual: @"password"]);
}

+ (NSString *) settingNameForProperty: (NSString *) property {
  return LLFormat(@"account.%@", property);
}

+ (id) accountFromSettings {
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

  LLAccount *newAccount = [[self alloc] init];
  newAccount.username = [settings objectForKey: [self settingNameForProperty: @"username"]];

  if (newAccount.username) {
    for (NSString *property in [self propertiesSavedInSettings]) {
      NSString *value;
      NSString *settingsKey = [self settingNameForProperty: property];

      if ([self isPropertySavedSecurely: property]) {
        value = [settings llPasswordForKey: settingsKey andUsername: newAccount.username];
      } else {
        value = [settings objectForKey: settingsKey];
      }

      [newAccount setValue: value forKey: property];
    }
  }

  if ([newAccount hasAllRequiredProperties]) {
    return [newAccount autorelease];
  } else {
    [newAccount release];
    return nil;
  }
}

- (BOOL) hasAllRequiredProperties {
  for (NSString *property in [[self class] propertiesSavedInSettings]) {
    NSString *value = [self valueForKey: property];
    if (LLIsBlank(value)) {
      return NO;
    }
  }

  return YES;
}

- (void) save {
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

  for (NSString *property in [[self class] propertiesSavedInSettings]) {
    NSString *settingsKey = [[self class] settingNameForProperty: property];
    NSString *value = [self valueForKey: property];

    if ([[self class] isPropertySavedSecurely: property]) {
      [settings llSetPassword: value forKey: settingsKey andUsername: username];
    } else {
      if (value) {
        [settings setObject: value forKey: settingsKey];
      } else {
        [settings removeObjectForKey: settingsKey];
      }
    }
  }

  [settings synchronize];
}

- (void) clear {
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  NSString *oldUsername = [username retain];

  for (NSString *property in [[self class] propertiesSavedInSettings]) {
    NSString *settingsKey = [[self class] settingNameForProperty: property];

    if ([[self class] isPropertySavedSecurely: property]) {
      [settings llSetPassword: nil forKey: settingsKey andUsername: oldUsername];
    } else {
      [settings removeObjectForKey: settingsKey];
    }

    [self setValue: nil forKey: property];
  }

  [oldUsername release];
  [settings synchronize];
}

@end

#endif
