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

        case .home:
            HomeView()
            
//        case .journeyIntro(let journey):
//            JourneyView(journey: journey)  // Red horizon screen
            
        case .desertWalking(let journey):
            DesertExperienceView(journey: journey)  // SpriteKit walking
            
        case .desertFireStory(let journey):
            DesertFireStoryView(journey: journey)
            
        case .nightExploration(let journey):
            NightExplorationView(journey: journey)

//
//        case .spriteKitSample:
//            NavigationStack {   // or keep your existing nav container
//                SpriteKitSampleScreen()
//            }

        case .journeyV:
            JourneyView(journey: Journey(
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
        )
        case .collection:
            CollectionView(journey: Journey(
                id: "preview-journey",
                title: "Experimental Journey",
                description: "Used for preview only",
                outline: nil,
                subOutline: nil,
                imageName: nil,
                scenes: [],
                items: [], // start empty
                requiredItemIDs: [],
                journeyRules: JourneyRules(
                    softLimitSeconds: 0,
                    hardLimitSeconds: 0,
                    lostNoProgressSeconds: 0,
                    graceVolumeMultiplier: 1,
                    lostVolumeMultiplier: 1
                )
            )
)

        case .end:
            EndView()
        }
    }
}


