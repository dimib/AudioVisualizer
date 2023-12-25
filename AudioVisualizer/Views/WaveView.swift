//
//  WaveView.swift
//  AudioSpielplatz1
//
//  Created by Dimitri Brukakis on 21.06.23.
//

import SwiftUI

struct WaveView: View {
    
    let data: AudioAnalyzerData
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                drawMiddleLine(geometry.size)
                drawSamples(data.samples, geometry.size)
            }
            .border(Color.gray)
        }
    }
    
    private func drawMiddleLine(_ size: CGSize) -> some View {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: size.height / 2))
            path.addLine(to: CGPoint(x: size.width, y: size.height / 2))
        }
        .stroke(lineWidth: 2.0)
        .foregroundColor(.green)
    }
    
    private func drawSamples(_ samples: [Float], _ size: CGSize) -> some View {
        var posX: CGFloat = 0
        let step: CGFloat = CGFloat(size.width) / CGFloat(samples.count)
        let zeroY: CGFloat = CGFloat(size.height / 2)
        
        return Path { path in
            path.move(to: CGPoint(x: 0, y: zeroY))
            samples.forEach { sample in
                let posY = zeroY + (CGFloat(sample * 100))
                path.addLine(to: CGPoint(x: posX, y: min(max(0, posY), size.height)))
                posX += step
            }
        }
        .stroke(lineWidth: 0.5)
        .foregroundColor(.green)
    }
}

struct WaveView_Previews: PreviewProvider {
    
    static var randomSamples: [Float] {
        var samples: [Float] = []
        for _ in [0..<2055] {
            samples.append(Float.random(in: 0.001 ... 2.000) * -1)
            samples.append(Float.random(in: 0.001 ... 2.000))
        }
        return samples
    }
    
    static var previews: some View {
//        ContentView()
        WaveView(data: AudioAnalyzerData(min: -3.0, max: 1.0, time: 0, frameLength: 0, channelCount: 0, samples: randomSamples)).frame(width: 400, height: 200)
    }
}

