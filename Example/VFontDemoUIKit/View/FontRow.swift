//
//  FontRow.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 25.04.2022.
//

import UIKit
import VFont

final class FontRow: UITableViewCell {
    
    static let id = "FontRow"
    
    @IBOutlet private weak var cardView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.backgroundColor = #colorLiteral(red: 0.621404469, green: 0.319699049, blue: 0.8131730556, alpha: 0.1002604167)
        cardView.layer.cornerRadius = 20
    }
    
    func configure(vFont: VFont) {
        titleLabel.text = vFont.name
        titleLabel.font = vFont.uiFont
        
        for axis in vFont.axes {
            let axisName = axis.value.name.lowercased()
            let label = AxisTagLabel(name: axisName)
            
            stackView.addArrangedSubview(label)
        }
    }
    
}
