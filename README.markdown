# LunarToolkit

This project was started by Jakub Suder as a personal collection of various useful ObjC methods - extensions to native
Cocoa, UIKit and Foundation classes, extracted from several projects and gathered in one place for easier reuse. Since
then we've used it in all our projects, and with each new one it keeps growing in new methods and classes. We're sharing
it here now - perhaps someone else will find them useful too.

## Usage

Add the whole directory to your Xcode project. You don't need to add the stuff on the root level, except
`LunarToolkit.h`, and you don't need the bridge support files (`Bridges/*`), unless you're writing an app in MacRuby or
other similar language. If you do use MacRuby, then add the bridge support files too, otherwise you may get some hard to
spot bugs (like boolean methods returning true when they shouldn't, etc.).

The code is divided into several "modules" which can be enabled or disabled. Only the "Base" one is required, the rest
is optional. You don't have to add the modules which you don't use into Xcode, though if you do, they will just be
ignored (the compiler will skip them during build).

To import and configure LunarToolkit, add an import line to your `Prefix.pch` file, and before that line declare
which modules you'd like to import (Cocoa and UIKit obviously shouldn't be used together):

    #define LUNAR_TOOLKIT_ENABLE_COCOA
    #define LUNAR_TOOLKIT_ENABLE_MODELS
    #define LUNAR_TOOLKIT_ENABLE_NETWORK
    #define LUNAR_TOOLKIT_ENABLE_SECURITY
    #define LUNAR_TOOLKIT_ENABLE_UIKIT
    #import "LunarToolkit.h"

The configuration lines have to be added before the import, otherwise they won't matter.

Another thing you can configure this way is the choice of a JSON parsing library, if you need one. 4 libraries are
supported: [YAJL](http://github.com/gabriel/yajl-objc), [JSON Framework](http://stig.github.com/json-framework),
[TouchJSON](https://github.com/schwa/TouchJSON) and [JSONKit](https://github.com/johnezang/JSONKit) (see also a
[blog post that compares them](http://psionides.eu/2010/12/12/cocoa-json-parsing-libraries-part-2)).

To use one of them, add one of these lines to the prefix file:

    #define LUNAR_TOOLKIT_USE_YAJL
    #define LUNAR_TOOLKIT_USE_JSON_FRAMEWORK
    #define LUNAR_TOOLKIT_USE_TOUCHJSON
    #define LUNAR_TOOLKIT_USE_JSONKIT

If you don't add any of these, methods related to JSON parsing will be unavailable.

## Dependencies

For using some methods of LLModel, a JSON parser is required. The Network module requires
[ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest) library.

The Security module uses either [SDKeychain](https://github.com/sdegutis/SDKeychain) by Steven Degutis or
[SFHFKeychainUtils](https://github.com/ldandersen/scifihifi-iphone) by Buzz Andersen (both are already bundled inside
LunarToolkit). Both of these require adding `Security.framework` (provided in the SDK) to the project (see Add ->
Existing Frameworks...).

## Available classes

### Base

* LLConstants - useful constants, e.g. for data size units, time units, and HTTP methods and status codes
* LLFoundationExtensions - categories adding methods to Foundation classes like NSString, NSArray, NSDate
* LLIntArray - an array that stores integers (actual integers, not NSNumbers)
* LLMacros - useful macros, e.g. for creating Foundation objects or sending notifications

### Cocoa

* LLCocoaExtensions - categories adding useful methods to Cocoa classes

### Models

* LLAccount - class representing user accounts, provides methods for loading and saving data to settings and Keychain. **Requires Security module**.
* LLModel - base class for implementing models built from JSON data. **Some methods require a JSON library**.

### Network

Requires [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest).

* LLConnector - base class for building "server connectors" that send requests to a remote server and parse responses. **Some methods require Models module and/or a JSON library**.
* LLPathBuilder - a tool for building URLs with parameters
* LLRequest - represents a single request to a remote server
* LLResponse - represents a response to a request
* LLRestRouter - generates URLs for some helper methods in LLConnector. **Requires Models module**.

### Security

Requires `Security.framework`.

* LLSecurityExtensions - methods for setting and reading passwords from the Keychain (both on MacOSX and iOS)

### UIKit

* LLUIKitExtensions - categories adding useful methods to UIKit classes


## Contributing

If you want to add some new features, fix bugs etc.:

* if you're from Lunar Logic: ask me ([@psionides](http://github.com/psionides)) for access, commit on a branch, send me a pull request to merge into master
* otherwise: make a fork, push stuff to it, send me a pull request

## License

Copyright by Jakub Suder <jakub.suder at gmail.com> & Lunar Logic Polska. Licensed under
[MIT license](https://github.com/LunarLogicPolska/LunarToolkit/blob/master/MIT-LICENSE.txt).
