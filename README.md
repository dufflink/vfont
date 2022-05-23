[![Version](https://img.shields.io/badge/Version-0.6.1-red?style=flat-square)](https://img.shields.io/badge/Version-0.6.1-red?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-blue?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-blue?style=flat-square)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-compatible-orange?style=flat-square)](https://img.shields.io/badge/SwiftUI-compatible-orange?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-green?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-green?style=flat-square)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-green?style=flat-square)](https://img.shields.io/badge/Cocoapods-compatible-green?style=flat-square)

# VFont
<img width="250" height="100" src="https://user-images.githubusercontent.com/29461219/169861446-8ec49484-0fd5-40ea-a4fd-b255d6da9eca.gif"/>

<img align="right" height="160" width="160"
     title="VFont logo" src="https://user-images.githubusercontent.com/29461219/168282928-cd6bd7ea-12e0-4572-8a8b-2b65538edb03.svg">

`VFont` is a brilliant library which simplifies working with variable fonts in iOS projects. 

If you've never heard about variable fonts, I'd recommend reading this article [Variable fonts in real life: how to use and love them](https://evilmartians.com/chronicles/variable-fonts-in-real-life-how-to-use-and-love-them) by [@romashamin](https://github.com/romashamin)

<a href="https://evilmartians.com/">
  <img
    src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg"
    alt="Sponsored by Evil Martians"
    width="236"
    height="54"/> 
</a>

## What does the library make easier?

First of all, I wondered if variable fonts are supported in iOS. Nowadays, developers use the top-level `UIFont` class to work individually with Light, Regular, Medium, Bold, and other font styles. I discovered that VF support had already been added in `iOS 3.2`. However, it was implemented using low level code in the `CTFont` class in the `CoreText` library. This leads to extra work in order to get to variable fonts using `CoreText` and 'UIFont'.

## Usage
First, you need to add the custom variable font to your project. If you've never done this, I recommend reading this [tutorial](https://sarunw.com/posts/how-to-add-custom-fonts-to-ios-app). 
>❗️ Be aware that the font file name can be different from the actual font name! To get the correct full font name, upload the font file to [fontgauntlet.com](https://fontgauntlet.com/).
### Native instruments
```swift
// First, you have to get information about the variable font (axes names, IDs, and allowed values). But the current axis value isn't there 🤷‍♂️
// Here you can face a problem, like the custom font wasn't added to the project, was added incorrectly, or font name isn't correct
let uiFont = UIFont(name: "Martian Mono", size: 16.0)!
let ctFont = CTFontCreateWithName(uiFont.fontName as CFString, 16.0, nil)
let variationAxes = CTFontCopyVariationAxes(ctFont) as! [Any] // font information with weird format 👎

// To set new values you need to know the correct axis IDs and allowed values (maxValue and minValue)
let variations = [2003265652: 600, 2003072104: 100] // 2003265652 - 'Weight'; 2003072104 - `Width`

// As we know, text elements in UIKit use the UIFont class. So, you have to create new UIFont object with new values for axes
let uiFontDescriptor = UIFontDescriptor(fontAttributes: [.name: uiFont.fontName, kCTFontVariationAttribute as UIFontDescriptor.AttributeName: variations])
let newUIFont = UIFont(descriptor: uiFontDescriptor, size: uiFont.pointSize) 
// Now, you can apply the UIFont object for UI text elements
// Here you may notice the name of the new UIFont object has been changed to 'MartianMono-Regular_wght2580000_wdth640000'
let label = UILabel()
label.font = newUIFont
```
If you want to continue changing the current font object, or if you'd like to create more complex logic, you need to store the `UIFont` object. Moreover, you should parse the variation axes values and store these, too. But don't worry, `VFont` will do this for you!

### VFont library
#### UIKit
```swift
import VFont

let vFont = VFont(name: "Martian Mono", size: 16)! // UIFont like initialization
vFont.setValue(400, forAxisID: 2003265652) // setting a new value for the 'Weight' axis

let label = UILabel()
label.font = vFont.uiFont // apply the variable font for a UI text element
```
```swift
vFont.getAxesDescription() // get the font information with а human readable format, if you need it ✅

// override the `updated` closure to observe all font changes, if you're going to change it at runtime
vFont.updated = { uiFont in
    label.font = uiFont
}
```
#### SwiftUI
```swift
struct ContentView: View {

    var body: some View {
       Text("Title 1")
          .font(.vFont("Martian Mono", size: 16, axisID: 2003265652, value: 450))
       Text("Title 2")
           .font(.vFont("Inter", size: 32, axes: [2003072104: 80, 2003265652: 490])
    }
    
}
```
> Why do we use number IDs instead of axis names? Good question! But the answer is really simple. The `CTFont` framework which works with variable fonts under the hood returns different axis names for different system languages. This means that only the axis number IDs are unique values. If you find a way of receiving English names regardless of system language, I would appreciate knowing about this!

## Installation
### Swift Package Manager

- `File` > `Swift Packages` > `Add Package Dependency`
- Search `https://github.com/dufflink/vfont`
- Select `Up to Next Major` with `0.6.1`

### Cocoapods

To integrate `VFont` to your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Vfont'
```

## Advanced usage
If you use UIKit, you can create your own font class inheriting the VFont class!

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
In a SwiftUI project you can create `static method` as a `Font` structure extension:
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
## Examples
Go to [Examples] folder and research how does it work! Also, you can lanch the examples in Xcode. To complete this, clone the repository and launch the `VFont.xcworkspace` file.

https://user-images.githubusercontent.com/29461219/167891461-f3c9a035-9d36-4e93-8a47-0a02ed1b0007.mp4

## Roadmap
- The next step is creating a script that will parse the `Info.plist` file and which will automatically generate the font classes for UIKit and the extensions for SwiftUI. The generated code will have the same structure as in the [Font class](https://github.com/dufflink/vfont/edit/master/README.md#font-class) section abowe.

- Support for tvOS, watchOS, and macOS

## License
VFont is released under the MIT license. [See LICENSE](https://github.com/dufflink/vfont/blob/master/LICENSE.md) for details.
