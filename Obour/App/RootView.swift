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
            LaunchView()

        case .onboarding:
            OnboardingViewPlaceholder()

        case .home:
            HomeView()

        case .journey(let journey):
            JourneyPlaceholderView(title: journey.title)
        case .spriteKitSample:
            NavigationStack {   // or keep your existing nav container
                SpriteKitSampleScreen()
            }

        case .end:
            EndView()
        }
    }
}

// Temporary placeholders so the app compiles cleanly until you add real views.
private struct OnboardingViewPlaceholder: View {
    var body: some View {
        Text("Onboarding Screen (to be implemented)")
            .padding()
    }
}

private struct JourneyPlaceholderView: View {
    let title: String
    var body: some View {
        Text("Journey Screen for \(title) (to be implemented)")
            .padding()
    }
}
