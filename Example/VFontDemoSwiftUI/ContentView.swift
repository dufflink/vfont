//
//  ContentView.swift
//  VFontDemoSwiftUI
//
//  Created by Maxim Skorynin on 11.05.2022.
//

import SwiftUI
import VFont

extension Font {
    
    static func martianMono(size: CGFloat, width: CGFloat = 0, weight: CGFloat = 0) -> Font {
        return Font.vFont("Martian Mono", size: size, axes: [
            2003072104: width,
            2003265652: weight
        ])
    }
    
}

struct ContentView: View {
    
    @State private var width = 75.0
    @State private var weight = 300.0
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .font(.vFont("Martian Mono", size: 16, axes: [
                    2003072104: width,
                    2003265652: weight
                ]))
            
            Text("Evil Martians")
                .padding()
                .font(.martianMono(size: 16, width: CGFloat(width), weight: CGFloat(weight)))
            
            Slider(value: $width, in: 75...112)
                .padding()
            Slider(value: $weight, in: 100...800)
                .padding()
        }
        .onAppear {
            let font = VFont(name: "Martian Mono", size: 12)!
            print(font.getAxesDescription())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

