//
//  AxisRow.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 25.04.2022.
//

import UIKit
import VFont

protocol AxisRowDelegate: AnyObject {
    
    func axisDidChange(_ axis: Axis, value: CGFloat)
    
}

final class AxisRow: UITableViewCell {
        
    static let id = "AxisRow"
    
    weak var delegate: AxisRowDelegate?
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var slider: UISlider!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    @IBOutlet private weak var maxValueLabel: UILabel!
    @IBOutlet private weak var minValueLabel: UILabel!
    
    private var axis: Axis?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.backgroundColor = #colorLiteral(red: 0.621404469, green: 0.319699049, blue: 0.8131730556, alpha: 0.1002604167)
        cardView.layer.cornerRadius = 20
    }
    
    func configure(axis: Axis) {
        let minValue = Float(axis.minValue)
        let maxValue = Float(axis.maxValue)
        let value = Float(axis.value)
        
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.setValue(value, animated: true)
        
        minValueLabel.text = String(Int(minValue))
        maxValueLabel.text = String(Int(maxValue))
        valueLabel.text = String(Int(value))
        
        titleLabel.text = axis.name
        self.axis = axis
    }
    
    @IBAction func sliderValueDidChange(_ sender: Any) {
        guard let axis = axis else {
            return
        }
        
        valueLabel.text = String(Int(slider.value))
        delegate?.axisDidChange(axis, value: CGFloat(slider.value))
    }
    
}
