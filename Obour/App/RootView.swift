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
//            
//        case .launch:
//            LaunchView()
        case .splash:
            SplashView()
//
//        case .home:
//            HomeView()
            
//        case .journeyIntro(let journey):
//            JourneyView(journey: journey)  // Red horizon screen
            
        case .nightExploration:
            NightExplorationView()
                .environmentObject(appState)
        
        case .collection:
            CollectionView()
                .environmentObject(appState)
            
        case .desertWalking:
            DesertExperienceView(journey: appState.journey)  // SpriteKit walking
            
        case .desertFireStory:
            DesertFireStoryView(journey: appState.journey)
            
//        case .nightExploration(let journey):
//            NightExplorationView(journey: journey)

//
//        case .spriteKitSample:
//            NavigationStack {   // or keep your existing nav container
//                SpriteKitSampleScreen()
//            }

        case .journeyV:
            JourneyView()

        case .end:
            EndView()
        }
    }
}
