//
//  StreamRecordingManager.swift
//  AudioSpielplatz1
//
//  Created by Dimitri Brukakis on 10.06.23.
//

import Foundation
import AVFoundation
import Combine

final class AudioStreamManager: NSObject, ObservableObject {

    /// Our audio stream configuration.
    var config: AudioStreamManagerConfig?
    
    /// `AudioStreamManagerState` can be used to provide information about
    /// what's happening in the UI.
    ///
    /// - idle: The AudioStreamManager does nothing. Just show a start / record button.
    /// - streaming: TheAudioStreamManager captures audio.
    /// - error: Something went wrong
    enum AudioStreamManagerState {
        case idle
        case streaming(sampleTime: Int64)
        case error(message: String)
    }
    
    /// Our instance of the `AVAudioEngine` for streaming.
    private var audioEngine = AVAudioEngine()
    
    /// Get information about the audio format the `AVAudioEngine` provides us.
    var audioFormat: AVAudioFormat? {
        guard let config else { return nil }
        return audioEngine.inputNode.inputFormat(forBus: config.busIndex)
    }
    
    /// Publisher for the audio stream manager state. Can be used to show the streaming state or
    /// change buttons in our user infterface.
    @Published var audioStreamManagerState: AudioStreamManagerState = .idle
    
    /// Publisher for audio streams. The stream will be closed when the audio streaming
    /// is stopped and needs to be subscribed again.
    private var _audioStream: PassthroughSubject<AudioData, AudioManagerError>?
    var audioStream: AnyPublisher<AudioData, AudioManagerError> {
        guard let audioStream = _audioStream else {
            let audioStream = PassthroughSubject<AudioData, AudioManagerError>()
            _audioStream = audioStream
            return audioStream.eraseToAnyPublisher()
        }
        return audioStream.eraseToAnyPublisher()
    }
    
    /// Request authorization for using the microphone. This must be called once before any audiodata can
    /// be captured. The permission for audio recording remains for this App. Async function.
    func requestAuthorization() async -> Bool {
        await AudioAuthorization.awaitAuthorization
    }
    
    /// Setup an audio caputre session using the specified `AudioStreamManagerConfig` with information
    /// about the audio bus and data size. This function must be called before start capturing audio data.
    ///
    /// - parameter config: AudioStreamManagerConfig to be used.
    /// - returns  the `AVAudioFormat` for the capture session. Can also be requested later via `self.audioFormat`
    @discardableResult
    func setupCaptureSession(config: AudioStreamManagerConfig = .init()) throws -> AVAudioFormat {
        
        guard AudioAuthorization.isAuthorized else {
            throw AudioManagerError.notAuthorized
        }
        
        self.config = config

        let audioFormat = audioEngine.inputNode.inputFormat(forBus: config.busIndex)
        audioEngine.inputNode.installTap(onBus: config.busIndex, bufferSize: config.bufSize,
                                         format: audioFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            DispatchQueue.main.async {
                // Must change the published value on main thread
                self.audioStreamManagerState = .streaming(sampleTime: when.sampleTime)
            }
            self._audioStream?.send(AudioData(buffer: buffer, when: when))
        }
        return audioFormat
    }
    
    /// Start the audio engine and capture audio data.
    func start() throws {
        try audioEngine.start()
    }
    
    /// Stop capturing audio data. After stopping the session, all audio data subscribers
    /// receive a `completion(.finish)`.
    func stop() {
        guard let config = self.config else { return }
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: config.busIndex)
        _audioStream?.send(completion: .finished)
        _audioStream = nil
    }
}

// MARK: - Extension for AVAudioPCMBuffer

extension AVAudioPCMBuffer {
    
    /// Convert the PCM buffer to a Data object and copy the sample data.
    ///
    /// IMPORTANT: We need the `floatChannelData` because
    /// It contains the wave data as negative and positive samples that can easyly be displayed.
    ///
    var data: Data {
        let channelCount = 1
        let channels = UnsafeBufferPointer(start: self.floatChannelData, count: channelCount)
        let ch0data = NSData(bytes: channels[0],
                             length: Int(self.frameCapacity * self.format.streamDescription.pointee.mBytesPerFrame))
        return ch0data as Data
    }
}
