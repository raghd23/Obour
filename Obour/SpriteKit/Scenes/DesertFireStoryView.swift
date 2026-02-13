//
//  DesertFireStoryView.swift
//  Obour
//
//  Created by Raghad Alzemami on 25/08/1447 AH.
//


import SwiftUI
import AVKit
import AVFoundation

struct DesertFireStoryView: View {
    @EnvironmentObject var appState: AppState
    let journey: Journey
    
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
            print("Narration file not found")
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
                // Background
                Image("backgroundScene")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Fire video
                LoopingVideoView(videoName: "fire", videoType: "mp4")
                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.3) // ⬅️ Size it smaller!
                    .position(x: geo.size.width * 0.45, y: geo.size.height * 0.58)
                    .blendMode(.lighten)
                
                // Mountains
                Image("Mountain")
                //    .resizable()
                    .frame(width: geo.size.width)
                    .position(x: geo.size.width * 0.56,
                              y: geo.size.height * 0.82)
                    .allowsHitTesting(false)
                
                // ✅ Button to finish and go back
//                VStack {
//                    Spacer()
//                    Button("Continue Journey") {
//                        stopNarration()
//                        appState.route = .collection // or .journeyOutro(journey)
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .padding(.bottom, 40)
//                }
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
