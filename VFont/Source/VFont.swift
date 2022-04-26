//
//  VFont.swift
//  VFont
//
//  Created by Maxim Skorynin on 20.04.2022.
//

import UIKit

open class VFont {
    
    private(set) public var uiFont: UIFont
    private(set) public var axes: [Int: Axis]
    
    public var updated: ((UIFont?) -> Void)?
    
    public var name: String
    
    public var variableFontName: String {
        return uiFont.fontName
    }
    
    // MARK: Life Cycle
    
    public init?(name: String, size: CGFloat) {
        guard let uiFont = UIFont(name: name, size: size) else {
            print("Couldn't init font. Make sure you've added font to project. Please, check the font name is correct.")
            return nil
        }
        
        let ctFont = CTFontCreateWithName(uiFont.fontName as CFString, size, nil)
        
        guard let variationAxes = CTFontCopyVariationAxes(ctFont) as? [Any], !variationAxes.isEmpty else {
            print("This font dosn't support variations")
            return nil
        }
        
        self.name = name
        self.uiFont = uiFont
        
        self.axes = variationAxes.reduce(into: [Int: Axis]()) { result, axis in
            let axisDict = axis as? [String: Any] ?? [:]
            
            let attributes = axisDict.reduce(into: [Axis.AttrubuteName: Any]()) { result, attribute in
                if let key = Axis.AttrubuteName(rawValue: attribute.key) {
                    result[key] = attribute.value
                } else {
                    print("Couldn't parse \(attribute.key) font attribute")
                }
            }
            
            let axis = Axis(attributes: attributes)
            result[axis.id] = axis
        }
    }
    
    // MARK: Public Functions
    
    public func setValue(_ value: CGFloat, axisID: Int) {
        guard let axis = axes[axisID] else {
            print("This axis with \(axisID) id doesn't exist")
            return
        }
        
        axis.value = value
        
        updateFont()
        updated?(uiFont)
    }
    
    public func getAxesDescription() -> String {
        var description = "Font - \(uiFont.fontName)\n\n"
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
    
    private func updateFont() {
        var variations = [Int: Any]()
        
        axes.forEach { axisID, axis in
            variations[axisID] = axis.value
        }
        
        let key = kCTFontVariationAttribute as UIFontDescriptor.AttributeName
        let fontDescriptor = UIFontDescriptor(fontAttributes: [.name: uiFont.fontName, key: variations])
        
        uiFont = UIFont(descriptor: fontDescriptor, size: uiFont.pointSize)
    }
    
}

