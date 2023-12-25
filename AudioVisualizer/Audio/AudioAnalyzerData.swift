//
//  AudioAnalyzerData.swift
//  AudioSpielplatz1
//
//  Created by Dimitri Brukakis on 19.06.23.
//

import Foundation
import AVFoundation

/// `AudioAnalyzerData` structure.
///
/// We use this to calculate minimum and maximum volume values of an `AudioData` buffer.
/// This is just for visualization.
struct AudioAnalyzerData {
    let min: Float
    let max: Float
    let time: Int64
    let frameLength: AVAudioFrameCount
    let channelCount: AVAudioChannelCount
    let samples: [Float]
    
    static var zero = AudioAnalyzerData(min: 0, max: 0, time: 0, frameLength: 0, channelCount: 0, samples: [])
    
    var debugDescription: String {
        "\(time) channels=\(channelCount) length=\(frameLength) min=\(min) max=\(max)"
    }
    
    init(min: Float, max: Float, time: Int64, frameLength: AVAudioFrameCount, channelCount: AVAudioChannelCount, samples: [Float]) {
        self.min = min
        self.max = max
        self.time = time
        self.frameLength = frameLength
        self.channelCount = channelCount
        self.samples = samples
    }
    
    init(audioData: AudioData) {
        self.time = audioData.when.sampleTime
        self.frameLength = audioData.buffer.frameLength
        self.channelCount = audioData.buffer.format.channelCount
        
        guard let samples = audioData.samples else {
            self.min = 0
            self.max = 0
            self.samples = []
            return
        }
        let minmax: (Float, Float) = samples.reduce((0, 0)) { result, value in
            let minValue = Swift.min(result.0, value)
            let maxValue = Swift.max(result.1, value)
            return (minValue, maxValue)
        }
        
        self.min = minmax.0
        self.max = minmax.1
        self.samples = samples
    }
}
