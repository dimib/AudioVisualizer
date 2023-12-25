//
//  AnalyzerView.swift
//  AudioSpielplatz1
//
//  Created by Dimitri Brukakis on 27.06.23.
//

import SwiftUI
import Combine

struct AnalyzerView: View {

    @StateObject var viewModel = AnalyzerViewModel()
    
    var body: some View {
        VStack {
            WaveView(data: viewModel.audioData)
                .frame(minHeight: 120)
            VolumeView(data: viewModel.audioData)
                .frame(height: 40)
            HStack {
                Button(action: { viewModel.startAnalyze() }) {
                    Text("Start Analyze")
                }
                Button(action: { viewModel.stopAnalyze() }) {
                    Text("Stop Analyze")
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}

struct AnalyzerView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzerView()
            .frame(width: 300, height: 100)
    }
}
