import SwiftUI
import SpriteKit

struct DesertExperienceView: View {
    @EnvironmentObject var appState: AppState
    let journey: Journey

    @State private var fadeIn = false
    @State private var scene: DesertScene?

    private func makeScene() -> DesertScene {
        let s = (SKScene(fileNamed: "DesertScene") as? DesertScene) ?? DesertScene()
        s.scaleMode = .resizeFill

        s.onReachEnd = {
            s.isPaused = true
            appState.route = .desertFireStory(journey)
        }

        return s
    }

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
            let s = makeScene()
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
}
