# HotCocoa

[![Language Swift](https://img.shields.io/badge/Language-Swift%204.0-orange.svg?style=flat)](https://swift.org)
[![Version](https://img.shields.io/cocoapods/v/HotCocoa.svg?style=flat)](http://cocoapods.org/pods/HotCocoa)
[![License](https://img.shields.io/cocoapods/l/HotCocoa.svg?style=flat)](http://cocoapods.org/pods/HotCocoa)
[![Platform](https://img.shields.io/cocoapods/p/HotCocoa.svg?style=flat)](http://cocoapods.org/pods/HotCocoa)

**HotCocoa** is a list of extensions that provides extra functionality and syntactic sugar for Cocoa and Cocoa Touch.

## Examples

### UIColor & NSColor
Construct a `UIColor` or `NSColor` with rgb values from 0 to 255:
```swift
let color = UIColor(r: 5, g: 185, b: 255)
```
Or
```swift
let color = NSColor(r: 5, g: 185, b: 255)
```

Construct a `UIColor `from a hex number:
```swift
let color = UIColor(hex: 0x02B8FF)
```
Or a hex string:
```swift
let color = UIColor(hexString: "02B8FF")
```

### UIWindow
Easily create and show a new `UIWindow` with a given `UIViewController`:
```swift
let window = UIWindow(rootViewController: ViewController()) // UIScreen.main.bounds is the default frame
```
or
```swift
let window = UIWindow(frame: myRect, rootViewController: ViewController())
```

### UIViewController
Easily dismiss the keyboard when the user taps the screen:
```swift
viewController.hideKeyboardWhenTappedAround()
```

Easily display a `UIAlertController` insude your `UIViewController`:
```swift
var actions = [UIAlertActions]()
...
viewController.displayAlertController(title: "Important", message: "This is an alert!", actions: actions) // A completion closure can be added if necessary
```

### UserDefaults
Easily save any value that conforms to the Codable protocol to UserDefaults
```swift
struct MyStruct: Codable { ... }

let myStruct = MyStruct()
UserDefaults.standard.set(object: myStruct, forKey: "myStruct")
```

and retrieve it just as easily
```swift
myStruct = UserDefaults.get(type: MyStruct, forKey: "myStruct")
```

### And much more!

Use it in a project to see what's available.

## Installation

### Requirements
* iOS 8.0+
* macOS 10.10+
* tvOS 9.0+
* Swift 4

### CocoaPods

HotCocoa is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HotCocoa', '~> 1.0.0'
```

## Contributing
Open an issue or submit a pull request.
