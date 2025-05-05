//
//  SwiftUIView.swift
//  Parker-UI
//
//  Created by Gerald Zhao on 3/11/25.
//

import SwiftUI

struct MapView: View {

    var body: some View {
        VStack {
            Image("FakeMapForPlaceholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
        }
        
    }
}

#Preview {
    MapView()
}
