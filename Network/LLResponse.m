// -------------------------------------------------------
// LLResponse.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#ifdef LUNAR_TOOLKIT_ENABLE_NETWORK

#import "LLRequest.h"
#import "LLResponse.h"

#define DEBUG_RESPONSE_LIMIT 500

@implementation LLResponse

- (id) initWithRequest: (LLRequest *) aRequest {
  self = [super init];
  if (self) {
    request = aRequest;
  }
  return self;
}

- (NSDictionary *) headers {
  return request.responseHeaders;
}

- (NSString *) text {
  return request.responseString;
}

- (NSData *) data {
  return request.responseData;
}

- (NSInteger) status {
  return request.responseStatusCode;
}

- (NSString *) contentType {
  return [[self headers] objectForKey: @"Content-Type"];
}

- (BOOL) hasReadableContentType {
  NSString *contentType = [self contentType];
  return [contentType hasPrefix: @"text/"]
      || [contentType llContainsString: @"javascript"]
      || [contentType llContainsString: @"json"]
      || [contentType llContainsString: @"xml"];
}

- (BOOL) matchesExpectedContentType {
  NSString *actual = self.contentType;
  switch (request.expectedContentType) {
    case LLHTMLResponseType:
      return [actual hasPrefix: @"text/html"] || [actual hasPrefix: @"application/xhtml+xml"];
    case LLImageResponseType:
    case LLImageDataResponseType:
      return [actual hasPrefix: @"image/"];
    case LLJSONResponseType:
      return [actual llContainsString: @"javascript"] || [actual llContainsString: @"json"];
    case LLXMLResponseType:
      return [actual llContainsString: @"/xml"];
    case LLBinaryResponseType:
      return ![self hasReadableContentType];
    case LLAnyResponseType:
      return YES;
    default:
      return NO;
  }
}

- (NSString *) description {
  NSString *message = LLFormat(@"request to %@: status = %d, content type = %@",
                               request.url, self.status, self.contentType);
  if ([self hasReadableContentType] && (self.text.length <= DEBUG_RESPONSE_LIMIT)) {
    message = [message stringByAppendingFormat: @", text = %@", self.text];
  } else {
    message = [message stringByAppendingFormat: @", length = %d", self.text.length];
  }

  return message;
}

@end

#endif
