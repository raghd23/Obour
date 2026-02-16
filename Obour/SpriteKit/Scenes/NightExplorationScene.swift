//
//  NightExplorationScene.swift
//  Obour
//
//  Created by Raghad Alzemami on 27/08/1447 AH.
//

import SpriteKit
import CoreMotion
import SpriteKit

final class NightExplorationScene: SKScene {
    
    // MARK: - Completion callback
    var onComplete: (() -> Void)?
    
    // MARK: - Nodes
    private var flashlight: SKSpriteNode!
    private var planetsContainer: SKNode!
    private let cameraNode = SKCameraNode()
    
    // ✅ Counter label
    private var counterLabel: SKLabelNode!
    
    // MARK: - Touch tracking
    private var isDraggingFlashlight = false
    
    // MARK: - Scene bounds & Journey
    private var sceneBounds: CGRect!
    private var startY: CGFloat = 0
    private var endY: CGFloat = 0
    
    // MARK: - Exploration tracking
    private var planetsDiscovered: Set<String> = []  // ⬅️ Track discovered PLANETS
    private let requiredPlanets = 3
    
    // MARK: - Setup
    override func didMove(to view: SKView) {
        size = view.bounds.size
        scaleMode = .resizeFill
        backgroundColor = .black
        
        // ✅ BIGGER bounds - 5x height instead of 3x
        startY = -size.height * 2.5
        endY = size.height * 2.5
        
        sceneBounds = CGRect(
            x: -size.width * 0.5,
            y: startY,
            width: size.width,
            height: size.height * 5  // ⬅️ Was 3, now 5
        )
        
        setupCamera()
        setupPlanets()
        setupFlashlight()
        setupCounterUI()
    }

    private func setupCamera() {
        camera = cameraNode
        addChild(cameraNode)
        
        // ✅ Start lower so first planet is only partially visible
        cameraNode.position = CGPoint(x: 0, y: startY + size.height / 2 - 150)
    }

    private func setupFlashlight() {
        flashlight = SKSpriteNode(imageNamed: "flashlightImage")
        flashlight.zPosition = 100
        flashlight.setScale(0.4)
        flashlight.blendMode = .add
        flashlight.alpha = 0.9
        
        // ✅ Start lower (matching camera)
        flashlight.position = CGPoint(x: 0, y: startY + size.height / 2 - 150)
        addChild(flashlight)
    }

    private func setupPlanets() {
        planetsContainer = SKNode()
        planetsContainer.zPosition = 5
        addChild(planetsContainer)
        
        let planetImages = ["planet1", "planet2", "planet3"]
        
        // ✅ Adjusted positions for bigger world
        let positions: [(x: CGFloat, y: CGFloat)] = [
            (x: -80, y: -size.height * 1.2),   // First: starts half visible as clue
            (x: 100, y: size.height * 0.8),    // Middle
            (x: -60, y: size.height * 2.2)     // Last: fully visible when reached
        ]
        
        for (index, imageName) in planetImages.enumerated() {
            let planet = SKSpriteNode(imageNamed: imageName)
            planet.setScale(0.6)
            planet.name = "planet\(index + 1)"
            planet.position = CGPoint(
                x: positions[index].x,
                y: positions[index].y
            )
            planet.alpha = 0
            planetsContainer.addChild(planet)
            
            print("Planet \(index + 1) at y: \(planet.position.y)")
        }
    }
    
    // ✅ Counter UI at top
    private func setupCounterUI() {
        counterLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        counterLabel.text = "0/3"
        counterLabel.fontSize = 24
        counterLabel.fontColor = .white
        counterLabel.zPosition = 200
        
        cameraNode.addChild(counterLabel)
        counterLabel.position = CGPoint(x: 0, y: size.height / 2 - 80)
    }
    
    // ✅ Update counter display
    private func updateCounter() {
        counterLabel.text = "\(planetsDiscovered.count)/\(requiredPlanets)"
        
        let pulse = SKAction.sequence([
            .scale(to: 1.3, duration: 0.1),
            .scale(to: 1.0, duration: 0.1)
        ])
        counterLabel.run(pulse)
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
        flashlight.position = location
        updateCameraPosition()
    }
    
    private func updateCameraPosition() {
        let targetX = flashlight.position.x
        let targetY = flashlight.position.y
        
        let lerpFactor: CGFloat = 0.08
        
        cameraNode.position.x += (targetX - cameraNode.position.x) * lerpFactor
        cameraNode.position.y += (targetY - cameraNode.position.y) * lerpFactor
        
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
        if isDraggingFlashlight {
            updateCameraPosition()
        }
        revealPlanets()
        checkPlanetDiscovery()  // ⬅️ Check if flashlight discovers planets
    }
    
    // ✅ Reveal planets when flashlight is near
    private func revealPlanets() {
        let flashlightPos = flashlight.position
        
        planetsContainer.children.forEach { node in
            guard let planet = node as? SKSpriteNode else { return }
            
            let distance = hypot(
                planet.position.x - flashlightPos.x,
                planet.position.y - flashlightPos.y
            )
            
            if distance < 450 {
                planet.alpha = 1
            } else {
                planet.alpha = max(0, 1 - (distance / 400))
            }
        }
    }
    
    // ✅ Check if flashlight encounters a planet
    private func checkPlanetDiscovery() {
        let flashlightPos = flashlight.position
        
        planetsContainer.children.forEach { node in
            guard let planet = node as? SKSpriteNode,
                  let planetID = planet.name,
                  !planetsDiscovered.contains(planetID) else { return }
            
            let distance = hypot(
                planet.position.x - flashlightPos.x,
                planet.position.y - flashlightPos.y
            )
            
            // ✅ When flashlight gets close to planet, count as discovered
            if distance < 200 {
                discoverPlanet(planetID)
            }
        }
    }
    
    // ✅ Planet discovered!
    private func discoverPlanet(_ planetID: String) {
        planetsDiscovered.insert(planetID)
        
        HapticManger.instance.impact(style: .medium)
        SoundManger.instance.playSound(sound: .card)
        
        updateCounter()
        
        print("✅ Discovered: \(planetID). Counter: \(planetsDiscovered.count)/\(requiredPlanets)")
        
        // ✅ Complete when all 3 planets discovered
        if planetsDiscovered.count >= requiredPlanets {
            completeExploration()
        }
    }
    
    private func completeExploration() {
        isDraggingFlashlight = false
        print("🎉 All planets discovered! Navigating to JourneyView...")
        
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        run(fadeOut) {
            self.onComplete?()
        }
    }

    /*
    // TODO: OLD Collection Logic (commented out)
    private var itemsCollected: [String] = []
    
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
    */
}

