//
//  DesertScene.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import SwiftUI
import AVKit
import AVFoundation

struct TravellerStroySceneView: View {

    @State private var player: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "fire", withExtension: "mp4") else {
            return AVPlayer()
        }
        let p = AVPlayer(url: url)
        p.actionAtItemEnd = .none
        p.isMuted = true
        return p
    }()

    @State private var narrationPlayer: AVAudioPlayer?

    private func startNarration() {
        guard let url = Bundle.main.url(forResource: "Traveller story", withExtension: "wav") else {
            print("Narration file not found: Traveller story.wav")
            return
        }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = 0
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            narrationPlayer = audioPlayer
        } catch {
            print("Failed to start narration: \(error)")
        }
    }

    private func stopNarration() {
        narrationPlayer?.stop()
        narrationPlayer = nil
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 1) Background image
                Image("backgroundScene")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // 2) Fire video (above background)
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .onAppear {
                        player.play()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
                        player.seek(to: .zero)
                        player.play()
                    }
                    .blendMode(.lighten)
                    .position(x: geo.size.width * 0.45,
                              y: geo.size.height * 0.58)

                // 3) Mountains image - positioned relative to fire
                Image("Mountain")
                    .resizable()
                   // .scaledToFit()
                    .frame(width: geo.size.width)
                    .position(x: geo.size.width * 0.56,
                              y: geo.size.height * 0.82) // adjust this percentage to move up/down
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea()
            .onAppear {
                startNarration()
            }
            .onDisappear {
                player.pause()
                stopNarration()
            }
        }
    }
}


#Preview {
    TravellerStroySceneView()
}
