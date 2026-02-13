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
    
    private var scene: DesertScene {
        let s = (SKScene(fileNamed: "DesertScene") as? DesertScene) ?? DesertScene()
        s.scaleMode = .resizeFill
        
        // ✅ When desert walking ends, go to fire story
        s.onReachEnd = {
            appState.route = .desertFireStory(journey)
        }
        return s
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}

