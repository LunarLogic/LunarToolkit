// -------------------------------------------------------
// LLCocoaExtensions.m
//
// Copyright (c) 2010 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#ifdef LUNAR_TOOLKIT_ENABLE_COCOA

#import "LLCocoaExtensions.h"

// ------------------------------------------------------------------------------------------------

@implementation NSControl (LunarToolkit)

- (void) llDisable {
  [self setEnabled: NO];
}

- (void) llEnable {
  [self setEnabled: YES];
}

@end

// ------------------------------------------------------------------------------------------------

@implementation NSTextField (LunarToolkit)

- (void) llUnselectText {
  NSText *editor = [[self window] fieldEditor: YES forObject: self];
  editor.selectedRange = NSMakeRange(editor.string.length, 0);
}

@end

// ------------------------------------------------------------------------------------------------

@implementation NSView (LunarToolkit)

- (void) llHide {
  [self setHidden: YES];
}

- (void) llShow {
  [self setHidden: NO];
}

- (void) llMoveVerticallyBy: (CGFloat) pixels {
  NSRect frame = self.frame;
  frame.origin.y += pixels;
  self.frame = frame;
}

- (void) llMoveVerticallyTo: (CGFloat) position {
  NSRect frame = self.frame;
  frame.origin.y = position;
  self.frame = frame;
}

- (void) llMoveHorizontallyBy: (CGFloat) pixels {
  NSRect frame = self.frame;
  frame.origin.x += pixels;
  self.frame = frame;
}

- (void) llMoveHorizontallyTo: (CGFloat) position {
  NSRect frame = self.frame;
  frame.origin.x = position;
  self.frame = frame;
}

- (void) llResizeVerticallyBy: (CGFloat) pixels {
  NSRect frame = self.frame;
  frame.size.height += pixels;
  self.frame = frame;
}

- (void) llResizeVerticallyTo: (CGFloat) position {
  NSRect frame = self.frame;
  frame.size.height = position;
  self.frame = frame;
}

- (void) llResizeHorizontallyBy: (CGFloat) pixels {
  NSRect frame = self.frame;
  frame.size.width += pixels;
  self.frame = frame;
}

- (void) llResizeHorizontallyTo: (CGFloat) position {
  NSRect frame = self.frame;
  frame.size.width = position;
  self.frame = frame;
}

@end

// ------------------------------------------------------------------------------------------------

@implementation NSWindow (LunarToolkit)

- (void) llShowAlertSheetWithTitle: (NSString *) title message: (NSString *) message {
  NSAlert *alertWindow = [NSAlert alertWithMessageText: title
                                         defaultButton: @"OK"
                                       alternateButton: nil
                                           otherButton: nil
                             informativeTextWithFormat: message];
  [alertWindow beginSheetModalForWindow: self
                          modalDelegate: nil
                         didEndSelector: nil
                            contextInfo: nil];
}

- (void) llMoveVerticallyBy: (CGFloat) pixels {
  NSRect frame = self.frame;
  frame.origin.y += pixels;
  [self setFrame: frame display: YES];
}

- (void) llMoveVerticallyTo: (CGFloat) position {
  NSRect frame = self.frame;
  frame.origin.y = position;
  [self setFrame: frame display: YES];
}

- (void) llMoveHorizontallyBy: (CGFloat) pixels {
  NSRect frame = self.frame;
  frame.origin.x += pixels;
  [self setFrame: frame display: YES];
}

- (void) llMoveHorizontallyTo: (CGFloat) position {
  NSRect frame = self.frame;
  frame.origin.x = position;
  [self setFrame: frame display: YES];
}

- (void) llResizeVerticallyBy: (CGFloat) pixels {
  NSRect frame = self.frame;
  frame.size.height += pixels;
  [self setFrame: frame display: YES];
}

- (void) llResizeVerticallyTo: (CGFloat) position {
  NSRect frame = self.frame;
  frame.size.height = position;
  [self setFrame: frame display: YES];
}

- (void) llResizeHorizontallyBy: (CGFloat) pixels {
  NSRect frame = self.frame;
  frame.size.width += pixels;
  [self setFrame: frame display: YES];
}

- (void) llResizeHorizontallyTo: (CGFloat) position {
  NSRect frame = self.frame;
  frame.size.width = position;
  [self setFrame: frame display: YES];
}

@end

#endif
