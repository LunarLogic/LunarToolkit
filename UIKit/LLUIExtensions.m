// -------------------------------------------------------
// LLUIExtensions.m
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#ifdef LUNAR_TOOLKIT_ENABLE_UIKIT

#import "LLMacros.h"
#import "LLUIExtensions.h"

// ------------------------------------------------------------------------------------------------

@implementation UIAlertView (LunarToolkit)

+ (void) llShowAlertWithTitle: (NSString *) title message: (NSString *) message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                  message: message
                                                 delegate: nil
                                        cancelButtonTitle: @"OK"
                                        otherButtonTitles: nil];
  [alert show];
  [alert release];
}

+ (void) llShowErrorWithMessage: (NSString *) message {
  [self llShowAlertWithTitle: LLTranslate(@"Error") message: message];
}

@end

// ------------------------------------------------------------------------------------------------

@implementation UINavigationController (LunarToolkit)

- (UIViewController *) llRootController {
  return [[self viewControllers] llFirstObject];
}

@end

// ------------------------------------------------------------------------------------------------

@implementation UITableView (LunarToolkit)

- (UITableViewCell *) llCellWithStyle: (UITableViewCellStyle) style andIdentifier: (NSString *) identifier {
  UITableViewCell *cell = [self dequeueReusableCellWithIdentifier: identifier];
  if (!cell) {
    cell = [[[UITableViewCell alloc] initWithStyle: style reuseIdentifier: identifier] autorelease];
  }
  return cell;
}

- (UITableViewCell *) llGenericCellWithStyle: (UITableViewCellStyle) style {
  return [self llCellWithStyle: style andIdentifier: LLGenericCell];
}

@end

// ------------------------------------------------------------------------------------------------

@implementation UIView (LunarToolkit)

- (void) llMoveVerticallyBy: (CGFloat) pixels {
  CGRect frame = self.frame;
  frame.origin.y += pixels;
  self.frame = frame;
}

- (void) llMoveVerticallyTo: (CGFloat) position {
  CGRect frame = self.frame;
  frame.origin.y = position;
  self.frame = frame;
}

- (void) llMoveHorizontallyBy: (CGFloat) pixels {
  CGRect frame = self.frame;
  frame.origin.x += pixels;
  self.frame = frame;
}

- (void) llMoveHorizontallyTo: (CGFloat) position {
  CGRect frame = self.frame;
  frame.origin.x = position;
  self.frame = frame;
}

- (void) llResizeVerticallyBy: (CGFloat) pixels {
  CGRect frame = self.frame;
  frame.size.height += pixels;
  self.frame = frame;
}

- (void) llResizeVerticallyTo: (CGFloat) position {
  CGRect frame = self.frame;
  frame.size.height = position;
  self.frame = frame;
}

- (void) llResizeHorizontallyBy: (CGFloat) pixels {
  CGRect frame = self.frame;
  frame.size.width += pixels;
  self.frame = frame;
}

- (void) llResizeHorizontallyTo: (CGFloat) position {
  CGRect frame = self.frame;
  frame.size.width = position;
  self.frame = frame;
}

@end

// ------------------------------------------------------------------------------------------------

@implementation UIViewController (LunarToolkit)

- (void) llSetBackButtonTitle: (NSString *) title {
  UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle: title
                                                             style: UIBarButtonItemStylePlain
                                                            target: nil
                                                            action: nil];
  self.navigationItem.backBarButtonItem = [button autorelease];
}

- (void) llHidePopupView {
  [self dismissModalViewControllerAnimated: YES];
}

- (void) llShowPopupView: (UIViewController *) controller {
  UINavigationController *navigation = [controller llWrapInNavigationController];
  [self presentModalViewController: navigation animated: YES];
}

- (void) llShowPopupView: (UIViewController *) controller withStyle: (UIModalPresentationStyle) style {
  UINavigationController *navigation = [controller llWrapInNavigationController];
  if ([navigation respondsToSelector: @selector(setModalPresentationStyle:)]) {
    navigation.modalPresentationStyle = style;
  }
  [self presentModalViewController: navigation animated: YES];
}

- (UINavigationController *) llWrapInNavigationController {
  return [[[UINavigationController alloc] initWithRootViewController: self] autorelease];
}

@end

#endif
