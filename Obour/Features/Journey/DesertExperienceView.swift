//
//  SpriteKitSampleScreen.swift
//  Obour
//
//  Created by Raghad Alzemami on 20/08/1447 AH.
//

import SwiftUI
import SpriteKit

struct DesertExperienceView: View {
    @EnvironmentObject var appState: AppState
    let journey: Journey
    
    @State private var skView: SKView?
    
    private func makeScene() -> DesertScene {
        let s = (SKScene(fileNamed: "DesertScene") as? DesertScene) ?? DesertScene()
        s.scaleMode = .resizeFill
        
        s.onReachEnd = {
            // ✅ Pause SpriteKit before leaving
            s.isPaused = true
            appState.route = .desertFireStory(journey)
        }
        return s
    }
    
    var body: some View {
        SpriteView(scene: makeScene())
            .ignoresSafeArea()
            .onDisappear {
                // ✅ Clean up SpriteKit
                makeScene().removeAllChildren()
                makeScene().removeFromParent()
            }
    }
}
