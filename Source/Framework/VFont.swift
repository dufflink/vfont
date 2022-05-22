//
//  VFont.swift
//  VFont
//
//  Created by Maxim Skorynin on 20.04.2022.
//

import SwiftUI

open class VFont {
    
    private(set) public var uiFont: UIFont
    
    private(set) public var name: String
    private(set) public var size: CGFloat
    
    private(set) public var axes: [Int: Axis]
    
    public var updated: ((UIFont?) -> Void)?
    
    public var variableFontName: String {
        return uiFont.fontName
    }
    
    // MARK: Life Cycle
    
    public init?(name: String, size: CGFloat) {
        guard let uiFont = UIFont(name: name, size: size) else {
            print("Couldn't init font \(name). Make sure you've added this font to the project. Please, check the font name is correct.")
            return nil
        }
        
        let ctFont = CTFontCreateWithName(uiFont.fontName as CFString, size, nil)
        
        guard let variationAxes = CTFontCopyVariationAxes(ctFont) as? [Any], !variationAxes.isEmpty else {
            print("This font \(uiFont.fontName) doesn't support variations")
            return nil
        }
        
        self.name = name
        self.size = size
        
        self.uiFont = uiFont
        
        self.axes = variationAxes.reduce(into: [Int: Axis]()) { result, axis in
            let axisDict = axis as? [String: Any] ?? [:]
            
            let attributes = axisDict.reduce(into: [Axis.AttrubuteName: Any]()) { result, attribute in
                if let key = Axis.AttrubuteName(rawValue: attribute.key) {
                    result[key] = attribute.value
                } else {
                    print("Couldn't parse the \(attribute.key) font attribute")
                }
            }
            
            let axis = Axis(attributes: attributes)
            result[axis.id] = axis
        }
    }
    
    // MARK: Public Functions
    
    public func setValue(_ value: CGFloat, forAxisID id: Int) {
        _setValue(value, axisID: id)
        
        updateFont()
        updated?(uiFont)
    }
    
    public func setValues(forAxes axes: [Int: CGFloat]) {
        axes.forEach { axisID, value in
            _setValue(value, axisID: axisID)
        }
        
        updateFont()
        updated?(uiFont)
    }
    
    public func getAxesDescription() -> String {
        var description = "Font - \(name)\n\n"
        description += "Axes:\n"
        
        axes.forEach {
            Mirror(reflecting: $0.value).children.forEach {
                description += "\($0.label ?? "No label"): \($0.value)\n"
            }
            
            description += "-----\n"
        }
        
        return description
    }
    
    // MARK: Private Functions
    
    private func _setValue(_ value: CGFloat, axisID: Int) {
        guard let axis = axes[axisID] else {
            print("This axis with '\(axisID)' id doesn't exist")
            return
        }
        
        axis.value = value
    }
    
    private func updateFont() {
        var variations = [Int: Any]()
        
        axes.forEach { axisID, axis in
            variations[axisID] = axis.value
        }
        
        let key = kCTFontVariationAttribute as UIFontDescriptor.AttributeName
        let uiFontDescriptor = UIFontDescriptor(fontAttributes: [.name: variableFontName, key: variations])
        
        uiFont = UIFont(descriptor: uiFontDescriptor, size: uiFont.pointSize)
    }
    
}

// MARK: - SwiftUI Support

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Font {
    
    static func vFont(_ name: String, size: CGFloat, axisID: Int, value: CGFloat) -> Font {
        let vFont = VFont(name: name, size: size)
        vFont?.setValue(value, forAxisID: axisID)
        
        let uiFont = vFont?.uiFont ?? .systemFont(ofSize: size)
        return Font(uiFont)
    }
    
    static func vFont(_ name: String, size: CGFloat, axes: [Int: CGFloat] = [:]) -> Font {
        let vFont = VFont(name: name, size: size)
        vFont?.setValues(forAxes: axes)
        
        let uiFont = vFont?.uiFont ?? .systemFont(ofSize: size)
        return Font(uiFont)
    }
    
}
