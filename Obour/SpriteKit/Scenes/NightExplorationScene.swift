//
//  NightExplorationScene.swift
//  Obour
//
//  Created by Raghad Alzemami on 27/08/1447 AH.
//

import SpriteKit
import CoreMotion
final class NightExplorationScene: SKScene {
    
    // MARK: - Completion callback
    var onComplete: (() -> Void)?
    
    // MARK: - Nodes
    private var flashlight: SKSpriteNode!
    private var planetsContainer: SKNode!
    private let cameraNode = SKCameraNode()
    
    // MARK: - Touch tracking
    private var isDraggingFlashlight = false
    
    // MARK: - Scene bounds
    private var sceneBounds: CGRect!
    
    // MARK: - Setup
    override func didMove(to view: SKView) {
        size = view.bounds.size
        scaleMode = .resizeFill
        backgroundColor = .black
        
        // ✅ Wider scene bounds to fit three planets
        sceneBounds = CGRect(
            x: -size.width * 1.5,      // ⬅️ Wider left
            y: -size.height * 1.5,
            width: size.width * 3,      // ⬅️ 3x width (not 2x)
            height: size.height * 3
        )
        
        setupCamera()
        setupPlanets()
        setupFlashlight()
    }
    
    private func setupCamera() {
        camera = cameraNode
        addChild(cameraNode)
        cameraNode.position = .zero  // Start at center planet
    }
    
    private func setupFlashlight() {
        flashlight = SKSpriteNode(imageNamed: "flashlightImage")
        flashlight.zPosition = 100
        flashlight.setScale(0.4)
        flashlight.blendMode = .add
        flashlight.alpha = 0.9
        
        flashlight.position = .zero
        addChild(flashlight)
    }

    private func setupPlanets() {
        planetsContainer = SKNode()
        planetsContainer.position = .zero
        planetsContainer.zPosition = 1
        addChild(planetsContainer)
        
        let planetImages = ["planet1", "planet2", "planet3"]
        let spacing: CGFloat = 400  // ⬅️ Increased spacing
        
        for (index, imageName) in planetImages.enumerated() {
            let planet = SKSpriteNode(imageNamed: imageName)
            planet.setScale(0.6)  // ⬅️ Slightly bigger
            planet.name = "planet\(index + 1)"
            
            // Position: -700, 0, 700
            planet.position = CGPoint(
                x: CGFloat(index - 1) * spacing,
                y: 0
            )
            
            planetsContainer.addChild(planet)
            
            print("Planet \(index + 1) at x: \(planet.position.x)")  // Debug
        }
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if flashlight.contains(location) {
            isDraggingFlashlight = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, isDraggingFlashlight else { return }
        
        let location = touch.location(in: self)
        
        // ✅ Move flashlight directly
        flashlight.position = location
        
        // ✅ Smooth camera follow
        updateCameraPosition()
    }
    
    private func updateCameraPosition() {
        let targetX = flashlight.position.x
        let targetY = flashlight.position.y
        
        // ✅ Smooth lerp (slower movement)
        let lerpFactor: CGFloat = 0.08  // ⬅️ Lower = slower (was instant before)
        
        cameraNode.position.x += (targetX - cameraNode.position.x) * lerpFactor
        cameraNode.position.y += (targetY - cameraNode.position.y) * lerpFactor
        
        // Clamp camera to scene bounds
        let halfScreenWidth = size.width / 2
        let halfScreenHeight = size.height / 2
        
        cameraNode.position.x = max(
            sceneBounds.minX + halfScreenWidth,
            min(sceneBounds.maxX - halfScreenWidth, cameraNode.position.x)
        )
        
        cameraNode.position.y = max(
            sceneBounds.minY + halfScreenHeight,
            min(sceneBounds.maxY - halfScreenHeight, cameraNode.position.y)
        )
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDraggingFlashlight = false
        
        // Snap flashlight back to camera center
        let targetPosition = cameraNode.position
        
        let snapBack = SKAction.move(to: targetPosition, duration: 0.3)
        snapBack.timingMode = .easeOut
        flashlight.run(snapBack)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK: - Update Loop
    override func update(_ currentTime: TimeInterval) {
        // Smooth camera follow
        if isDraggingFlashlight {
            updateCameraPosition()
        }
    }
//
//## Key Fixes:
//
//✅ **Three planets visible** - Increased scene width from 2x to 3x
//✅ **Better planet spacing** - 700 units apart (was 600)
//✅ **Slower, smoother movement** - Added lerp with `0.08` factor
//✅ **No stars** - Removed `addStarsParticles()`
//✅ **Bigger planets** - Scale 0.6 (was 0.5)
//
//## Movement Speed Options:
//
//Change `lerpFactor` to adjust feel:
//- `0.05` = Very slow, cinematic
//- `0.08` = Smooth, controlled (current)
//- `0.15` = Faster, responsive
//- `1.0` = Instant (like before)
//
//**Debug:** Check the console for planet positions when the scene loads. You should see:
//```
//Planet 1 at x: -700.0
//Planet 2 at x: 0.0
//Planet 3 at x: 700.0
    
    /*
    // TODO: Plants setup
    private func setupPlants() {
        plantsContainer = SKNode()
        addChild(plantsContainer)
        
        let plantPositions: [(CGPoint, String)] = [
            (CGPoint(x: -800, y: 200), "plant-1-1"),
            (CGPoint(x: -600, y: -150), "plant-1-2"),
            (CGPoint(x: 0, y: 250), "plant-2-1"),
            (CGPoint(x: 600, y: 150), "plant-3-1"),
        ]
        
        for (position, id) in plantPositions {
            createPlant(at: position, id: id)
        }
    }
    
    private func createPlant(at position: CGPoint, id: String) {
        let plant = SKSpriteNode(imageNamed: "item1")
        plant.position = position
        plant.setScale(0.4)
        plant.zPosition = 10
        plant.name = id
        plant.alpha = 0  // Hidden until revealed by flashlight
        
        let glow = SKSpriteNode(color: .green, size: CGSize(width: 40, height: 40))
        glow.alpha = 0
        glow.zPosition = -1
        plant.addChild(glow)
        
        plantsContainer.addChild(plant)
    }
    
    // TODO: Reveal logic
    private func revealNearbyPlants() {
        let flashlightWorldPos = cameraNode.convert(flashlight.position, to: self)
        
        plantsContainer.children.forEach { node in
            guard let plant = node as? SKSpriteNode else { return }
            
            let distance = hypot(
                plant.position.x - flashlightWorldPos.x,
                plant.position.y - flashlightWorldPos.y
            )
            
            if distance < 150 {
                plant.alpha = 1
                plant.children.first?.alpha = 0.3
            } else {
                plant.alpha = max(0, 1 - (distance / 250))
                plant.children.first?.alpha = 0
            }
        }
    }
    
    // TODO: Collection logic
    private var itemsCollected: [String] = []
    private let requiredItems = 9
    
    private func checkPlantCollection(at location: CGPoint) {
        let nodes = self.nodes(at: location)
        for node in nodes {
            if let plant = node as? SKSpriteNode,
               let plantID = plant.name,
               !itemsCollected.contains(plantID) {
                collectPlant(plant, id: plantID)
            }
        }
    }
    
    private func collectPlant(_ plant: SKSpriteNode, id: String) {
        HapticManger.instance.impact(style: .medium)
        SoundManger.instance.playSound(sound: .card)
        
        itemsCollected.append(id)
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        plant.run(.sequence([scaleUp, fadeOut, remove]))
        
        if itemsCollected.count >= requiredItems {
            completeExploration()
        }
    }
    
    private func completeExploration() {
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        run(fadeOut) {
            self.onComplete?()
        }
    }
    */
}
