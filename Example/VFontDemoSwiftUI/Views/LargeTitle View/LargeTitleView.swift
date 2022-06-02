//
//  LargeTitleView.swift
//  VFontDemoSwiftUI
//
//  Created by Maxim Skorynin on 02.06.2022.
//

import SwiftUI
import VFont

struct LargeTitleView: View {
    
    @EnvironmentObject var orientationInfo: OrientationInfo
    
    var body: some View {
        VStack {
            let orientation = orientationInfo.orientation
            
            HStack {
                Text("Large title with few rows")
                    .font(.martianMono(size: 42,
                        width: orientation == .landscape ? 112 : 90,
                        weight: 800))
                    .padding(orientation == .landscape ? [.top, .leading] : [.horizontal, .top])
                Spacer()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

struct LargeTitleView_Previews: PreviewProvider {
    static var previews: some View {
        LargeTitleView()
            .environmentObject(OrientationInfo())
    }
}
