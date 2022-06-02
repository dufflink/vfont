//
//  OrientationInfo.swift
//  VFontDemoSwiftUI
//
//  Created by Maxim Skorynin on 02.06.2022.
//

import UIKit

final class OrientationInfo: ObservableObject {
    
    enum Orientation: String {
        
        case portrait
        case landscape
        
    }
    
    @Published var orientation: Orientation
    
    private var _observer: NSObjectProtocol?
    
    init() {
        orientation = UIDevice.current.orientation.isLandscape ? .landscape : .portrait
        print(orientation)
        
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [weak self] note in
            guard let device = note.object as? UIDevice else {
                return
            }
            
            self?.orientation = device.orientation.isPortrait ? .portrait : .landscape
        }
    }
    
    deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
