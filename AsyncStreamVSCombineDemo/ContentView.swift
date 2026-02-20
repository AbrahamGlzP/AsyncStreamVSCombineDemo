//
//  ContentView.swift
//  AsyncStreamVSCombineDemo
//
//  Created by Abraham Gonzalez Puga on 19/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CombineView()
                .tabItem {
                    Label("Combine", systemImage: "arrow.triangle.merge")
                }
            AsyncStreamView()
                .tabItem {
                    Label("AsyncStream", systemImage: "arrow.triangle.2.circlepath")
                }
        }
    }
}

#Preview {
    ContentView()
}
