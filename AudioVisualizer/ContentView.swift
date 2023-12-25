//
//  ContentView.swift
//  AudioVisualizer
//
//  Created by Dimitri Brukakis on 25.12.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            AnalyzerView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 300, height: 200)
    }
}

#Preview {
    ContentView()
}
