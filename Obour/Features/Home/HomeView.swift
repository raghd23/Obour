//
//  MainMenuView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        appState.route = .onboarding
                    } label: {
                        Label("Start Onboarding", systemImage: "sparkles")
                    }

                    Button {
                        // Enable and provide a Journey when ready:
                        // let sample = Journey(id: UUID(), title: "Sample Journey")
                        // appState.route = .journey(sample)
                    } label: {
                        Label("Start Journey", systemImage: "figure.walk")
                    }
                    .disabled(true) // Disabled until a Journey model instance is provided

                    Button {
                        appState.route = .end
                    } label: {
                        Label("End Screen", systemImage: "flag.checkered")
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}
