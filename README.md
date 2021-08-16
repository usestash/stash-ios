## StashAnalytics
# StashAnalytics Swift SDK

[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/cocoapods/p/StashAnalytics.svg)](https://cocoapods.org/pods/StashAnalytics)
[![License](https://img.shields.io/cocoapods/l/StashAnalytics.svg)](https://raw.githubusercontent.com/usestash/StashAnalytics/master/LICENSE)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/StashAnalytics.svg)](https://cocoapods.org/pods/StashAnalytics)

This is the first version of the StashAnalytics iOS Swift SDK. It is still under beta. Pull requests and improvement suggestions are welcome.

## Content
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Requirements

- iOS 14.0+
- Xcode 12.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.10.0+ is required to build StashAnalytics 0.0.1+.

To integrate StashAnalytics into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '14.0'
use_frameworks!

pod 'StashAnalytics', '~> 0.0.1'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate StashAnalytics into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "usestash/stash-ios" ~> 0.0.1
```
### Swift Package Manager

To use StashAnalytics as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
import PackageDescription

let package = Package(
    name: "HelloStashAnalytics",
    dependencies: [
        .Package(url: "https://github.com/usestash/stash-ios.git", "0.0.1")
    ]
)
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate StashAnalytics into your project manually.

#### Git Submodules

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add StashAnalytics as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/usestash/stash-ios.git
$ git submodule update --init --recursive
```

- Open the new `StashAnalytics` folder, and drag the `StashAnalytics.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `StashAnalytics.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `StashAnalytics.xcodeproj` folders each with two different versions of the `StashAnalytics.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from.

- Select the `StashAnalytics.framework`.

- And that's it!

> The `StashAnalytics.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

## Usage

## License

StashAnalytics is released under the MIT license. See [LICENSE](https://github.com/usestash/stash-ios/blob/master/LICENSE) for details.
