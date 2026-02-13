//
//  SpriteKitSampleScreen.swift
//  Obour
//
//  Created by Raghad Alzemami on 20/08/1447 AH.
//

import SwiftUI
import SpriteKit

struct SpriteKitSampleScreen: View {

    @State private var goToStory = false

    private var scene: DesertScene {
        let s = (SKScene(fileNamed: "DesertScene") as? DesertScene) ?? DesertScene()
        s.scaleMode = .resizeFill

        // ✅ connect SpriteKit -> SwiftUI navigation
        s.onReachEnd = {
            goToStory = true
        }
        return s
    }

    var body: some View {
        NavigationStack {
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            // Modern API: present destination when goToStory becomes true
            .navigationDestination(isPresented: $goToStory) {
                TravellerStroySceneView()
            }
        }
    }
}

#Preview {
    SpriteKitSampleScreen()
}
