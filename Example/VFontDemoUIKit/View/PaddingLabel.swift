//
//  PaddingLabel.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 25.04.2022.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 6
    @IBInspectable var bottomInset: CGFloat = 6
    
    @IBInspectable var leftInset: CGFloat = 8
    @IBInspectable var rightInset: CGFloat = 8
    
    // MARK: Life Cycle
    
    convenience init(topInset: CGFloat, bottomInset: CGFloat, leftInset: CGFloat, rightInset: CGFloat) {
        self.init()
        
        self.topInset = topInset
        self.bottomInset = bottomInset
        
        self.leftInset = leftInset
        self.rightInset = leftInset
    }
    
    // MARK: Overridable Functions

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}
