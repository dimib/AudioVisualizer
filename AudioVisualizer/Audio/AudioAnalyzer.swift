//
//  AudioAnalyzer.swift
//  AudioSpielplatz1
//
//  Created by Dimitri Brukakis on 19.06.23.
//

import Foundation
import Combine
import AVFoundation

// Notes:
// Sample audio engine
// https://github.com/maysamsh/avaudioengine/tree/main/audioEngine
// Visualize
// https://karenxpn.medium.com/audio-visualization-using-swift-swiftui-ffbf9aa8d577
final class AudioAnalyzer {
    
    private var cancellable: AnyCancellable?
    
    private let _analyzerValues = PassthroughSubject<AudioAnalyzerData, Never>()
    var publisher: AnyPublisher<AudioAnalyzerData, Never> {
        _analyzerValues.eraseToAnyPublisher()
    }
    
    func setupAnalyzer(audioStream: AnyPublisher<AudioData, AudioManagerError>) throws {
    
        cancellable = audioStream.sink(
            receiveCompletion: { error in
                self.cleanup()
            }, receiveValue: { audioData in
                let analyzerData = AudioAnalyzerData(audioData: audioData)
                self._analyzerValues.send(analyzerData)
            })
    }
    
    private func cleanup() {
        self._analyzerValues.send(.zero)
        cancellable = nil
    }
}
