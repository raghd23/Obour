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
    
    // MARK: - AppState reference
    weak var appState: AppState?
    
    // MARK: - Nodes
    private var flashlight: SKSpriteNode!
    private var planetsContainer: SKNode!
    private let cameraNode = SKCameraNode()
    private var counterLabel: SKLabelNode!
    private var quitButton: SKNode!
    
    // MARK: - Touch tracking
    private var isDraggingFlashlight = false
    
    // MARK: - Scene bounds
    private var sceneBounds: CGRect!
    private var startY: CGFloat = 0
    private var endY: CGFloat = 0
    
    // MARK: - Exploration tracking
    private var planetsDiscovered: Set<String> = []
    private let requiredPlanets = 3
    
    // ✅ Map planet nodes to item IDs from ItemData
    private var planetItemMapping: [String: ItemID] = [:]
    
    // MARK: - Setup
    override func didMove(to view: SKView) {
        size = view.bounds.size
        scaleMode = .resizeFill
        backgroundColor = .black
        
        startY = -size.height * 2.5
        endY = size.height * 2.5
        
        sceneBounds = CGRect(
            x: -size.width * 0.5,
            y: startY,
            width: size.width,
            height: size.height * 5
        )
        
        setupCamera()
        setupPlanets()
        setupFlashlight()
        setupCounterUI()
        setupQuitButton()
        showInstructions()
    }

    private func setupCamera() {
        camera = cameraNode
        addChild(cameraNode)
        cameraNode.position = CGPoint(x: 0, y: startY + size.height / 2 - 150)
    }

    private func setupFlashlight() {
        flashlight = SKSpriteNode(imageNamed: "flashlightImage")
        flashlight.zPosition = 100
        flashlight.setScale(0.4)
        flashlight.blendMode = .add
        flashlight.alpha = 0.9
        flashlight.position = CGPoint(x: 0, y: startY + size.height / 2 - 150)
        addChild(flashlight)
    }

    private func setupPlanets() {
        planetsContainer = SKNode()
        planetsContainer.zPosition = 5
        addChild(planetsContainer)
        
        let planetImages = ["plant1", "plant2", "plant3"]
        let positions: [(x: CGFloat, y: CGFloat)] = [
            (x: -80, y: -size.height * 1.2),
            (x: 100, y: size.height * 0.8),
            (x: -60, y: size.height * 2.2)
        ]
        
        // ✅ Map planets to items from ItemData.allItems
        let itemsToFind = Array(ItemData.allItems.prefix(3))
        
        for (index, imageName) in planetImages.enumerated() {
            let planet = SKSpriteNode(imageNamed: imageName)
            planet.setScale(0.6)
            
            let planetID = "planet\(index + 1)"
            planet.name = planetID
            planet.position = CGPoint(
                x: positions[index].x,
                y: positions[index].y
            )
            planet.alpha = 0
            planetsContainer.addChild(planet)
            
            // ✅ Link planet to item from ItemData
            if index < itemsToFind.count {
                planetItemMapping[planetID] = itemsToFind[index].id
                print("🗺️ Mapped \(planetID) → \(itemsToFind[index].name) (\(itemsToFind[index].id))")
            }
        }
    }
    
    private func setupCounterUI() {
        counterLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        counterLabel.text = "0/3"
        counterLabel.fontSize = 24
        counterLabel.fontColor = .white
        counterLabel.zPosition = 200
        
        cameraNode.addChild(counterLabel)
        counterLabel.position = CGPoint(x: 0, y: size.height / 2 - 80)
    }
    
    private func setupQuitButton() {
        // Container node
        let quitButtonContainer = SKNode()
        quitButtonContainer.name = "quitButton"
        quitButtonContainer.zPosition = 201
        
        // ✅ Circular background using SKShapeNode
        let circle = SKShapeNode(circleOfRadius: 20)
        circle.fillColor = .gray.withAlphaComponent(0.1)
        circle.strokeColor = .white.withAlphaComponent(0.1)
        circle.lineWidth = 1
        circle.glowWidth = 1
        circle.name = "quitButtonCircle"
        quitButtonContainer.addChild(circle)
        
        // X label
        let xLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        xLabel.text = "✕"
        xLabel.fontSize = 20
        xLabel.fontColor = .white
        xLabel.verticalAlignmentMode = .center
        xLabel.horizontalAlignmentMode = .center
        xLabel.name = "quitButtonLabel"
        quitButtonContainer.addChild(xLabel)
        
        // Larger touch area for easier tapping
        let touchArea = SKShapeNode(circleOfRadius: 35)
        touchArea.fillColor = .clear
        touchArea.strokeColor = .clear
        touchArea.name = "quitButtonTouchArea"
        quitButtonContainer.addChild(touchArea)
        
        // Store reference for animations
        quitButton = quitButtonContainer
        
        // Position in top-left corner
        cameraNode.addChild(quitButtonContainer)
        quitButtonContainer.position = CGPoint(x: -size.width / 2 + 40, y: size.height / 2 - 80)
    }
    
    private func showInstructions() {
        let overlay = SKNode()
        overlay.name = "instructionOverlay"
        overlay.zPosition = 400
        
        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.9), size: size)
        bg.position = .zero
        overlay.addChild(bg)
        
        let title = SKLabelNode(fontNamed: "Arial-BoldMT")
        title.text = "Night Exploration"
        title.fontSize = 24
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 120)
        overlay.addChild(title)
        
        let instruction1 = SKLabelNode(fontNamed: "Arial")
        instruction1.text = "Drag the flashlight to explore"
        instruction1.fontSize = 16
        instruction1.fontColor = .white
        instruction1.position = CGPoint(x: 0, y: 60)
        overlay.addChild(instruction1)
        
        let instruction2 = SKLabelNode(fontNamed: "Arial")
        instruction2.text = "Find and collect 3 hidden plants"
        instruction2.fontSize = 16
        instruction2.fontColor = .white
        instruction2.position = CGPoint(x: 0, y: 30)
        overlay.addChild(instruction2)
        
        let flashlightHint = SKSpriteNode(imageNamed: "flashlightImage")
        flashlightHint.setScale(0.2)
        flashlightHint.position = CGPoint(x: 0, y: -30)
        flashlightHint.alpha = 0.7
        overlay.addChild(flashlightHint)
        
        let tapLabel = SKLabelNode(fontNamed: "Arial")
        tapLabel.text = "Tap anywhere to begin"
        tapLabel.fontSize = 14
        tapLabel.fontColor = .gray
        tapLabel.position = CGPoint(x: 0, y: -100)
        overlay.addChild(tapLabel)
        
        let pulse = SKAction.sequence([
            .fadeAlpha(to: 0.5, duration: 0.8),
            .fadeAlpha(to: 1.0, duration: 0.8)
        ])
        tapLabel.run(.repeatForever(pulse))
        
        cameraNode.addChild(overlay)
    }
    
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
        
        // ✅ Dismiss instructions
        if let overlay = cameraNode.childNode(withName: "instructionOverlay") {
            overlay.run(.fadeOut(withDuration: 0.3)) {
                overlay.removeFromParent()
            }
            return
        }
        
        // ✅ Dismiss item preview on tap
        if let itemPreview = cameraNode.childNode(withName: "itemPreview") {
            itemPreview.run(.fadeOut(withDuration: 0.2)) {
                itemPreview.removeFromParent()
            }
            return
        }
        
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            // ✅ Check for quit button (any of its child nodes)
            if node.name == "quitButton" ||
               node.name == "quitButtonLabel" ||
               node.name == "quitButtonCircle" ||
               node.name == "quitButtonTouchArea" {
                animateQuitButtonPress()
                showQuitConfirmation()
                return
            }
        }
        
        if flashlight.contains(location) {
            isDraggingFlashlight = true
        }
    }
    
    // ✅ Animate button press
    private func animateQuitButtonPress() {
        let scaleDown = SKAction.scale(to: 0.85, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        quitButton.run(.sequence([scaleDown, scaleUp]))
        
        HapticManger.instance.impact(style: .light)
        SoundManger.instance.playSound(sound: .card)
    }
    
    // ✅ Show quit confirmation popup
    private func showQuitConfirmation() {
        // Prevent multiple popups
        if cameraNode.childNode(withName: "quitConfirmationOverlay") != nil {
            return
        }
        
        let overlay = SKNode()
        overlay.name = "quitConfirmationOverlay"
        overlay.zPosition = 500
        
        // Semi-transparent background
        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.7), size: size)
        bg.position = .zero
        overlay.addChild(bg)
        
        // Popup card background
        let cardWidth: CGFloat = 280
        let cardHeight: CGFloat = 180
        let card = SKShapeNode(rectOf: CGSize(width: cardWidth, height: cardHeight), cornerRadius: 20)
        card.fillColor = .black.withAlphaComponent(0.9)
        card.strokeColor = .white.withAlphaComponent(0.1)
        card.lineWidth = 1.6
        card.position = .zero
        overlay.addChild(card)
        
        // Title
        let title = SKLabelNode(fontNamed: "Arial-BoldMT")
        title.text = "Quit Exploration?"
        title.fontSize = 20
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 40)
        overlay.addChild(title)
        
        // Cancel button
        let cancelButton = createConfirmationButton(
            text: "Cancel",
            position: CGPoint(x: -70, y: -50),
            color: .white.withAlphaComponent(0.1),
            name: "cancelQuitButton"
        )
        overlay.addChild(cancelButton)
        
        // Confirm button
        let confirmButton = createConfirmationButton(
            text: "Quit",
            position: CGPoint(x: 70, y: -50),
            color: .red.withAlphaComponent(0.2),
            name: "confirmQuitButton"
        )
        overlay.addChild(confirmButton)
        
        // Add to camera with scale animation
        cameraNode.addChild(overlay)
        overlay.setScale(0.8)
        overlay.alpha = 0
        
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        overlay.run(.group([scaleUp, fadeIn]))
    }
    
    // ✅ Create styled button for confirmation popup
    private func createConfirmationButton(text: String, position: CGPoint, color: UIColor, name: String) -> SKNode {
        let buttonContainer = SKNode()
        buttonContainer.position = position
        buttonContainer.name = name
        
        // Button background
        let button = SKShapeNode(rectOf: CGSize(width: 112, height: 40), cornerRadius: 12)
        button.fillColor = color.withAlphaComponent(0.1)
        button.strokeColor = color.withAlphaComponent(0.3)
        button.lineWidth = 1
        button.name = "\(name)Shape"
        buttonContainer.addChild(button)
        
        // Button label
        let label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.text = text
        label.fontSize = 16
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.name = "\(name)Label"
        buttonContainer.addChild(label)
        
        return buttonContainer
    }
    
    // ✅ Handle confirmation popup interactions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Check if quit confirmation popup is showing
        if let confirmationOverlay = cameraNode.childNode(withName: "quitConfirmationOverlay") {
            let nodesAtPoint = nodes(at: location)
            
            for node in nodesAtPoint {
                // Confirm quit
                if node.name?.contains("confirmQuitButton") == true {
                    animateButtonPress(node.parent ?? node)
                    dismissConfirmationAndQuit()
                    return
                }
                
                // Cancel quit
                if node.name?.contains("cancelQuitButton") == true {
                    animateButtonPress(node.parent ?? node)
                    dismissConfirmation()
                    return
                }
            }
            
            // Tap outside popup to cancel
            if !nodesAtPoint.contains(where: { $0.name == "quitConfirmationOverlay" }) {
                dismissConfirmation()
            }
            return
        }
        
        // Normal flashlight release
        isDraggingFlashlight = false
        
        let targetPosition = cameraNode.position
        let snapBack = SKAction.move(to: targetPosition, duration: 0.3)
        snapBack.timingMode = .easeOut
        flashlight.run(snapBack)
    }
    
    // ✅ Animate button press in popup
    private func animateButtonPress(_ button: SKNode) {
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        button.run(.sequence([scaleDown, scaleUp]))
        
        HapticManger.instance.impact(style: .medium)
        SoundManger.instance.playSound(sound: .card)
    }
    
    // ✅ Dismiss confirmation popup
    private func dismissConfirmation() {
        guard let overlay = cameraNode.childNode(withName: "quitConfirmationOverlay") else { return }
        
        let scaleDown = SKAction.scale(to: 0.8, duration: 0.15)
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        
        overlay.run(.group([scaleDown, fadeOut])) {
            overlay.removeFromParent()
        }
    }
    
    // ✅ Dismiss and quit - navigate to journeyV instead of collection
    private func dismissConfirmationAndQuit() {
        guard let overlay = cameraNode.childNode(withName: "quitConfirmationOverlay") else { return }
        
        overlay.run(.fadeOut(withDuration: 0.2)) {
            overlay.removeFromParent()
            self.handleQuitButton()
        }
    }
    
    private func handleQuitButton() {
        print("🚪 Quitting exploration, navigating to JourneyView...")
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        run(fadeOut) {
            // ✅ Navigate to journeyV instead of collection
            self.appState?.route = .journeyV
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
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDraggingFlashlight = false
        
        let targetPosition = cameraNode.position
        let snapBack = SKAction.move(to: targetPosition, duration: 0.3)
        snapBack.timingMode = .easeOut
        flashlight.run(snapBack)
    }
    
    // MARK: - Update Loop
    override func update(_ currentTime: TimeInterval) {
        if isDraggingFlashlight {
            updateCameraPosition()
        }
        revealPlanets()
        checkPlanetDiscovery()
    }
    
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
            
            if distance < 200 {
                discoverPlanet(planetID)
            }
        }
    }
    
    // ✅ Planet discovered - save item to AppState
    private func discoverPlanet(_ planetID: String) {
        planetsDiscovered.insert(planetID)
        
        HapticManger.instance.impact(style: .medium)
        SoundManger.instance.playSound(sound: .card)
        
      //  showDiscoveryAnimation(for: planetID)
        
        // ✅ Get the actual item from ItemData and save to AppState
        if let itemID = planetItemMapping[planetID] {
            appState?.discoverItem(itemID)
            showItemPreview(itemID: itemID)
        }
        
        updateCounter()
        
        print("✅ Discovered: \(planetID). Counter: \(planetsDiscovered.count)/\(requiredPlanets)")
        
        // ✅ Check completion after last item preview dismisses
        if planetsDiscovered.count >= requiredPlanets {
            // Wait for item preview to dismiss before showing completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.completeExploration()
            }
        }
    }
    
//    private func showDiscoveryAnimation(for planetID: String) {
//        guard let planet = planetsContainer.childNode(withName: planetID) as? SKSpriteNode else { return }
//        
//        let glow = SKSpriteNode(color: .yellow, size: CGSize(width: planet.size.width * 1.5, height: planet.size.height * 1.5))
//        glow.position = planet.position
//        glow.alpha = 0
//        glow.zPosition = planet.zPosition - 1
//        planetsContainer.addChild(glow)
//        
//        let glowSequence = SKAction.sequence([
//            .fadeAlpha(to: 0.6, duration: 0.2),
//            .fadeOut(withDuration: 0.3)
//        ])
//        glow.run(glowSequence) {
//            glow.removeFromParent()
//        }
//        
//        let pulse = SKAction.sequence([
//            .scale(to: 0.7, duration: 0.1),
//            .scale(to: 0.6, duration: 0.1)
//        ])
//        planet.run(pulse)
//    }
    
    // ✅ Show item preview - dismissible by tap
    private func showItemPreview(itemID: ItemID) {
        guard let item = ItemData.getItem(by: itemID) else { return }
        
        let overlay = SKNode()
        overlay.name = "itemPreview"
        overlay.zPosition = 300
        
        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.3),
                             size: CGSize(width: size.width, height: size.height))
        bg.position = CGPoint(x: 0, y: 0)
        overlay.addChild(bg)
        
        // Item image (using imageName)
        if let imageName = item.imageName {
            let itemImage = SKSpriteNode(imageNamed: imageName)
            itemImage.setScale(0.4)
            itemImage.position = CGPoint(x: 0, y: 40)
            overlay.addChild(itemImage)
        }
        
        // Item name
        let nameLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        nameLabel.text = item.name
        nameLabel.fontSize = 18
        nameLabel.fontColor = .white
        nameLabel.position = CGPoint(x: 0, y: -20)
        overlay.addChild(nameLabel)
        
        // "Collected!" text
        let collectedLabel = SKLabelNode(fontNamed: "Arial")
        collectedLabel.text = "Collected!"
        collectedLabel.fontSize = 14
        collectedLabel.fontColor = .white
        collectedLabel.position = CGPoint(x: 0, y: -45)
        overlay.addChild(collectedLabel)
        
        // ✅ "Tap to continue" hint
        let tapHint = SKLabelNode(fontNamed: "Arial")
        tapHint.text = " "
        tapHint.fontSize = 12
        tapHint.fontColor = .gray
        tapHint.position = CGPoint(x: 0, y: -80)
        overlay.addChild(tapHint)
        
        // Pulse animation for tap hint
        let pulse = SKAction.sequence([
            .fadeAlpha(to: 0.5, duration: 0.6),
            .fadeAlpha(to: 1.0, duration: 0.6)
        ])
        tapHint.run(.repeatForever(pulse))
        
        cameraNode.addChild(overlay)
        
        // ✅ Auto-dismiss after 2 seconds (but user can tap to dismiss earlier)
        let wait = SKAction.wait(forDuration: 5.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        overlay.run(.sequence([wait, fadeOut])) {
            overlay.removeFromParent()
        }
    }
    
    private func completeExploration() {
        isDraggingFlashlight = false
        print("🎉 All plants discovered!")
        
        showCompletionOverlay()
        
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        
        run(.sequence([wait, fadeOut])) {
            self.onComplete?()
        }
    }
    
    // ✅ Completion overlay shows after last item preview dismisses
    private func showCompletionOverlay() {
        let overlay = SKNode()
        overlay.name = "completionOverlay"
        overlay.zPosition = 350
        
        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.8), size: size)
        overlay.addChild(bg)
        
        let title = SKLabelNode(fontNamed: "Arial-BoldMT")
        title.text = "Exploration Complete!"
        title.fontSize = 24
        title.fontColor = .green
        title.position = CGPoint(x: 0, y: 40)
        overlay.addChild(title)
        
        let subtitle = SKLabelNode(fontNamed: "Arial")
        subtitle.text = "All plants collected"
        subtitle.fontSize = 16
        subtitle.fontColor = .white
        subtitle.position = CGPoint(x: 0, y: 10)
        overlay.addChild(subtitle)
        
        cameraNode.addChild(overlay)
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
//}

