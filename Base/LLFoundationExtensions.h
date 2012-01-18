// -------------------------------------------------------
// LLFoundationExtensions.h
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#import <Foundation/Foundation.h>

// ------------------------------------------------------------------------------------------------

@interface NSArray (LunarToolkit)

// returns object at index 0, or nil if array is empty
- (id) llFirstObject;

// returns results of calling given selector on all elements
- (NSArray *) llArrayByCalling: (SEL) selector;

// returns the array with NSNull values removed
- (NSArray *) llCompact;

// returns the array filtered using a given predicate (see NSPredicate docs)
- (NSArray *) llFilterWithPredicate: (NSString *) filter;

// returns the array sorted by values of a given property
- (NSArray *) llSortedArrayUsingField: (NSString *) field ascending: (BOOL) ascending;
- (NSArray *) llSortedArrayUsingField: (NSString *) field ascending: (BOOL) ascending compareWith: (SEL) compareMethod;

// returns a dictionary grouping elements by all possible values of one property: { value => [matching elements] }
- (NSDictionary *) llGroupByKey: (NSString *) key;
@end

// ------------------------------------------------------------------------------------------------

@interface NSDate (LunarToolkit)

// returns a date n days ago
+ (NSDate *) llDaysAgo: (NSInteger) days;

// returns a date n days from now
+ (NSDate *) llDaysFromNow: (NSInteger) days;

// returns a formatter using JSON date format (YYYY-MM-DD)
+ (NSDateFormatter *) llJSONDateFormatter;

// tells if the other date is earlier or is on the same day (even if a few hours later)
- (BOOL) llIsEarlierOrSameDay: (NSDate *) otherDate;

// returns the midnight at the beginning of that day
- (NSDate *) llMidnight;

// returns the date formatted with a JSON formatter
- (NSString *) llJSONDateFormat;
@end

// ------------------------------------------------------------------------------------------------

@interface NSDictionary (LunarToolkit)

// returns a dictionary constructed from key-value pairs, in that order: key1, value1, key2, value2, ...
+ (NSDictionary *) llDictionaryWithKeysAndObjects: (id) firstObject, ...;
@end

// ------------------------------------------------------------------------------------------------

@interface NSNull (LunarToolkit)

// for NSNull, always returns NO
- (BOOL) llIsPresent;
@end

// ------------------------------------------------------------------------------------------------

@interface NSObject (LunarToolkit)

// returns results of calling given selector on self, passing each element from the array in argument
+ (NSArray *) llArrayByCalling: (SEL) selector withObjectsFrom: (NSArray *) array;
- (NSArray *) llArrayByCalling: (SEL) selector withObjectsFrom: (NSArray *) array;
@end

// ------------------------------------------------------------------------------------------------

@interface NSString (LunarToolkit)

// returns a string constructed from key-value pairs which can be used as POST data (e.g. key=1&other=2&...)
+ (NSString *) llStringWithFormEncodedFields: (NSDictionary *) fields;

// as above, but keys are sent as fields of a model, e.g. model[field1]=1&model[field2]=2&...
+ (NSString *) llStringWithFormEncodedFields: (NSDictionary *) fields ofModelNamed: (NSString *) name;

// returns YES if the string isn't empty any doesn't contain whitespace only
- (BOOL) llIsPresent;

// tells if the string contains a substring
- (BOOL) llContainsString: (NSString *) substring;

// converts this_kind_of_string to thisKindOfString
- (NSString *) llCamelizedString;

// converts 'object' to 'objects' etc.
- (NSString *) llPluralizedString;

// encodes string to be used in URLs, i.e. replaces all dangerous characters with %xx
- (NSString *) llStringWithPercentEscapesForFormValues;

// converts "such string" to "Such string"
- (NSString *) llStringWithUppercaseFirstLetter;

// strips whitespace from both ends of the string
- (NSString *) llTrimmedString;

// the opposite of llCamelizedString
- (NSString *) llUnderscoreSeparatedString;
@end
