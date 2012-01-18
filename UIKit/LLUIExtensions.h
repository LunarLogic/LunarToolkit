// -------------------------------------------------------
// LLUIExtensions.h
//
// Copyright (c) 2010-11 Jakub Suder <jakub.suder@gmail.com>
// Licensed under MIT license
// -------------------------------------------------------

#import <UIKit/UIKit.h>

#define LLUIColorWithRGB(r, g, b) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: 1.0]
#define LLUIColorWithRGBA(r, g, b, a) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: a]
#define LLUIColorWithWhiteValue(w) [UIColor colorWithWhite: w/255.0 alpha: 1.0]

// ------------------------------------------------------------------------------------------------

@interface UIAlertView (LunarToolkit)

// displays a UIAlertView with given title, message and one button named "OK"
+ (void) llShowAlertWithTitle: (NSString *) title message: (NSString *) message;

// displays a UIAlertView with title "Error" (localized) and given message
+ (void) llShowErrorWithMessage: (NSString *) message;
@end

// ------------------------------------------------------------------------------------------------

@interface UINavigationController (LunarToolkit)

// returns the view controller at the bottom of the stack
- (UIViewController *) llRootController;

@end

// ------------------------------------------------------------------------------------------------

@interface UITableView (LunarToolkit)

// reuses a cell with given id from the table, if possible, otherwise makes a new one with given id and style
- (UITableViewCell *) llCellWithStyle: (UITableViewCellStyle) style andIdentifier: (NSString *) identifier;

// as above, but uses a generic cell id (use this if you only have one cell type in the table)
- (UITableViewCell *) llGenericCellWithStyle: (UITableViewCellStyle) style;
@end

// ------------------------------------------------------------------------------------------------

@interface UIView (LunarToolkit)
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

@interface UIViewController (LunarToolkit)

// sets the name used on back button when this controller is below the active one (by setting backBarButtonItem)
- (void) llSetBackButtonTitle: (NSString *) title;

// hides the controller that is currently displayed as a modal popup
- (void) llHidePopupView;

// shows a given controller in a modal popup, wrapped in a navigation view
- (void) llShowPopupView: (UIViewController *) controller;

// shows a given controller in a modal popup, wrapped in a navigation view, with given presentation style (for iPad)
- (void) llShowPopupView: (UIViewController *) controller withStyle: (UIModalPresentationStyle) style;

// returns a new navigation controller having this controller as root
- (UINavigationController *) llWrapInNavigationController;

@end
