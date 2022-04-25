//
//  ViewController.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 20.04.2022.
//

import UIKit
import VFont

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var vFont: VFont!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vFont = VFont(name: "Uncut Sans VF", size: 20.0)
        label.font = vFont?.uiFont
        
        print(vFont.axes)
        subscribe()
    }
    
    func subscribe() {
        vFont.updated = { [weak self] font in
            self?.label.font = font
        }
    }

    @IBAction func sliderValueDidChange(_ sender: Any) {
        let value = CGFloat(slider.value)
        vFont.setValue(value, axisID: 2003265652)
    }
    
}

// MARK: - Usecase example

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

