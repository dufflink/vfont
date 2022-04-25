//
//  Axis.swift
//  VFont
//
//  Created by Maxim Skorynin on 20.04.2022.
//

import CoreGraphics

extension Axis {
    
    public enum AttrubuteName: String {
        
        case id = "NSCTVariationAxisIdentifier"
        case name = "NSCTVariationAxisName"
                
        case maxValue = "NSCTVariationAxisMaximumValue"
        case minValue = "NSCTVariationAxisMinimumValue"
        
        case defaultValue = "NSCTVariationAxisDefaultValue"
        
    }
    
}

public class Axis {
    
    public let id: Int
    public let name: String
    
    public let minValue: CGFloat
    public let maxValue: CGFloat
    
    public let defaultValue: CGFloat
    
    public var value: CGFloat
    
    init(attributes: [AttrubuteName: Any]) {
        self.id = attributes[.id] as? Int ?? 0
        self.name = attributes[.name] as? String ?? "unknown"
        
        self.minValue = attributes[.minValue] as? CGFloat ?? 0.0
        self.maxValue = attributes[.maxValue] as? CGFloat ?? 0.0
        
        self.defaultValue = attributes[.defaultValue] as? CGFloat ?? 0.0
        self.value = defaultValue
    }
    
}
