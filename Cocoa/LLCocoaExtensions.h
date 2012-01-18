// -------------------------------------------------------
// LLCocoaExtensions.h
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#import <Cocoa/Cocoa.h>

// ------------------------------------------------------------------------------------------------

#define LLNSColorWithRGB(r, g, b) [NSColor colorWithCalibratedRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: 1.0]
#define LLNSColorWithRGBA(r, g, b, a) [NSColor colorWithCalibratedRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: a]
#define LLNSColorWithWhiteValue(w) [NSColor colorWithCalibratedWhite: w/255.0 alpha: 1.0]

// ------------------------------------------------------------------------------------------------

@interface NSControl (LunarToolkit)
- (void) llDisable;
- (void) llEnable;
@end

// ------------------------------------------------------------------------------------------------

@interface NSTextField (LunarToolkit)
- (void) llUnselectText;
@end

// ------------------------------------------------------------------------------------------------

@interface NSView (LunarToolkit)
- (void) llHide;
- (void) llShow;
- (void) llMoveVerticallyBy: (CGFloat) pixels;
- (void) llMoveVerticallyTo: (CGFloat) position;
- (void) llMoveHorizontallyBy: (CGFloat) pixels;
- (void) llMoveHorizontallyTo: (CGFloat) position;
- (void) llResizeVerticallyBy: (CGFloat) pixels;
- (void) llResizeVerticallyTo: (CGFloat) position;
- (void) llResizeHorizontallyBy: (CGFloat) pixels;
- (void) llResizeHorizontallyTo: (CGFloat) position;
@end

// ------------------------------------------------------------------------------------------------

@interface NSWindow (LunarToolkit)
- (void) llShowAlertSheetWithTitle: (NSString *) title message: (NSString *) message;
- (void) llMoveVerticallyBy: (CGFloat) pixels;
- (void) llMoveVerticallyTo: (CGFloat) position;
- (void) llMoveHorizontallyBy: (CGFloat) pixels;
- (void) llMoveHorizontallyTo: (CGFloat) position;
- (void) llResizeVerticallyBy: (CGFloat) pixels;
- (void) llResizeVerticallyTo: (CGFloat) position;
- (void) llResizeHorizontallyBy: (CGFloat) pixels;
- (void) llResizeHorizontallyTo: (CGFloat) position;
@end
