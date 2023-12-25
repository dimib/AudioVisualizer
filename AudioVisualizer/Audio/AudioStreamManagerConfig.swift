//
//  AudioStreamManagerConfig.swift
//  AudioSpielplatz1
//
//  Created by Dimitri Brukakis on 27.06.23.
//

import Foundation
import AVFoundation

struct AudioStreamManagerConfig {
    let busIndex: AVAudioNodeBus
    let bufSize: AVAudioFrameCount
    
    init(busIndex: AVAudioNodeBus = 0, bufSize: AVAudioFrameCount = AVAudioFrameCount(4096)) {
        self.busIndex = busIndex
        self.bufSize = bufSize
    }
}
