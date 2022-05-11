# VFont
[![Version](https://img.shields.io/badge/Version-0.4.1-red?style=flat-square)](https://img.shields.io/badge/Version-0.4.1-red?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-blue?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-blue?style=flat-square)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-compatible-orange?style=flat-square)](https://img.shields.io/badge/SwiftUI-compatible-orange?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-green?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-green?style=flat-square)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-green?style=flat-square)](https://img.shields.io/badge/Cocoapods-compatible-green?style=flat-square)

VFont is a simple library to work with variable fonts in iOS projects.

## Installation
### Swift Package Manager

- `File` > `Swift Packages` > `Add Package Dependency`
- Search `https://github.com/dufflink/vfont`
- Select `Up to Next Major` with `0.4.1`

### Cocoapods

To integrate `VFont` to your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Vfont'
```
## Usage
### Preparing
First, you need to add the custom variable font to your project. You can use this [tutorial](https://sarunw.com/posts/how-to-add-custom-fonts-to-ios-app).

> ❗️ Be aware of the font file name can be different from the actual font name!
### UIKit
#### Initialization
```swift
import VFont

let vFont = VFont(name: "Martian Mono", size: 16)!

let label = UILabel()
label.font = vFont.uiFont
```
#### Set new axis value
```swift
vFont.setValue(400, axisID: 2003265652) // 2003265652 - Weight axis ID
```

#### Updating
Override the `updated` closure to setup new `VFont` variation after his updating. The clouser returns new `UIFont` object.
```swift
vFont?.updated = { uiFont in
    label.font = uiFont
}
```
#### Font information
Use `getAxesDesciption()` to get font information: axis IDs and allowed values
```swift
vFont.getAxesDescription()

/*
Font - MartianMono-Regular

Axes:
id: 2003265652
name: Weight
minValue: 100.0
maxValue: 800.0
defaultValue: 400.0
value: 400.0
-----
id: 2003072104
name: Width
minValue: 75.0
maxValue: 112.5
defaultValue: 112.5
value: 112.5
-----
*/
```
### SwiftUI
```swift
import VFont

struct ContentView: View {
    
    @State private var width: CGFloat = 75.0
    @State private var weight: CGFloat = 100.0
    
    private let font = VFont(name: "Martian Mono", size: 20)!
    
    var body: some View {
        VStack {
            Text("Evil Martians")
                .font(.init(vFont: font, value: width, axisID: 2003072104))
            
            // or init with axis array
            
            Text("Hello, world!")
                .font(.init(vFont: font, axes: [
                    2003072104: width,
                    2003265652: weight
                ]))
        }
    }
}
```
## Demo UIKit
https://user-images.githubusercontent.com/29461219/167891461-f3c9a035-9d36-4e93-8a47-0a02ed1b0007.mp4

## License
VFont is released under the MIT license. [See LICENSE](https://github.com/dufflink/vfont/blob/master/LICENSE.md) for details.
