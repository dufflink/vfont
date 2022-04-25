//
//  Generated.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 25.04.2022.
//

import CoreGraphics
import VFont

class Zerif: VFont {
    
    public init(size: CGFloat) {
        super.init(name: "Zvin Serif", size: size)!
    }
    
    public var weight: CGFloat {
        get {
            return axes[2003265652]?.value ?? .zero
        } set {
            setValue(newValue, axisID: 2003265652)
        }
    }
    
}
