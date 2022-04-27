//
//  ContentView.swift
//  VFontDemoSwiftUI
//
//  Created by Maxim Skorynin on 27.04.2022.
//

import SwiftUI
import VFont

struct ContentView: View {
    
    @State private var widthAxisValue = 0.0
    @State private var weightAxisValue = 0.0
    
    private let font = VFont(name: "Martian Mono", size: 20)!
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
                .font(.init(vFont: font, axes: [
                    2003072104: CGFloat(widthAxisValue),
                    2003265652: CGFloat(weightAxisValue)
                ]))
            
            Slider(value: $widthAxisValue, in: 75...112)
                .padding()
            Slider(value: $weightAxisValue, in: 100...800)
                .padding()
        }
        .onAppear {
            print(font.getAxesDescription())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
