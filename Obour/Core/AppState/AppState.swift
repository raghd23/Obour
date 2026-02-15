//
//  AppState.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
// Combine is required for ObservableObject and @Published
import Combine

final class AppState: ObservableObject {

    // Defines ALL possible navigation states of the app
    enum Route {
//        case launch
//        case onboarding
        case home
//        case journey(Journey)
 //       case journeyIntro(Journey)        // Red horizon intro screen
        case desertWalking(Journey)       // SpriteKit desert walking
        case desertFireStory(Journey)     // Fire + narration scene
        case nightExploration(Journey)
      //  case journeyOutro(Journey)
      //  case spriteKitSample
        case end
        case splash
        case journeyV
        case collection
    }
    
    // @Published notifies SwiftUI when the route changes
    // Default value is .launch when the app starts
    @Published var route: Route = .splash
}
