# Interactive Bottom Sheet (Variation of [joomcode-BottomSheet](https://github.com/joomcode/BottomSheet))

Bottom Sheet component is designed to handle content while allowing interaction in rootView (similar to IOS sheet)
- ✅ pass it a controller view and it will present it in a drawer with these configurations:
    ✅ Custom Corner Radius
    ✅ Option to handle Orientation Changes
    ✅ ChildView interuption of gestures
- ✅ Resizable by setting preferedContentSize (Animated)
- ✅ Animated Opening, closing, resizing, dragging

## Installation

### Swift Package Manager

To integrate Bottom Sheet into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/BiXtico/BottomSheet", from: "2.0.0")
]
```

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ bundle install
```

To integrate BottomSheet into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target '<Your Target Name>' do
    pod 'BottomSheet', :git => 'https://github.com/BiXtico/BottomSheet'
end
```

## Getting started

This repo contains [demo](https://github.com/joomcode/BottomSheet/tree/main/BottomSheetDemo), which can be a great start for understanding Bottom Sheet usage, but here are simple steps to follow:
1. Create `UIViewController` to present and set content's size by [preferredContentSize](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621476-preferredcontentsize) property
2. (optional) Conform to [ScrollableBottomSheetPresentedController](https://github.com/joomcode/BottomSheet/blob/81b0e2a7d405311b8456649452a8c49098490033/Sources/BottomSheet/Core/Presentation/BottomSheetPresentationController.swift#L12-L14) if your view controller is list-based
3. Present by using [presentBottomSheet(viewController:configuration:)](https://github.com/joomcode/BottomSheet/blob/1870921364ed2cd68d51d7e7837e16e692278ff5/Sources/BottomSheet/Core/Extensions/UIViewController%2BConvenience.swift#L79)

If you want to build flows, use `BottomSheetNavigationController`
```Swift
presentBottomSheetInsideNavigationController(
    viewController: viewControllerToPresent,
    configuration: .default
)
```

You can customize appearance passing configuration parameter
```Swift
presentBottomSheet(
    viewController: viewControllerToPresent,
    configuration: BottomSheetConfiguration(
        cornerRadius: 10,
        bottomSheetOrientation: .portrait,
        gestureInterceptView: viewController.gestureInterceptorView
    ),
    canBeDismissed: {
        // return `true` or `false` based on your business logic
        true
    },
    dismissCompletion: {
        // handle bottom sheet dismissal completion
    }
)
```
