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
    
    @State private var fadeIn = false
    @State private var scene: NightExplorationScene?
    
    var body: some View {
        ZStack {
            // Always black underneath
            Color.black
                .ignoresSafeArea()
            
            // Only show SpriteView after the scene is ready and fadeIn starts
            if let scene = scene, fadeIn {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: fadeIn)
            }
        }
        .onAppear {
            // Create scene immediately
            let s = createScene()
            self.scene = s
            
            // Delay slightly to ensure the black background is rendered
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    fadeIn = true
                }
            }
        }
        .onDisappear {
            scene?.removeAllChildren()
            scene?.removeFromParent()
        }
    }
    
    private func createScene() -> NightExplorationScene {
        let scene = NightExplorationScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        
        // ✅ Pass AppState reference
        scene.appState = appState
        
        // ✅ Handle completion - navigate to CollectionView
        scene.onComplete = {
            print("✅ NightExploration completed")
            
            // Navigate to collection view
            appState.route = .collection
        }
        
        return scene
    }
}

#Preview {
    NightExplorationView()
        .environmentObject(AppState())
}

//
//import SwiftUI
//
//import SpriteKit
//
//
//
//struct NightExplorationView: View {
//
//   @EnvironmentObject var appState: AppState
//
//   
//
//   var body: some View {
//
//       SpriteView(scene: createScene())
//
//           .ignoresSafeArea()
//
//   }
//
//   
//
//   private func createScene() -> NightExplorationScene {
//
//       let scene = NightExplorationScene()
//
//       scene.size = UIScreen.main.bounds.size
//
//       scene.scaleMode = .resizeFill
//
//       
//
//       // ✅ Pass AppState reference (scene gets journey from appState.journey)
//
//       scene.appState = appState
//
//       
//
//       // ✅ Handle completion - navigate to CollectionView
//
//       scene.onComplete = {
//
//           print("✅ NightExploration completed")
//
////            print("📊 Items discovered: \(appState.journey.discoveredItemIDs.count)/\(appState.journey.items.count)")
//
//           
//
//           // Navigate to collection view
//
//           appState.route = .collection
//
//       }
//
//       
//
//       return scene
//
//   }
//
//} 
