// -------------------------------------------------------
// PSRestRouter.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#if defined(LUNAR_TOOLKIT_ENABLE_NETWORK) && defined(LUNAR_TOOLKIT_ENABLE_MODELS)

#import "PSModel.h"
#import "PSRestRouter.h"

@implementation PSRestRouter

- (NSString *) pathForModel: (Class) model {
  return PSFormat(@"/%@", [model routeName]);
}

- (NSString *) pathForObject: (PSModel *) object {
  return PSFormat(@"/%@/%@", [[object class] routeName], [object toParam]);
}

@end

#endif
