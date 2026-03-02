//
//  SplashView.swift
//  Obour
//
//  Created by Deemah Alhazmi on 11/02/2026.

import SwiftUI
import AVKit

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var sunOpacity: Double = 0

    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()

            // 🌌 Moving stars background
            LoopingVideoView(videoName: "starsMoving", videoType: "mov")
                .ignoresSafeArea()
                .opacity(0.2)
                .blendMode(.lighten)

            Spacer()

            Image("Red")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.6)
                .opacity(sunOpacity)
                .ignoresSafeArea()

            // 🌅 Sun + Text
            VStack {
                Spacer()
                    .padding(25)

                Text("Where silence is heard")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .opacity(sunOpacity)

                Text("An experience to be lived, listened to, and seen.")
                    .foregroundStyle(.white.opacity(0.8))
                    .opacity(sunOpacity)

                Spacer()
                
                // Removed Start button for auto-dismiss
                // Keeping bottom padding for layout balance
                Color.clear.frame(height: 0)
                    .padding()
            }
        }
        .onAppear {
            // Fade in the sun/text
            withAnimation(.easeIn(duration: 1.5)) {
                sunOpacity = 1
            }
            // Automatically navigate after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                HapticManger.instance.impact(style: .medium)
                appState.route = .journeyV
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState())
}

// MARK: - Mock Journey (used for splash navigation & preview)
private let mockJourney = Journey(
    id: "preview",
    title: "Red Horizon",
    description: "Mystery in the desert, light at the end.",
    outline: "Some outline",
    subOutline: "Some subOutline",
    imageName: "RedSunMounten",
    scenes: [],
    journeyRules: JourneyRules(
        softLimitSeconds: 480,
        hardLimitSeconds: 600,
        lostNoProgressSeconds: 30,
        graceVolumeMultiplier: 1.2,
        lostVolumeMultiplier: 0.8
    )
)
