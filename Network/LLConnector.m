// -------------------------------------------------------
// LLConnector.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#ifdef LUNAR_TOOLKIT_ENABLE_NETWORK

#import "LLConnector.h"
#import "LLMacros.h"
#import "LLRequest.h"
#import "LLResponse.h"

#ifdef LUNAR_TOOLKIT_ENABLE_MODELS
  #import "LLRestRouter.h"
#endif

#define DEFAULT_REQUEST_TIMEOUT 20.0

#if TARGET_OS_IPHONE
  #define IMAGE_CLASS UIImage
#else
  #define IMAGE_CLASS NSImage
#endif

static LLConnector *sharedConnector = nil;

@interface LLConnector ()
- (NSError *) errorWithCode: (NSInteger) code message: (NSString *) message;
@end

@implementation LLConnector

@synthesize baseURL, userAgent, usesHTTPAuthentication, router, account, loggingEnabled;

+ (id) sharedConnector {
  if (!sharedConnector) {
    sharedConnector = [[LLConnector alloc] init];
  }
  return sharedConnector;
}

+ (void) setSharedConnector: (LLConnector *) connector {
  if (connector != sharedConnector) {
    [sharedConnector release];
    sharedConnector = [connector retain];
  }
}

+ (void) setSharedConnectorClass: (Class) klass {
  id connector = [[[klass alloc] init] autorelease];
  [self setSharedConnector: connector];
}

- (id) init {
  self = [super init];
  if (self) {
    currentRequests = [[NSMutableArray alloc] initWithCapacity: 5];
    #ifdef LUNAR_TOOLKIT_ENABLE_MODELS
      router = [[LLRestRouter alloc] init];
    #endif
    #ifdef DEBUG
      loggingEnabled = YES;
    #else
      loggingEnabled = NO;
    #endif
  }
  return self;
}

- (id) initWithBaseURL: (NSString *) url {
  self = [super init];
  if (self) {
    baseURL = [url copy];
  }
  return self;
}

- (void) setRouter: (id) newRouter {
  NSAssert1(newRouter == nil || [newRouter conformsToProtocol: @protocol(LLRouter)],
    @"This object doesn't implement LLRouter protocol and can't be used as a router: %@", newRouter);
  if (newRouter != router) {
    [router release];
    router = [newRouter retain];
  }
}

- (void) setAccount: (id) newAccount {
  NSAssert1(newAccount == nil || [newAccount conformsToProtocol: @protocol(LLConnectorAccount)],
    @"This object doesn't implement LLConnectorAccount protocol and can't be used as an account: %@", newAccount);
  if (newAccount != account) {
    [account release];
    account = [newAccount retain];
  }
}

- (void) log: (NSString *) text {
  if (loggingEnabled) {
    NSLog(@"%@", text);
  }
}

#ifdef LUNAR_TOOLKIT_ENABLE_MODELS

- (LLRequest *) createRequestForObject: (LLModel *) object {
  LLRequest *request = [self requestToPath: [router pathForModel: [object class]] method: LLPostMethod];
  request.userInfo = LLHash(@"object", object);
  request.postData = [object encodeToPostData];
  return request;
}

- (LLRequest *) showRequestForObject: (LLModel *) object {
  LLRequest *request = [self requestToPath: [router pathForObject: object]];
  request.userInfo = LLHash(@"object", object);
  return request;
}

- (LLRequest *) updateRequestForObject: (LLModel *) object {
  LLRequest *request = [self requestToPath: [router pathForObject: object] method: LLPutMethod];
  request.userInfo = LLHash(@"object", object);
  request.postData = [object encodeToPostData];
  return request;
}

- (LLRequest *) deleteRequestForObject: (LLModel *) object {
  LLRequest *request = [self requestToPath: [router pathForObject: object] method: LLDeleteMethod];
  request.userInfo = LLHash(@"object", object);
  return request;
}

#endif // ifdef LUNAR_TOOLKIT_ENABLE_MODELS

- (void) prepareRequest: (LLRequest *) request {
  // override in subclasses to add headers and shit
}

- (LLRequest *) requestToPath: (NSString *) path {
  return [self requestToPath: path method: LLGetMethod];
}

- (LLRequest *) requestToURL: (NSString *) url {
  return [self requestToURL: url method: LLGetMethod];
}

- (LLRequest *) requestToPath: (NSString *) path method: (NSString *) method {
  NSString *url = [[self baseURL] stringByAppendingString: path];
  return [self requestToURL: url method: method];
}

- (LLRequest *) requestToURL: (NSString *) url method: (NSString *) method {
  LLRequest *request = [[LLRequest alloc] initWithURL: url connector: self];
  [request setRequestMethod: method];
  [request setTimeOutSeconds: DEFAULT_REQUEST_TIMEOUT];
  [request setExpectedContentType: LLJSONResponseType];
  if (usesHTTPAuthentication && account) {
    [request setUsername: [account username]];
    [request setPassword: [account password]];
  }
  if (userAgent) {
    [request addRequestHeader: @"User-Agent" value: userAgent];
  }
  [self prepareRequest: request];
  return [request autorelease];
}

- (void) requestStarted: (LLRequest *) request {
  if (loggingEnabled) {
    NSLog(@"sending request to %@", request.url);
  }

  [currentRequests addObject: request];
}

- (void) requestFinished: (LLRequest *) request {
  if (loggingEnabled) {
    NSLog(@"finished %@", request.response);
  }

  [self cleanupRequest: request];
  [self checkResponseForErrors: request];

  if (request.error) {
    [self handleFailedRequest: request];
  } else {
    [self performSelector: request.successHandler withObject: request];
  }
}

- (void) requestFailed: (LLRequest *) request {
  if (loggingEnabled) {
    NSLog(@"failed %@", request.response);
  }

  [self cleanupRequest: request];
  [self handleFailedRequest: request];
}

- (void) authenticationNeededForRequest: (LLRequest *) request {
  if (loggingEnabled) {
    NSLog(@"authentication failed in %@", request.response);
  }

  [self cleanupRequest: request];
  [self handleFailedAuthentication: request];
}

- (void) handleFinishedRequest: (LLRequest *) request {
  id response = [self parseResponseFromRequest: request];
  if (response) {
    [request notifyTargetOfSuccessWithObject: response];
  }
}

- (void) handleFailedRequest: (LLRequest *) request {
  [request notifyTargetOfError: request.error];
}

- (void) handleFailedAuthentication: (LLRequest *) request {
  [request cancel];
  [request notifyTargetOfAuthenticationError];
}

- (void) checkResponseForErrors: (LLRequest *) request {
  if (request.response.status >= 400) {
    request.error = [self errorWithCode: request.response.status message: @"Incorrect response"];
    return;
  }

  if (![request.response matchesExpectedContentType]) {
    request.error = [self errorWithCode: LLIncorrectContentTypeError message: @"Incorrect response"];
    return;
  }
}

- (NSError *) errorWithCode: (NSInteger) code message: (NSString *) message {
  return [NSError errorWithDomain: LLErrorDomain
                             code: code
                         userInfo: LLHash(NSLocalizedDescriptionKey, LLTranslate(message))];
}

- (id) parseResponseFromRequest: (LLRequest *) request {
  LLResponse *response = request.response;
  NSString *string;

  switch (request.expectedContentType) {
    case LLHTMLResponseType:
    case LLXMLResponseType:
      return [response.text llTrimmedString];

    case LLImageResponseType:
      return [[[IMAGE_CLASS alloc] initWithData: response.data] autorelease];

    case LLJSONResponseType:
      string = [response.text llTrimmedString];
      #ifdef LUNAR_TOOLKIT_ENABLE_MODELS_JSON
        if (string.length == 0) {
          return LLNull;
        } else {
          @try {
            return [LLModel valueFromJSONString: string];
          } @catch (NSException *exception) {
            request.error = [self errorWithCode: LLJSONParsingError message: @"Data parsing error"];
            [self handleFailedRequest: request];
            return nil;
          }
        }
      #else
        return string;
      #endif

    case LLImageDataResponseType:
    case LLBinaryResponseType:
      return response.data;

    case LLAnyResponseType:
      return response;

    default:
      return nil;
  }
}

#ifdef LUNAR_TOOLKIT_ENABLE_MODELS_JSON

- (id) parseObjectFromRequest: (LLRequest *) request model: (Class) klass {
  NSDictionary *json = [self parseResponseFromRequest: request];
  if (!json || [json isEqual: LLNull]) {
    return json;
  } else {
    return [klass objectFromJSON: json];
  }
}

- (NSArray *) parseObjectsFromRequest: (LLRequest *) request model: (Class) klass {
  NSArray *json = [self parseResponseFromRequest: request];
  if (!json || [json isEqual: LLNull]) {
    return json;
  } else {
    return [klass objectsFromJSON: json];
  }
}

#endif

- (void) cleanupRequest: (LLRequest *) request {
  [[request retain] autorelease];
  [currentRequests removeObject: request];
}

- (void) cancelAllRequests {
  [currentRequests makeObjectsPerformSelector: @selector(cancel)];
  [currentRequests removeAllObjects];
}

- (void) dealloc {
  [self cancelAllRequests];

  [baseURL release];
  [currentRequests release];
  [account release];
  [router release];
  [userAgent release];

  [super dealloc];
}

@end

#endif
