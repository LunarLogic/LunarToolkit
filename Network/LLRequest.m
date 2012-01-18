// -------------------------------------------------------
// LLRequest.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#ifdef LUNAR_TOOLKIT_ENABLE_NETWORK

#import "LLConnectorDelegate.h"
#import "LLRequest.h"
#import "LLResponse.h"

@interface LLRequest ()
- (NSString *) acceptHeaderForContentType: (LLResponseContentType) contentType;
@end

@implementation LLRequest

@synthesize target, callback, expectedContentType, successHandler;
LLReleaseOnDealloc(response, target, pathBuilder);

- (id) initWithURL: (NSString *) aURL connector: (LLConnector *) aConnector {
  self = [super initWithURL: [NSURL URLWithString: aURL]];
  if (self) {
    connector = aConnector;
    successHandler = @selector(handleFinishedRequest:);
    pathBuilder = [[LLPathBuilder alloc] initWithBasePath: aURL];
    self.delegate = aConnector;
  }
  return self;
}

- (void) updatePath {
  [self setURL: [NSURL URLWithString: [pathBuilder path]]];
}

- (void) addURLParameter: (NSString *) param value: (id) value {
  [pathBuilder addParameterWithName: param value: value];
  [self updatePath];
}

- (void) addURLParameter: (NSString *) param integerValue: (NSInteger) value {
  [pathBuilder addParameterWithName: param integerValue: value];
  [self updatePath];
}

- (id) objectForKey: (NSString *) key {
  return [self.userInfo objectForKey: key];
}

- (NSString *) postData {
  return [[[NSString alloc] initWithData: self.postBody encoding: NSUTF8StringEncoding] autorelease];
}

- (void) setPostData: (NSString *) text {
  [self appendPostData: [text dataUsingEncoding: NSUTF8StringEncoding]];
}

- (void) setExpectedContentType: (LLResponseContentType) contentType {
  expectedContentType = contentType;
  [self addRequestHeader: @"Accept" value: [self acceptHeaderForContentType: contentType]];
}

- (NSString *) acceptHeaderForContentType: (LLResponseContentType) contentType {
  switch (contentType) {
    case LLHTMLResponseType:
      return @"text/html,application/xhtml+xml";
    case LLImageResponseType:
    case LLImageDataResponseType:
      return @"image/*";
    case LLJSONResponseType:
      return @"application/json";
    case LLXMLResponseType:
      return @"text/xml";
    case LLAnyResponseType:
    case LLBinaryResponseType:
      return @"*/*";
    default:
      return nil;
  }
}

- (void) sendFor: (id) aTarget callback: (SEL) aCallback {
  self.target = aTarget;
  self.callback = aCallback;
  [self send];
}

- (void) send {
  [self startAsynchronous];
}

- (LLResponse *) response {
  if (!response) {
    response = [[LLResponse alloc] initWithRequest: self];
  }
  return response;
}

- (void) notifyTargetOfSuccess {
  [target performSelector: callback withObject: nil];
}

- (void) notifyTargetOfSuccessWithObject: (id) object {
  [target performSelector: callback withObject: object];
}

- (void) notifyTargetOfError: (NSError *) anError {
  [target requestFailed: self withError: anError];
}

- (void) notifyTargetOfAuthenticationError {
  [target authenticationFailedInRequest: self];
}

@end

#endif
