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
    @State private var narrationComplete = false  // ⬅️ Track if narration finished
    
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
            
            // ✅ Mark narration as complete after 55 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 55) {
                withAnimation {
                    narrationComplete = true
                }
            }
        } catch {
            print("Failed to start narration: \(error)")
        }
    }
    
    private func stopNarration() {
        narrationPlayer?.stop()
        narrationPlayer = nil
    }
    
    private func stopExperienceAndGoHome() {
        player.pause()
        stopNarration()
        HapticManger.instance.impact(style: .medium)
        appState.route = .home
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
                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.3)
                    .position(x: geo.size.width * 0.45, y: geo.size.height * 0.58)
                    .blendMode(.lighten)
                
                // Mountains
                Image("Mountain")
                    .frame(width: geo.size.width)
                    .position(x: geo.size.width * 0.56, y: geo.size.height * 0.82)
                    .allowsHitTesting(false)
                
                // ✅ Two buttons: Skip (always) + Continue (after narration)
                VStack {
                    HStack {
                        Button {
                            stopExperienceAndGoHome()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 44, height: 44)
                                .foregroundStyle(.white)
                                .background(
                                    Circle()
                                        .glassEffect(.clear)
                                        )
                                    }
                        .accessibilityLabel("Exit to Home")
                        .padding(.leading, 24)
                        .padding(.top, 60)
                                           
                        Spacer()
                        }.foregroundStyle(.black)
                                       
                    Spacer()
                    
                    HStack(spacing: 20) {
                        // Skip button (always visible, secondary style)
                        if !narrationComplete {
                            Button("Skip") {
                                stopNarration()
                                SoundManger.instance.stopBackgroundMusic()
                                appState.route = .nightExploration(journey)
                            }
                            .buttonStyle(.bordered)
                            .tint(.black)
                            .foregroundStyle(.white)
                            .glassEffect(.clear)
                        }
                        
                        // Continue button (appears after 55s, primary style)
                        if narrationComplete {
                            Button("Continue") {
                                stopNarration()
                                SoundManger.instance.stopBackgroundMusic()
                                appState.route = .nightExploration(journey)
                            }
                           // .buttonStyle(.borderedProminent)
                            .buttonStyle(.bordered)
                            .foregroundStyle(.white)
                            .background {
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.75, green: 0.25, blue: 0.2),
                                                 Color(red: 0.35, green: 0.12, blue: 0.1)
                                             ],
                                             startPoint: .leading,
                                             endPoint: .trailing
                                         )
                                         .opacity(0.25)
                                     )
                                     .glassEffect(.clear)
                             }
                            .transition(.scale.combined(with: .opacity))
                            //.glassEffect(.clear)
                        }
                    }
                    .padding(.bottom, 40)
                }
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
    // Sample Journey for preview
    let previewJourney = Journey(
        id: "preview-journey",
        title: "Red Horizon",
        description: "Mystery in the desert, light at the end",
        outline: "Some outline",
        subOutline: "Some subOutline",
        imageName: "RedSunMounten",
        scenes: [],
        items: [],
        requiredItemIDs: [],
        journeyRules: JourneyRules(
            softLimitSeconds: 480,
            hardLimitSeconds: 600,
            lostNoProgressSeconds: 120,
            graceVolumeMultiplier: 1.2,
            lostVolumeMultiplier: 1.6
        )
    )
    return DesertFireStoryView(journey: previewJourney)
        .environmentObject(AppState())
}
