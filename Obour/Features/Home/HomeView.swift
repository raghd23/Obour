//
//  HomeView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var homeVM = HomeViewModel()
    init() {
        #if DEBUG
        _homeVM = StateObject(wrappedValue: HomeViewModel.preview)
        #else
        _homeVM = StateObject(wrappedValue: HomeViewModel())
        #endif
    }

    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic background gradient
                homeVM.backgroundGradient()
                    .ignoresSafeArea()

                VStack {


                    // Title & Subtitle
                    VStack(spacing: 4) {
                        Text(homeVM.currentJourney?.description ?? "")
                            .foregroundColor(.white)
                        Text(homeVM.currentJourney?.title ?? "")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.top, 80)

                    Spacer()

                    // Stacked cards
                    ZStack {
                        ForEach(Array(homeVM.journeys.enumerated()), id: \.1.id) { index, journey in
                            JourneyCardView(journey: journey,
                                            forwardAction: journey.id == "desert"
                                                ? { appState.route = .journey(journey) } // only desert has action
                                                : nil // sea and others have no action → lock
                            )
                                .offset(y: -CGFloat(index) * 44)
                                .zIndex(Double(homeVM.journeys.count - index))
                                .gesture(
                                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                                        .updating($dragOffset, body: { value, state, _ in
                                            if abs(value.translation.height) > 20 && index == 0 {
                                                state = value.translation
                                            }
                                        })
                                        .onEnded { value in
                                            if abs(value.translation.height) > 50 && index == 0 {
                                                withAnimation(.spring()) {
                                                    homeVM.rotateJourneys()
                                                }
                                            }
                                        }
                                )
                        }
                    }
                    .padding(.bottom, 40)
                }
                .frame(width: 395)
            }
//            .navigationTitle("Home")
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(AppState())
        .environment(\.self, .init()) // keeps preview stable
}
