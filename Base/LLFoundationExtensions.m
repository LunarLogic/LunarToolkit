// -------------------------------------------------------
// LLFoundationExtensions.m
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#import "LLFoundationExtensions.h"
#import "LLMacros.h"

// ------------------------------------------------------------------------------------------------

@implementation NSArray (LunarToolkit)

- (id) llFirstObject {
  if (self.count > 0) {
    return [self objectAtIndex: 0];
  } else {
    return nil;
  }
}

- (NSArray *) llArrayByCalling: (SEL) selector {
  NSMutableArray *collected = [[NSMutableArray alloc] initWithCapacity: self.count];
  for (id element in self) {
    [collected addObject: [element performSelector: selector]];
  }

  NSArray *returned = [NSArray arrayWithArray: collected];
  [collected release];
  return returned;
}

- (NSArray *) llCompact {
  return [self llFilterWithPredicate: @"SELF != NIL"];
}

- (NSArray *) llFilterWithPredicate: (NSString *) filter {
  return [self filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: filter]];
}

- (NSArray *) llSortedArrayUsingField: (NSString *) field ascending: (BOOL) ascending {
  return [self llSortedArrayUsingField: field ascending: ascending compareWith: @selector(compare:)];
}

- (NSArray *) llSortedArrayUsingField: (NSString *) field ascending: (BOOL) ascending compareWith: (SEL) compareMethod {
  NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey: field
                                                             ascending: ascending
                                                              selector: compareMethod];
  NSArray *descriptors = [[NSArray alloc] initWithObjects: descriptor, nil];
  NSArray *sortedArray = [self sortedArrayUsingDescriptors: descriptors];
  [descriptor release];
  [descriptors release];
  return sortedArray;
}

- (NSDictionary *) llGroupByKey: (NSString *) key {
  NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];
  for (id object in self) {
    id keyForObject = [object valueForKey: key];
    NSMutableArray *list = [groups objectForKey: keyForObject];
    if (!list) {
      list = [NSMutableArray arrayWithCapacity: 5];
      [groups setObject: list forKey: keyForObject];
    }
    [list addObject: object];
  }
  return [groups autorelease];
}

@end

// ------------------------------------------------------------------------------------------------

@implementation NSDate (LunarToolkit)

+ (NSDate *) llDaysAgo: (NSInteger) days {
  return [NSDate llDaysFromNow: -days];
}

+ (NSDate *) llDaysFromNow: (NSInteger) days {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *interval = [[NSDateComponents alloc] init];
  [interval setDay: days];
  NSDate *date = [calendar dateByAddingComponents: interval toDate: [NSDate date] options: 0];
  [interval release];
  return date;
}

+ (NSDateFormatter *) llJSONDateFormatter {
  static NSDateFormatter *formatter = nil;
  if (!formatter) {
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
  }
  return formatter;
}

- (BOOL) llIsEarlierOrSameDay: (NSDate *) otherDate {
  NSDate *current = [self llMidnight];
  NSDate *other = [otherDate llMidnight];
  return ([current earlierDate: other] == current);
}

- (NSDate *) llMidnight {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSUInteger fieldFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
  NSDateComponents *fields = [calendar components: fieldFlags fromDate: self];
  return [calendar dateFromComponents: fields];
}

- (NSString *) llJSONDateFormat {
  return [[NSDate llJSONDateFormatter] stringFromDate: self];
}

@end

// ------------------------------------------------------------------------------------------------

@implementation NSDictionary (LunarToolkit)

+ (NSDictionary *) llDictionaryWithKeysAndObjects: (id) firstObject, ... {
  if (!firstObject) {
    return [NSDictionary dictionary];
  } else {
    va_list args;
    va_start(args, firstObject);

    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity: 5];
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity: 5];
    id object = firstObject;
    BOOL isKey = YES;

    do {
      if (isKey) {
        [keys addObject: object];
      } else {
        [objects addObject: object];
      }
      object = va_arg(args, id);
      isKey = !isKey;
    } while (object);

    va_end(args);

    NSDictionary *result = [NSDictionary dictionaryWithObjects: objects forKeys: keys];
    [keys release];
    [objects release];
    return result;
  }
}

@end

// ------------------------------------------------------------------------------------------------

@implementation NSNull (LunarToolkit)

- (BOOL) llIsPresent {
  return NO;
}

@end

// ------------------------------------------------------------------------------------------------

@implementation NSObject (LunarToolkit)

+ (NSArray *) llArrayByCalling: (SEL) selector withObjectsFrom: (NSArray *) array {
  NSMutableArray *collected = [[NSMutableArray alloc] initWithCapacity: array.count];
  for (id element in array) {
    [collected addObject: [self performSelector: selector withObject: element]];
  }

  NSArray *returned = [NSArray arrayWithArray: collected];
  [collected release];
  return returned;
}

- (NSArray *) llArrayByCalling: (SEL) selector withObjectsFrom: (NSArray *) array {
  NSMutableArray *collected = [[NSMutableArray alloc] initWithCapacity: array.count];
  for (id element in array) {
    [collected addObject: [self performSelector: selector withObject: element]];
  }

  NSArray *returned = [NSArray arrayWithArray: collected];
  [collected release];
  return returned;
}

@end

// ------------------------------------------------------------------------------------------------

@implementation NSString (LunarToolkit)

+ (NSString *) llStringWithFormEncodedFields: (NSDictionary *) fields {
  NSMutableArray *parts = [[NSMutableArray alloc] initWithCapacity: fields.count];
  for (NSString *field in fields) {
    [parts addObject: LLFormat(@"%@=%@", field, [fields objectForKey: field])];
  }

  NSString *result = [parts componentsJoinedByString: @"&"];
  [parts release];
  return result;
}

+ (NSString *) llStringWithFormEncodedFields: (NSDictionary *) fields ofModelNamed: (NSString *) name {
  NSMutableArray *parts = [[NSMutableArray alloc] initWithCapacity: fields.count];
  for (NSString *field in fields) {
    [parts addObject: LLFormat(@"%@[%@]=%@", name, field, [fields objectForKey: field])];
  }

  NSString *result = [parts componentsJoinedByString: @"&"];
  [parts release];
  return result;
}

- (BOOL) llIsPresent {
  return ([[self llTrimmedString] length] > 0);
}

- (BOOL) llContainsString: (NSString *) substring {
  NSRange found = [self rangeOfString: substring];
  return (found.location != NSNotFound);
}

- (NSString *) llCamelizedString {
  NSArray *words = [self componentsSeparatedByString: @"_"];
  if (words.count == 1) {
    return [[self copy] autorelease];
  } else {
    NSMutableString *camelized = [[NSMutableString alloc] initWithString: [words llFirstObject]];
    for (NSInteger i = 1; i < words.count; i++) {
      [camelized appendString: [[words objectAtIndex: i] capitalizedString]];
    }
    return [camelized autorelease];
  }
}

- (NSString *) llPluralizedString {
  static NSDictionary *exceptions;
  if (!exceptions) {
    exceptions = LLHash(
      @"person", @"people",
      @"man", @"men",
      @"woman", @"women",
      @"child", @"children"
    );
    [exceptions retain];
  }

  NSString *downcased = [self lowercaseString];
  NSString *result = [exceptions objectForKey: downcased];
  if (result) {
    // one of the exceptions above
    return result;
  } else if ([downcased hasSuffix: @"ch"]) {
    // e.g. match -> matches
    return [downcased stringByAppendingString: @"es"];
  } else if ([downcased hasSuffix: @"fe"]) {
    // e.g. knife -> knives
    return [[downcased substringToIndex: downcased.length - 2] stringByAppendingString: @"ves"];
  } else if ([downcased hasSuffix: @"sh"]) {
    // e.g. flash -> flashes
    return [downcased stringByAppendingString: @"es"];
  } else if ([downcased hasSuffix: @"ss"]) {
    // e.g. boss -> bosses
    return [downcased stringByAppendingString: @"es"];
  } else if ([downcased hasSuffix: @"us"]) {
    // e.g. bus -> buses
    return [downcased stringByAppendingString: @"es"];
  } else if ([downcased hasSuffix: @"x"]) {
    // e.g. box -> boxes
    return [downcased stringByAppendingString: @"es"];
  } else if ([downcased hasSuffix: @"y"]) {
    // e.g. activity -> activities
    return [[downcased substringToIndex: downcased.length - 1] stringByAppendingString: @"ies"];
  } else if ([downcased hasSuffix: @"s"]) {
    return downcased;
  } else {
    return [downcased stringByAppendingString: @"s"];
  }
}

- (NSString *) llStringWithPercentEscapesForFormValues {
  CFStringRef escapedSymbols = CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/");
  CFStringRef string = (CFStringRef) [[self mutableCopy] autorelease];
  NSString *escaped =
    (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, string, NULL, escapedSymbols, kCFStringEncodingUTF8);
  return NSMakeCollectable([escaped autorelease]);
}

- (NSString *) llStringWithUppercaseFirstLetter {
  NSString *head = [self substringToIndex: 1];
  NSString *tail = [self substringFromIndex: 1];
  return [[head uppercaseString] stringByAppendingString: tail];
}

- (NSString *) llTrimmedString {
  return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) llUnderscoreSeparatedString {
  NSCharacterSet *uppercaseLetters = [NSCharacterSet uppercaseLetterCharacterSet];
  NSScanner *scanner = [NSScanner localizedScannerWithString: self];
  [scanner setCaseSensitive: YES];
  NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity: self.length];
  NSString *part;
  BOOL found;

  while (true) {
    found = [scanner scanUpToCharactersFromSet: uppercaseLetters intoString: &part];
    if (!found) {
      break;
    }

    [buffer appendString: part];

    found = [scanner scanCharactersFromSet: uppercaseLetters intoString: &part];
    if (!found) {
      break;
    }

    if (![buffer hasSuffix: @"_"]) {
      [buffer appendString: @"_"];
    }

    if (part.length > 1) {
      [buffer appendString: [[part substringToIndex: part.length - 1] lowercaseString]];
      [buffer appendString: @"_"];
      [buffer appendString: [[part substringFromIndex: part.length - 1] lowercaseString]];
    } else {
      [buffer appendString: [part lowercaseString]];
    }
  }

  NSString *result = [NSString stringWithString: buffer];
  [buffer release];
  return result;
}

@end
