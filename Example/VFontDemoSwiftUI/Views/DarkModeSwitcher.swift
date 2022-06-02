//
//  DarkModeSwitcher.swift
//  VFontDemoSwiftUI
//
//  Created by Maxim Skorynin on 01.06.2022.
//

import SwiftUI
import VFont

struct DarkModeSwitcher: View {
    
    @State var isDark = false
    @State var textColor = Color.black
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if isDark {
                Circle()
                    .matchedGeometryEffect(id: "shape", in: namespace)
                    .frame(width: 3000, height: 5000)
                    .position(x: 0, y: -40)
            } else {
                Circle()
                    .matchedGeometryEffect(id: "shape", in: namespace)
                    .frame(width: 1, height: 1)
                    .position(x: 0, y: -40)
            }
            
            Text("Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .padding()
                .font(.martianMono(size: 30, width: 100, weight: isDark ? 700 : 800))
                .foregroundColor(.white)
                .colorMultiply(textColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.6)) {
                isDark.toggle()
                textColor = isDark ? .white : .black
            }
        }
    }
    
}

struct DarkModeSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        DarkModeSwitcher()
    }
}
