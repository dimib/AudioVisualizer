//
//  AnalyzerViewModel.swift
//  AudioSpielplatz1
//
//  Created by Dimitri Brukakis on 02.07.23.
//

import Foundation
import Combine

class AnalyzerViewModel: ObservableObject {
    
    @Published var audioData: AudioAnalyzerData = .zero
    
    private let audioStreamManager = AudioStreamManager()
    private let audioAnalyzer = AudioAnalyzer()
    
    private var cancellables = Set<AnyCancellable>()
    
    func startAnalyze() {
        print("🎙️ start analyze")
        do {
            try audioStreamManager.setupCaptureSession()
            try audioAnalyzer.setupAnalyzer(audioStream: audioStreamManager.audioStream)
            
            audioAnalyzer.publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { error in
                }) { audioAnalyzerData in
                    self.audioData = audioAnalyzerData
                }
                .store(in: &cancellables)
            
            try audioStreamManager.start()
        } catch {
            print("☠️ analyzer not started, error=\(error)")
        }
    }
    
    func stopAnalyze() {
        print("🎙️ stop analyze")
        audioStreamManager.stop()
    }
    
    init() {
        Task {
            await audioStreamManager.requestAuthorization()
        }
    }
}
