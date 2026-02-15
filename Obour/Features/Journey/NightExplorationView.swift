//
//  NightExplorationView.swift
//  Obour
//
//  Created by Raghad Alzemami on 27/08/1447 AH.
//

import SwiftUI
import SpriteKit

struct NightExplorationView: View {
    @EnvironmentObject var appState: AppState
    let journey: Journey
    
    private func makeScene() -> NightExplorationScene {
        let scene = NightExplorationScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        
        // ✅ Navigate back to JourneyView when complete
        scene.onComplete = {
            appState.route = .journeyV
        }
        
        return scene
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            SpriteView(scene: makeScene())
                .ignoresSafeArea()
        }
    }
}
