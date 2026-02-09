//
//  LaunchView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "figure.walk.motion")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .foregroundColor(.accentColor)

                Text("Obour")
                    .font(.largeTitle).bold()

                Text("Start your journey…")
                    .font(.callout)
                    .foregroundStyle(.secondary)

                ProgressView()
                    .padding(.top, 8)
            }
            .padding()
        }
        .task {
            // Simulate loading work; replace with real initialization if needed
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            // Navigate to home when ready
            appState.route = .home
        }
    }
}
