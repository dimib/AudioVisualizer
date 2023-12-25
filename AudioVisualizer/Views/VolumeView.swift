//
//  VolumeView.swift
//  AudioSpielplatz1
//
//  Created by Dimitri Brukakis on 19.06.23.
//

import SwiftUI

struct VolumeView: View {
    
    let data: AudioAnalyzerData
    let max: Float
    
    var volumeWidth: CGFloat {
        min(200, CGFloat(data.max) * 255)
    }
    
    func volumeWidth(max: CGFloat) -> CGFloat {
        min(max, CGFloat(data.max) * 500)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path  in
                    path.move(to: CGPoint(x: 5, y: 5))
                    path.addLine(to: CGPoint(x: volumeWidth(max: geometry.size.width), y: 5))
                    path.addLine(to: CGPoint(x: volumeWidth(max: geometry.size.width), y: geometry.size.height - 5))
                    path.addLine(to: CGPoint(x: 5, y: geometry.size.height - 5))
                    path.addLine(to: CGPoint(x: 5, y: 5))
                }
                .fill(Color.green)
                
                Text("\(data.max)")
                    .font(.title)
            }
            .background(Color.black)
            .border(Color.gray)
        }
    }
    
    init(data: AudioAnalyzerData, max: Float = 0) {
        self.data = data
        self.max = max
    }
}


