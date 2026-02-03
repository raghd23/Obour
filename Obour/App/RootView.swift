//
//  RootView.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
import SwiftUI

struct RootView: View {
    
    // Reads the global AppState injected by ObourApp
    // This allows RootView to react to navigation changes
    @EnvironmentObject var appState: AppState

    // The body must always return exactly ONE View
    var body: some View {
        
        // Switches over the current navigation state
        switch appState.route {
            
        case .launch:
            Text("Launch Screen")
            //LaunchView()

        case .onboarding:
            Text("Screen")
            //OnboardingView()

        case .mainMenu:
            Text("Screen")
            //MainMenuView()

        case .journey(let journey):
            Text("Screen")
            //JourneyView(
            //   viewModel: JourneyViewModel(journey: journey)
            //)
        case .end:
            EndView()
        }
    }
}

