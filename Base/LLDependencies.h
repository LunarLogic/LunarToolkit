// -------------------------------------------------------
// LLDependencies.h
//
// Copyright (c) 2011 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#define LUNAR_TOOLKIT_ENABLE_MODELS_JSON

#if defined(LUNAR_TOOLKIT_USE_YAJL)
  #import <YAJL/YAJL.h>
#elif defined(LUNAR_TOOLKIT_USE_JSON_FRAMEWORK)
  #import "JSON.h"
#elif defined(LUNAR_TOOLKIT_USE_TOUCHJSON)
  #import "CJSONDeserializer.h"
#elif defined(LUNAR_TOOLKIT_USE_JSONKIT)
  #import "JSONKit.h"
#else
  #undef LUNAR_TOOLKIT_ENABLE_MODELS_JSON
#endif
