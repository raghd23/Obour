//
//  SplashView.swift
//  Obour
//
//  Created by Deemah Alhazmi on 11/02/2026.


import SwiftUI
import AVKit

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var isActive = false
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
                
                Button {
                    // Trigger journey start logic in ViewModel
                  //  viewModel.startJourney()
                    // Navigate to home view
                    HapticManger.instance.impact(style: .medium)
                    appState.route = .home
                } label: {
                    Text("Start")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 9)
                        .glassEffect(.clear)

                }
                .padding()
            }

        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.5)) {
                sunOpacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isActive = true
            }
        }

//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                isActive = true
//            }
//        }
//        .fullScreenCover(isPresented: $isActive) {
//            JourneyView(journey: mockJourney) // ✅ Fixed
//        }
    }
}

#Preview {
    SplashView()
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
    items: [],
    requiredItemIDs: [],
    journeyRules: JourneyRules(
        softLimitSeconds: 480,
        hardLimitSeconds: 600,
        lostNoProgressSeconds: 30,
        graceVolumeMultiplier: 1.2,
        lostVolumeMultiplier: 0.8
    )
)
