# VFont
[![Version](https://img.shields.io/badge/Version-0.5.0-red?style=flat-square)](https://img.shields.io/badge/Version-0.5.0-red?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-blue?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-blue?style=flat-square)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-compatible-orange?style=flat-square)](https://img.shields.io/badge/SwiftUI-compatible-orange?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-green?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-green?style=flat-square)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-green?style=flat-square)](https://img.shields.io/badge/Cocoapods-compatible-green?style=flat-square)

`VFont` is a simple library allowing to work with variable fonts in iOS projects. 

If you've never heard about the variable fonts, I would recommend reading this article [Variable fonts in real life: how to use and love them](https://evilmartians.com/chronicles/variable-fonts-in-real-life-how-to-use-and-love-them) written by [@romashamin](https://github.com/romashamin)

[[Demo app video](https://user-images.githubusercontent.com/29461219/167891461-f3c9a035-9d36-4e93-8a47-0a02ed1b0007.mp4)]

## What does the library make easier?

First of all, I wondered if variable fonts are supported in iOS? Nowadays, developers use the top-level `UIFont` class to work individually with Light, Regular, Medium, Bold, and other font variations. But `UIFont` can't work with the variable fonts natively!

As I found out, their support has already been added in `iOS 3.2`. But it has done at a lower level in the `CTFont` class in the `CoreText` library. It takes a ton of work to get to variable fonts in `CoreText`.

#### Parsing and saving of a variable font information

```swift
guard let uiFont = UIFont(name: name, size: size) else { // here you can face the problem, that custom font wasn't added to the project, was added incorrectly, or font name isn't correct
    return
}

let ctFont = CTFontCreateWithName(uiFont.fontName as CFString, size, nil)

guard let variationAxes = CTFontCopyVariationAxes(ctFont) as? [Any] else { // not all fonts are variable
    return nil
}
```
The font information consists objects like those, where each object is variation axis.

```swift
/*
{
    NSCTVariationAxisDefaultValue = 400;
    NSCTVariationAxisIdentifier = 2003265652;
    NSCTVariationAxisMaximumValue = 800;
    NSCTVariationAxisMinimumValue = 100;
    NSCTVariationAxisName = "Weight";
}
*/
```
Next we have to convert the structure into the `Axis` array and store it. `Axis` is the custom class which allows to work with axes as with objects. This is really important, because each variation axis has its own name, parameters and allowed values.
```swift
public class Axis {
    
    public let id: Int
    public let name: String
    
    public let minValue: CGFloat
    public let maxValue: CGFloat
    
    public let defaultValue: CGFloat
    
    public var value: CGFloat
    ...
}
```
#### Axis updating

Everytime, when we want to update an variation axis, we literaly have to copy the old font with new axis values. To apply new variation UIKit and SwiftUI use different basic classes UIFont and CTFont respectively. So it must be taken into account!

```swift
private func updateFont() {
    var variations = [Int: Any]()

    axes.forEach { axisID, axis in
        variations[axisID] = axis.value
    }

    let key = kCTFontVariationAttribute as UIFontDescriptor.AttributeName
    
    // UIFont updating for UIKit

    let uiFontDescriptor = UIFontDescriptor(fontAttributes: [.name: variableFontName, key: variations])
    uiFont = UIFont(descriptor: uiFontDescriptor, size: uiFont.pointSize)
    
    // CTFont updating fot SwiftUI

    let originalCTFontDescriptor = CTFontCopyFontDescriptor(ctFont) as CTFontDescriptor
    let ctFontAttributes = [key: variations] as CFDictionary

    let ctFontDescriptor = CTFontDescriptorCreateCopyWithAttributes(originalCTFontDescriptor, ctFontAttributes)
    ctFont = CTFont(ctFontDescriptor, size: size)
}
```

As you could see, the proccess doesn't look simple. But don't worry, the VFont library was created to simplify it. Move on to the [Instalation](https://github.com/dufflink/vfont/edit/master/README.md#installation) section and learn more about the library power in the [Usage](https://github.com/dufflink/vfont/edit/master/README.md#usage) section!

## Installation
### Swift Package Manager

- `File` > `Swift Packages` > `Add Package Dependency`
- Search `https://github.com/dufflink/vfont`
- Select `Up to Next Major` with `0.5.0`

### Cocoapods

To integrate `VFont` to your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Vfont'
```

## Usage
#### Preparing
First, you need to add the custom variable font to your project. If you've never done it, I would recommend reading this [tutorial](https://sarunw.com/posts/how-to-add-custom-fonts-to-ios-app).

### UIKit
#### Initialization
To initialize a new `VFont` object, use its own full font name and size value.
> ❗️ Be aware of the font file name can be different from the actual font name! To get the correct full font name upload the font file to the [fontgauntlet.com](https://fontgauntlet.com/).
```swift
import VFont

let vFont = VFont(name: "Martian Mono", size: 16)!

let label = UILabel()
label.font = vFont.uiFont
```

#### Font information
Use `getAxesDesciption()` to get font information: axis IDs and allowed values
```swift
vFont.getAxesDescription()
```
<details>
  <summary>Click to show the full font information which appears in the Xcode Console</summary>
  
  ```swift
let vFontInfo = vFont.getAxesDescription()
print(vFontInfo)

/*
Font - Martian Mono

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
</details>

#### Set new axis value
```swift
vFont.setValue(400, axisID: 2003265652) // 2003265652 - Weight axis ID
```
> Why do we use number IDs instead of axis names? Good question! But the answer is really simple. The `CTFont` framework which works with the variable fonts under the hood returns different axis names for different system languages. It means that only the axis number IDs are unique values. If you find the way how to receive English names regardless of system language, I will appreciate this!

#### Font updating
Override the `updated` closure to setup new `VFont` variation after his updating. The clouser returns new `UIFont` object.
```swift
vFont.updated = { uiFont in
    label.font = uiFont
}
```

### SwiftUI
```swift
import VFont

struct ContentView: View {
    
    @State private var width = 75.0
    @State private var weight = 300.0
    
    var body: some View {
        VStack {
            Text("Evil Martians")
                .font(.vFont("Martian Mono", size: 20, axes: [
                    2003072104: CGFloat(width),
                    2003265652: CGFloat(weight)
                ]))
        }
    }
}
```
## Advanced usage
If you use UIKit, you can create your own font class inheriting the Vfont class!

### UIKit

```swift
import VFont

final class MartianMono: VFont {
    
    init?(size: CGFloat) {
        super.init(name: "Martian Mono", size: size)
    }
    
    var weight: CGFloat {
        get {
            return axes[2003265652]?.value ?? .zero
        } set {
            setValue(newValue, axisID: 2003265652)
        }
    }
    
    var width: CGFloat {
        get {
            return axes[2003072104]?.value ?? .zero
        } set {
            setValue(newValue, axisID: 2003072104)
        }
    }
    
}
```
```swift
let font = MartianMono(size: 16)
        
font?.weight = 300
font?.width = 90
```
### SwiftUI
In a SwiftUI project you can create `static method` as a `Font` structure extension
```swift
extension Font {
    
    static func martianMono(size: CGFloat, width: CGFloat = 0, weight: CGFloat = 0) -> Font {
        return Font.vFont("Martian Mono", size: size, axes: [
            2003072104: width,
            2003265652: weight
        ])
    }
    
}
```
```swift
struct ContentView: View {
    
    var body: some View {
        Text("Hello, world!")
            .font(.martianMono(size: 16, width: 300, weight: 100))
    }
    
}
```
## Roadmap
- Next step is creating a script which will parse the `Info.plist` file and will generate the font classes for UIKit and the extensions for SwiftUI automatically. The generated code are going to have the same structure like in the [Font class](https://github.com/dufflink/vfont/edit/master/README.md#font-class) section abowe.

- Support tvOS, watchOS and macOS

## License
VFont is released under the MIT license. [See LICENSE](https://github.com/dufflink/vfont/blob/master/LICENSE.md) for details.
