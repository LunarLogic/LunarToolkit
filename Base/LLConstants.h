// -------------------------------------------------------
// LLConstants.h
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#define LLGenericCell @"LLGenericCell"

#define LLKilobyte (1024)
#define LLMegabyte (1024 * LLKilobyte)
#define LLGigabyte (1024 * LLMegabyte)
#define LLMinute   (60)
#define LLHour     (60 * LLMinute)
#define LLDay      (24 * LLHour)

#define LLErrorDomain @"LLErrorDomain"

#define LLGetMethod    @"GET"
#define LLPostMethod   @"POST"
#define LLPutMethod    @"PUT"
#define LLDeleteMethod @"DELETE"

#define LLHTTPStatusOK                  200
#define LLHTTPStatusCreated             201
#define LLHTTPStatusAccepted            202
#define LLHTTPStatusNoContent           204
#define LLHTTPStatusBadRequest          400
#define LLHTTPStatusUnauthorized        401
#define LLHTTPStatusForbidden           403
#define LLHTTPStatusNotFound            404
#define LLHTTPStatusConflict            409
#define LLHTTPStatusPreconditionFailed  412
#define LLHTTPStatusInternalServerError 500
#define LLHTTPStatusBadGateway          502
#define LLHTTPStatusServiceUnavailable  503

#define LLIncorrectContentTypeError     -1
#define LLJSONParsingError              -2
