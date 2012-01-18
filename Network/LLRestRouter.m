// -------------------------------------------------------
// LLRestRouter.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#if defined(LUNAR_TOOLKIT_ENABLE_NETWORK) && defined(LUNAR_TOOLKIT_ENABLE_MODELS)

#import "LLModel.h"
#import "LLRestRouter.h"

@implementation LLRestRouter

- (NSString *) pathForModel: (Class) model {
  return LLFormat(@"/%@", [model routeName]);
}

- (NSString *) pathForObject: (LLModel *) object {
  return LLFormat(@"/%@/%@", [[object class] routeName], [object toParam]);
}

@end

#endif
