// -------------------------------------------------------
// LLModelManager.h
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

/*
  Class storage helper used internally by LLModel. Nothing interesting here, move along.
*/

#import <Foundation/Foundation.h>

@interface LLModelManager : NSObject {
  NSMutableArray *list;
  NSMutableDictionary *identityMap;
  NSArray *propertyList;
}

@property (nonatomic, readonly) NSMutableArray *list;
@property (nonatomic, readonly) NSMutableDictionary *identityMap;
@property (nonatomic, copy) NSArray *propertyList;

+ (LLModelManager *) managerForClass: (NSString *) className;

@end
