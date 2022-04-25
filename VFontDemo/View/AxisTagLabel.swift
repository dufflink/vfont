//
//  AxisTagLabel.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 25.04.2022.
//

final class AxisTagLabel: PaddingLabel {
    
    convenience init(name: String) {
        self.init()
        text = name
        
        textColor = .white
        backgroundColor = #colorLiteral(red: 0.621404469, green: 0.319699049, blue: 0.8131730556, alpha: 1)
        
        layer.masksToBounds = true
        layer.cornerRadius = 4
        
        font = .systemFont(ofSize: 14, weight: .semibold)
        
        topInset = 2
        bottomInset = 2
        
        leftInset = 4
        rightInset = 4
    }
    
}
