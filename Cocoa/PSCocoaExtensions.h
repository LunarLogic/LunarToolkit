// -------------------------------------------------------
// PSCocoaExtensions.h
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#import <Cocoa/Cocoa.h>

// ------------------------------------------------------------------------------------------------

#define PSNSColorWithRGB(r, g, b) [NSColor colorWithCalibratedRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: 1.0]
#define PSNSColorWithRGBA(r, g, b, a) [NSColor colorWithCalibratedRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: a]
#define PSNSColorWithWhiteValue(w) [NSColor colorWithCalibratedWhite: w/255.0 alpha: 1.0]

// ------------------------------------------------------------------------------------------------

@interface NSControl (LunarToolkit)
- (void) psDisable;
- (void) psEnable;
@end

// ------------------------------------------------------------------------------------------------

@interface NSTextField (LunarToolkit)
- (void) psUnselectText;
@end

// ------------------------------------------------------------------------------------------------

@interface NSView (LunarToolkit)
- (void) psHide;
- (void) psShow;
- (void) psMoveVerticallyBy: (CGFloat) pixels;
- (void) psMoveVerticallyTo: (CGFloat) position;
- (void) psMoveHorizontallyBy: (CGFloat) pixels;
- (void) psMoveHorizontallyTo: (CGFloat) position;
- (void) psResizeVerticallyBy: (CGFloat) pixels;
- (void) psResizeVerticallyTo: (CGFloat) position;
- (void) psResizeHorizontallyBy: (CGFloat) pixels;
- (void) psResizeHorizontallyTo: (CGFloat) position;
@end

// ------------------------------------------------------------------------------------------------

@interface NSWindow (LunarToolkit)
- (void) psShowAlertSheetWithTitle: (NSString *) title message: (NSString *) message;
- (void) psMoveVerticallyBy: (CGFloat) pixels;
- (void) psMoveVerticallyTo: (CGFloat) position;
- (void) psMoveHorizontallyBy: (CGFloat) pixels;
- (void) psMoveHorizontallyTo: (CGFloat) position;
- (void) psResizeVerticallyBy: (CGFloat) pixels;
- (void) psResizeVerticallyTo: (CGFloat) position;
- (void) psResizeHorizontallyBy: (CGFloat) pixels;
- (void) psResizeHorizontallyTo: (CGFloat) position;
@end
