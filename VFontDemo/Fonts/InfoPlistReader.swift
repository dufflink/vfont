//
//  InfoPlistReader.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 26.04.2022.
//

import Foundation

class InfoPlistReader {
    
    var infoPlistURL: URL? {
        return Bundle.main.url(forResource: "Info", withExtension: "plist")
    }
    
    func getFontNames() -> [String]? {
        guard let url = infoPlistURL else {
            print("Couldn't init Info.plist url")
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Couldn't get data from Info.plist")
            return nil
        }
        
        guard let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            print("Couldn't init property list from Info.plist data")
            return nil
        }
        
        guard let fontNames = dict["UIAppFonts"] as? [String], fontNames.count > 0 else {
            print("Couldn't get fonts info from Info.plist property list or the info is empty")
            return nil
        }
        
        return fontNames.map {
            let name = $0.split(separator: ".").first ?? ""
            return String(name)
        }
    }
    
}
