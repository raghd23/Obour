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
    @State private var blackOverlayOpacity: Double = 0

    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()

            LoopingVideoView(videoName: "starsMoving", videoType: "mov")
                .ignoresSafeArea()
                .opacity(0.2)
                .blendMode(.lighten)

            Image("Red")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.6)
                .opacity(sunOpacity)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Where silence is heard")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .opacity(sunOpacity)
                    .padding(.top, 400)

                Spacer()
                Color.clear.frame(height: 0).padding()
            }

            // Black overlay for fade-out effect
            Color.black
                .ignoresSafeArea()
                .opacity(blackOverlayOpacity)
        }
        .onAppear {
            // Fade in sun/text
            withAnimation(.easeIn(duration: 1.5)) {
                sunOpacity = 1
            }

            // Wait before starting fade-out
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                // Animate black overlay
                withAnimation(.easeIn(duration: 1)) {
                    blackOverlayOpacity = 1
                }

                // Switch view after fade to black
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    HapticManger.instance.impact(style: .medium)
                    appState.route = .journeyV
                }
            }
        }
    }
}
#Preview {
    SplashView()
        .environmentObject(AppState())
}
