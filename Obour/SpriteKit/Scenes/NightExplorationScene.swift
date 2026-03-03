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
//    private var counterLabel: SKLabelNode!
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
    
    // ✅ Track which planets are showing name+button (but not yet collected)
    private var planetsShowingButton: Set<String> = []
    
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
 //       setupCounterUI()
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
            planet.setScale(0.5)
            
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
    
//    private func setupCounterUI() {
//        counterLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
//        counterLabel.text = "0/3"
//        counterLabel.fontSize = 24
//        counterLabel.fontColor = .white
//        counterLabel.zPosition = 200
//        
//        cameraNode.addChild(counterLabel)
//        counterLabel.position = CGPoint(x: 0, y: size.height / 2 - 80)
//    }
    
    private func setupQuitButton() {
        let quitButtonContainer = SKNode()
        quitButtonContainer.name = "quitButton"
        quitButtonContainer.zPosition = 201
        
        let circle = SKShapeNode(circleOfRadius: 20)
        circle.fillColor = .gray.withAlphaComponent(0.1)
        circle.strokeColor = .white.withAlphaComponent(0.1)
        circle.lineWidth = 1
        circle.glowWidth = 1
        circle.name = "quitButtonCircle"
        quitButtonContainer.addChild(circle)
        
        let xLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        xLabel.text = "✕"
        xLabel.fontSize = 20
        xLabel.fontColor = .white
        xLabel.verticalAlignmentMode = .center
        xLabel.horizontalAlignmentMode = .center
        xLabel.name = "quitButtonLabel"
        quitButtonContainer.addChild(xLabel)
        
        let touchArea = SKShapeNode(circleOfRadius: 35)
        touchArea.fillColor = .clear
        touchArea.strokeColor = .clear
        touchArea.name = "quitButtonTouchArea"
        quitButtonContainer.addChild(touchArea)
        
        quitButton = quitButtonContainer
        
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
        instruction2.text = "Tap + to collect the 3 plants"
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
    
//    private func updateCounter() {
//        counterLabel.text = "\(planetsDiscovered.count)/\(requiredPlanets)"
//        
//        let pulse = SKAction.sequence([
//            .scale(to: 1.3, duration: 0.1),
//            .scale(to: 1.0, duration: 0.1)
//        ])
//        counterLabel.run(pulse)
//    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        print("🟡 touchesBegan start")
        
        if cameraNode.childNode(withName: "quitConfirmationOverlay") != nil {  print("🔴 blocked by quitConfirmation")
            return }
        
        if let overlay = cameraNode.childNode(withName: "instructionOverlay") {
            overlay.run(.fadeOut(withDuration: 0.3)) { overlay.removeFromParent() }
            print("🔴 blocked by instructions")
            return
        }
        
        if let itemPreview = cameraNode.childNode(withName: "itemPreview") {
            itemPreview.run(.fadeOut(withDuration: 0.2)) { itemPreview.removeFromParent() }
            print("🔴 blocked by itemPreview")
            return
        }
        
        let nodesAtPoint = nodes(at: location)
        print("🔍 Nodes at point: \(nodesAtPoint.map { $0.name ?? "unnamed" })")
        
        // Plus button tapped directly
        if nodesAtPoint.contains(where: { $0.name?.hasPrefix("plusButton_") == true }) {
            print("🟢 hit plusButton")
            if let plusNode = nodesAtPoint.first(where: { $0.name?.hasPrefix("plusButton_") == true }),
               let name = plusNode.name {
                let planetID = String(name.dropFirst("plusButton_".count))
                if let itemID = planetItemMapping[planetID] {
                    handlePlusButtonTap(planetID: planetID, itemID: itemID)
                }
            }
            return
        }

//        // Plus overlay tapped (anywhere except plus button) — dismiss
//        if let plusOverlayNode = nodesAtPoint.first(where: {
//            $0.name?.hasPrefix("plusOverlay_") == true }),
//           let overlayName = plusOverlayNode.name {
//            print("🟢 hit plusOverlay")
//            let planetID = String(overlayName.dropFirst("plusOverlay_".count))
//            dismissPlantDiscoveryOverlay(planetID: planetID)
//            return
//        }

        // Card overlay — tap anywhere to dismiss
        if let cardOverlayNode = nodesAtPoint.first(where: { $0.name?.hasPrefix("cardOverlay_") == true }),
           let overlayName = cardOverlayNode.name {
            let planetID = String(overlayName.dropFirst("cardOverlay_".count))
            dismissCardOverlay(planetID: planetID)
            return
        }
        
        for node in nodesAtPoint {
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
    
    private func dismissPlantDiscoveryOverlay(planetID: String) {
        print("🗑️ Attempting dismiss for \(planetID)")
        if let overlay = cameraNode.childNode(withName: "plusOverlay_\(planetID)") {
            print("🗑️ Found overlay, removing")
            overlay.run(.fadeOut(withDuration: 0.2)) {
                overlay.removeFromParent()
                // Only remove from tracking AFTER fade completes
                self.planetsShowingButton.remove(planetID)
            }
        }
    }

    private func dismissCardOverlay(planetID: String) {
        if let overlay = cameraNode.childNode(withName: "cardOverlay_\(planetID)") {
            overlay.run(.fadeOut(withDuration: 0.2)) { overlay.removeFromParent() }
        }
    }
    
    private func animateQuitButtonPress() {
        let scaleDown = SKAction.scale(to: 0.85, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        quitButton.run(.sequence([scaleDown, scaleUp]))
        
        HapticManger.instance.impact(style: .light)
        SoundManger.instance.playSound(sound: .card)
    }
    
    private func showQuitConfirmation() {
        isDraggingFlashlight = false
        if cameraNode.childNode(withName: "quitConfirmationOverlay") != nil {
            return
        }
        let overlay = SKNode()
        overlay.name = "quitConfirmationOverlay"
        overlay.zPosition = 500
        
        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: size)
        bg.position = .zero
        overlay.addChild(bg)
        
        let cardWidth: CGFloat = (size.width * 0.7)
        let cardHeight: CGFloat = (size.height/6)
        let card = SKShapeNode(rectOf: CGSize(width: cardWidth, height: cardHeight), cornerRadius: 20)
        card.fillColor = .black.withAlphaComponent(0.9)
        card.strokeColor = .white.withAlphaComponent(0.1)
        card.lineWidth = 1.6
        card.position = .zero
        overlay.addChild(card)
        
        let title = SKLabelNode(fontNamed: "Arial-BoldMT")
        title.text = "Quit Exploration"
        title.fontSize = 20
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 30)
        overlay.addChild(title)
        
        let cancelButton = createConfirmationButton(
            text: "Cancel",
            position: CGPoint(x: -70, y: -32),
            color: .gray.withAlphaComponent(0.1),
            name: "cancelQuitButton"
        )
        overlay.addChild(cancelButton)
        
        let confirmButton = createConfirmationButton(
            text: "Quit",
            position: CGPoint(x: 70, y: -32),
            color: .red.withAlphaComponent(0.8),
            name: "confirmQuitButton"
        )
        overlay.addChild(confirmButton)
        
        cameraNode.addChild(overlay)
        overlay.setScale(0.8)
        overlay.alpha = 0
        
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        overlay.run(.group([scaleUp, fadeIn]))
    }
    
    private func createConfirmationButton(text: String, position: CGPoint, color: UIColor, name: String) -> SKNode {
        let buttonContainer = SKNode()
        buttonContainer.position = position
        buttonContainer.name = name
        
        let button = SKShapeNode(rectOf: CGSize(width: 112, height: 40), cornerRadius: 12)
        button.fillColor = color.withAlphaComponent(0.3)
        button.strokeColor = color.withAlphaComponent(0.3)
        button.lineWidth = 1
        button.name = "\(name)Shape"
        buttonContainer.addChild(button)
        
        let label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.text = text
        label.fontSize = 16
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.name = "\(name)Label"
        buttonContainer.addChild(label)
        
        return buttonContainer
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let _ = cameraNode.childNode(withName: "quitConfirmationOverlay") {
            let nodesAtPoint = nodes(at: location)
            for node in nodesAtPoint {
                if node.name?.contains("confirmQuitButton") == true {
                    animateButtonPress(node.parent ?? node)
                    dismissConfirmationAndQuit()
                    return
                }
                if node.name?.contains("cancelQuitButton") == true {
                    animateButtonPress(node.parent ?? node)
                    dismissConfirmation()
                    return
                }
            }
            if !nodesAtPoint.contains(where: { $0.name == "quitConfirmationOverlay" }) {
                dismissConfirmation()
            }
            return
        }
        
        isDraggingFlashlight = false
        
        if !hasActiveOverlay {
            let snapBack = SKAction.move(to: cameraNode.position, duration: 0.3)
            snapBack.timingMode = .easeOut
            flashlight.run(snapBack)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDraggingFlashlight = false
        
        if !hasActiveOverlay {
            let snapBack = SKAction.move(to: cameraNode.position, duration: 0.3)
            snapBack.timingMode = .easeOut
            flashlight.run(snapBack)
        }
    }
    
    private func animateButtonPress(_ button: SKNode) {
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        button.run(.sequence([scaleDown, scaleUp]))
        
        HapticManger.instance.impact(style: .medium)
        SoundManger.instance.playSound(sound: .card)
    }
    
    private func dismissConfirmation() {
        guard let overlay = cameraNode.childNode(withName: "quitConfirmationOverlay") else { return }
        
        let scaleDown = SKAction.scale(to: 0.8, duration: 0.15)
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        
        overlay.run(.group([scaleDown, fadeOut])) {
            overlay.removeFromParent()
        }
    }
    
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
            self.appState?.route = .journeyV
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              isDraggingFlashlight,
              cameraNode.childNode(withName: "quitConfirmationOverlay") == nil
        else { return }
        
        // Dismiss any plus overlay when user starts dragging
        for child in cameraNode.children {
            if let name = child.name, name.hasPrefix("plusOverlay_") {
                let planetID = String(name.dropFirst("plusOverlay_".count))
                dismissPlantDiscoveryOverlay(planetID: planetID)
            }
        }
        
        let location = touch.location(in: self)
        flashlight.position = location
        updateCameraPosition()
    }
    
    private var hasActiveOverlay: Bool {
        cameraNode.children.contains {
            $0.name?.hasPrefix("plusOverlay_") == true ||
            $0.name?.hasPrefix("cardOverlay_") == true ||
            $0.name == "quitConfirmationOverlay" ||
            $0.name == "instructionOverlay"
        }
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
    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isDraggingFlashlight = false
//        
//        let hasActiveOverlay = cameraNode.children.contains {
//            $0.name?.hasPrefix("plantDiscoveryOverlay_") == true
//        }
//        
//        if !hasActiveOverlay {
//            let targetPosition = cameraNode.position
//            let snapBack = SKAction.move(to: targetPosition, duration: 0.3)
//            snapBack.timingMode = .easeOut
//            flashlight.run(snapBack)
//        }
//        
////        let targetPosition = cameraNode.position
////        let snapBack = SKAction.move(to: targetPosition, duration: 0.3)
////        snapBack.timingMode = .easeOut
////        flashlight.run(snapBack)
//    }
    
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

            // Tighter reveal radius — feels more like a real flashlight
            let fullRevealDistance: CGFloat = 120
            let fadeStartDistance: CGFloat = 220

            let targetAlpha: CGFloat
            if distance < fullRevealDistance {
                targetAlpha = 1.0
            } else if distance < fadeStartDistance {
                // Smooth falloff between full reveal and fade start
                let t = (distance - fullRevealDistance) / (fadeStartDistance - fullRevealDistance)
                targetAlpha = 1.0 - t
            } else {
                targetAlpha = 0.0
            }

            // Lerp current alpha toward target — slower reveal, faster fade
            let lerpSpeed: CGFloat = distance < planet.alpha * fadeStartDistance ? 0.04 : 0.06
            planet.alpha += (targetAlpha - planet.alpha) * lerpSpeed
        }
    }
    
    private func checkPlanetDiscovery() {
        // Don't trigger new overlays while one is already showing or dismissing
        guard !hasActiveOverlay else { return }
        
        let flashlightPos = flashlight.position
        
        planetsContainer.children.forEach { node in
            guard let planet = node as? SKSpriteNode,
                  let planetID = planet.name else { return }
            
            if planetsDiscovered.contains(planetID) { return }
            if planetsShowingButton.contains(planetID) { return }
            
            let distance = hypot(
                planet.position.x - flashlightPos.x,
                planet.position.y - flashlightPos.y
            )
            
            if distance < 72 {
                if let itemID = planetItemMapping[planetID] {
                    showPlantDiscoveryOverlay(planetID: planetID, itemID: itemID)
                }
            }
        }
    }
    
    private func showPlantDiscoveryOverlay(planetID: String, itemID: ItemID) {
        guard let item = ItemData.getItem(by: itemID) else { return }
        
        isDraggingFlashlight = false
        planetsShowingButton.insert(planetID)
        
        let overlay = SKNode()
        overlay.name = "plusOverlay_\(planetID)"
        overlay.zPosition = 300
        
        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.3),
                             size: CGSize(width: size.width, height: size.height))
        bg.position = .zero
        overlay.addChild(bg)
        
        let plusButton = SKShapeNode(circleOfRadius: 24)
        plusButton.fillColor = .white.withAlphaComponent(0.9)
        plusButton.strokeColor = .clear
        plusButton.name = "plusButton_\(planetID)"
        plusButton.position = .zero
        overlay.addChild(plusButton)
        
        let plusLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        plusLabel.text = "+"
        plusLabel.fontSize = 28
        plusLabel.fontColor = .black
        plusLabel.verticalAlignmentMode = .center
        plusLabel.name = "plusLabel"
        plusLabel.position = .zero
        plusButton.addChild(plusLabel)
        
        cameraNode.addChild(overlay)
        overlay.alpha = 0
        overlay.run(.fadeIn(withDuration: 0.3))
        
        HapticManger.instance.impact(style: .light)
    }

    private func showCardOverlay(planetID: String, itemID: ItemID) {
        guard let item = ItemData.getItem(by: itemID) else { return }
        
        let overlay = SKNode()
        overlay.name = "cardOverlay_\(planetID)"
        overlay.zPosition = 300
        
        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.3),
                             size: CGSize(width: size.width, height: size.height))
        bg.position = .zero
        overlay.addChild(bg)
        
        // Checkmark button at top
        let checkButton = SKShapeNode(circleOfRadius: 24)
        checkButton.fillColor = .green.withAlphaComponent(0.9)
        checkButton.strokeColor = .clear
        checkButton.position = CGPoint(x: 0, y: 80)
        overlay.addChild(checkButton)
        
        let checkLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        checkLabel.text = "✓"
        checkLabel.fontSize = 24
        checkLabel.fontColor = .white
        checkLabel.verticalAlignmentMode = .center
        checkButton.addChild(checkLabel)
        
        // Card slides up from below
        let cardNode = buildItemCard(item: item)
        cardNode.name = "itemCard"
        cardNode.position = CGPoint(x: 0, y: -size.height * 0.5)
        cardNode.alpha = 0
        overlay.addChild(cardNode)
        
        cameraNode.addChild(overlay)
        overlay.alpha = 0
        overlay.run(.fadeIn(withDuration: 0.2))
        
        // Slide card up
        let slideUp = SKAction.move(to: CGPoint(x: 0, y: -40), duration: 0.45)
        slideUp.timingMode = .easeOut
        let fadeIn = SKAction.fadeIn(withDuration: 0.35)
        cardNode.run(.group([slideUp, fadeIn]))
        
        // Auto-dismiss after 5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            overlay.run(.fadeOut(withDuration: 0.4)) {
                overlay.removeFromParent()
            }
        }
    }

    private func handlePlusButtonTap(planetID: String, itemID: ItemID) {
        guard !planetsDiscovered.contains(planetID) else { return }
        
        // Remove plus overlay
        if let plusOverlay = cameraNode.childNode(withName: "plusOverlay_\(planetID)") {
            plusOverlay.run(.fadeOut(withDuration: 0.2)) {
                plusOverlay.removeFromParent()
            }
        }
        
        planetsDiscovered.insert(planetID)
        appState?.discoverItem(itemID)
        
        HapticManger.instance.impact(style: .medium)
        SoundManger.instance.playSound(sound: .card)
        
        // Show card overlay after brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.showCardOverlay(planetID: planetID, itemID: itemID)
        }
        
        if planetsDiscovered.count >= requiredPlanets {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
                self.completeExploration()
            }
        }
    }
    
    private func buildItemCard(item: Item) -> SKNode {
        let container = SKNode()
        
        let cardWidth: CGFloat = size.width * 0.8
        let cardHeight: CGFloat = size.height * 0.20
        let card = SKShapeNode(rectOf: CGSize(width: cardWidth, height: cardHeight), cornerRadius: 20)
        
        if let imageName = item.imageName {
            card.fillTexture = SKTexture(imageNamed: imageName)
            card.fillColor = .white
        } else {
            card.fillColor = .black.withAlphaComponent(0.8)
        }
        
        card.strokeColor = .white.withAlphaComponent(0.3)
        card.lineWidth = 2
        card.position = .zero
        container.addChild(card)
        
        let nameLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        nameLabel.text = item.name
        nameLabel.fontSize = 18
        nameLabel.fontColor = .white
        nameLabel.position = CGPoint(x: 0, y: -(cardHeight / 2) - 24)
        container.addChild(nameLabel)
        
        return container
    }

    private func handlePlusButtonTapold(planetID: String, itemID: ItemID) {
        guard let overlay = cameraNode.childNode(withName: "plantDiscoveryOverlay_\(planetID)") else { return }
        guard let plusButton = overlay.childNode(withName: "plusButton_\(planetID)") as? SKShapeNode else { return }
        guard let itemCard = overlay.childNode(withName: "itemCard") else { return }
        
        // Guard against double-tap
        guard !planetsDiscovered.contains(planetID) else { return }
        
        planetsDiscovered.insert(planetID)
        appState?.discoverItem(itemID)
        
        HapticManger.instance.impact(style: .medium)
        SoundManger.instance.playSound(sound: .card)
        
        // Swap plus → checkmark
        plusButton.childNode(withName: "plusLabel")?.removeFromParent()
        plusButton.fillColor = .green.withAlphaComponent(0.8)
        
        let checkLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        checkLabel.text = "✓"
        checkLabel.fontSize = 20
        checkLabel.fontColor = .white
        checkLabel.verticalAlignmentMode = .center
        plusButton.addChild(checkLabel)
        
        let pulse = SKAction.sequence([
            .scale(to: 1.2, duration: 0.15),
            .scale(to: 1.0, duration: 0.15)
        ])
        let moveButtonUp = SKAction.move(to: CGPoint(x: 0, y: 80), duration: 0.4)
        moveButtonUp.timingMode = .easeOut
        
        // After moving up, fade the button out and remove it
        let fadeOutButton = SKAction.fadeOut(withDuration: 0.2)
        let removeButton = SKAction.removeFromParent()
        plusButton.run(.sequence([pulse, moveButtonUp, fadeOutButton, removeButton]))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            let slideUp = SKAction.move(to: CGPoint(x: 0, y: -40), duration: 0.45)
            slideUp.timingMode = .easeOut
            let fadeIn = SKAction.fadeIn(withDuration: 0.35)
            itemCard.run(.group([slideUp, fadeIn]))
        }
        
        // Auto-dismiss after 5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            overlay.run(.fadeOut(withDuration: 0.4)) {
                overlay.removeFromParent()
            }
        }
        
        if planetsDiscovered.count >= requiredPlanets {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
                self.completeExploration()
            }
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
    
    private func showCompletionOverlay() {
        let overlay = SKNode()
        overlay.name = "completionOverlay"
        overlay.zPosition = 350
        
        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.8), size: size)
        overlay.addChild(bg)
        
        let title = SKLabelNode(fontNamed: "Arial-BoldMT")
        title.text = "Exploration Complete!"
        title.fontSize = 24
        title.fontColor = .white
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
    
    // ✅ Show full-screen overlay with plus button
//    private func showPlantDiscoveryOverlay(planetID: String, itemID: ItemID) {
//        guard let item = ItemData.getItem(by: itemID) else { return }
//        
//        // ✅ Stop flashlight movement when overlay appears
//        isDraggingFlashlight = false
//        
//        // Prevent showing multiple times
//        planetsShowingButton.insert(planetID)
//        
//        let overlay = SKNode()
//        overlay.name = "plantDiscoveryOverlay_\(planetID)"
//        overlay.zPosition = 300
//        
//        // Semi-transparent background
//        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.3),
//                             size: CGSize(width: size.width, height: size.height))
//        bg.position = .zero
//        overlay.addChild(bg)
//        
//        // Plus button
//        let plusButton = SKShapeNode(circleOfRadius: 20)
//        plusButton.fillColor = .white.withAlphaComponent(0.8)
//        plusButton.strokeColor = .clear
//        plusButton.name = "plusButton_\(planetID)"
//        plusButton.position = CGPoint(x: 0, y: 0)
//        overlay.addChild(plusButton)
//        
//        // Plus icon
//        let plusLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
//        plusLabel.text = "+"
//        plusLabel.fontSize = 24
//        plusLabel.fontColor = .black
//        plusLabel.verticalAlignmentMode = .center
//        plusLabel.name = "plusLabel"
//        plusLabel.position = .zero
//        plusButton.addChild(plusLabel)
//        
//        cameraNode.addChild(overlay)
//        
//        // Fade in animation
//        overlay.alpha = 0
//        overlay.run(.fadeIn(withDuration: 0.3))
//        
//        HapticManger.instance.impact(style: .light)
//        
//        print("➕ Showing plus button for \(planetID)")
//    }
//    
//    // ✅ Handle plus button tap - change to green checkmark, then show image
//    private func handlePlusButtonTap(planetID: String, itemID: ItemID) {
//        guard let overlay = cameraNode.childNode(withName: "plantDiscoveryOverlay_\(planetID)") else { return }
//        guard let plusButton = overlay.childNode(withName: "plusButton_\(planetID)") as? SKShapeNode else { return }
//        
//        // Mark as discovered
//        planetsDiscovered.insert(planetID)
//        appState?.discoverItem(itemID)
//        
//        // Haptic feedback
//        HapticManger.instance.impact(style: .medium)
//        SoundManger.instance.playSound(sound: .card)
//        
//        // Change to green checkmark
//        plusButton.fillColor = .green.withAlphaComponent(0.8)
//        
//        // Remove plus label
//        plusButton.childNode(withName: "plusLabel")?.removeFromParent()
//        
//        // Add checkmark
//        let checkLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
//        checkLabel.text = "✓"
//        checkLabel.fontSize = 20
//        checkLabel.fontColor = .white
//        checkLabel.verticalAlignmentMode = .center
//        plusButton.addChild(checkLabel)
//        
//        // Pulse animation
//        let pulse = SKAction.sequence([
//            .scale(to: 1.2, duration: 0.15),
//            .scale(to: 1.0, duration: 0.15)
//        ])
//        plusButton.run(pulse)
//        
//        // Update counter
////        updateCounter()
////        
//        print("✅ Collected: \(planetID). Counter: \(planetsDiscovered.count)/\(requiredPlanets)")
//        
//        // Wait 1 second, then dismiss name+button overlay and show image
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            // Dismiss the name+button overlay
//            overlay.run(.fadeOut(withDuration: 0.3)) {
//                overlay.removeFromParent()
//            }
//            
//            // Show the plant image preview
//            self.showItemPreview(itemID: itemID)
//        }
//        
//        // Check completion
//        if planetsDiscovered.count >= requiredPlanets {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
//                self.completeExploration()
//            }
//        }
//    }
//    
//    // ✅ Show item preview - full screen with image
//    private func showItemPreview(itemID: ItemID) {
//        guard let item = ItemData.getItem(by: itemID) else { return }
//        
//        let overlay = SKNode()
//        overlay.name = "itemPreview"
//        overlay.zPosition = 300
//        
//        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.3),
//                             size: CGSize(width: size.width, height: size.height))
//        bg.position = .zero
//        overlay.addChild(bg)
//        
//        // Rounded rectangle container with optional texture fill
//        if let imageName = item.imageName {
//            let cardWidth: CGFloat = size.width * 0.8
//            let cardHeight: CGFloat = size.height * 0.20
//            let card = SKShapeNode(rectOf: CGSize(width: cardWidth, height: cardHeight), cornerRadius: 20)
//            // SKTexture(imageNamed:) is non-optional; assign directly
//            let texture = SKTexture(imageNamed: imageName)
//            card.fillTexture = texture
//            card.fillColor = .white // ensure texture shows
//            card.strokeColor = .white.withAlphaComponent(0.3)
//            card.lineWidth = 2
//            card.position = .zero
//            overlay.addChild(card)
//            
//            // Item name label added to the same card
//            let nameLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
//            nameLabel.text = item.name
//            nameLabel.fontSize = 18
//            nameLabel.fontColor = .white
//            nameLabel.position = CGPoint(x: 0, y: -120)
//            overlay.addChild(nameLabel)
//        } else {
//            // Fallback: show name centered if no imageName
//            let nameLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
//            nameLabel.text = item.name
//            nameLabel.fontSize = 18
//            nameLabel.fontColor = .white
//            nameLabel.position = CGPoint(x: 0, y: 0)
//            overlay.addChild(nameLabel)
//        }
//        
//        cameraNode.addChild(overlay)
//        
//        // Auto-dismiss after 5 seconds
//        let wait = SKAction.wait(forDuration: 5.0)
//        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
//        overlay.run(.sequence([wait, fadeOut])) {
//            overlay.removeFromParent()
//        }
//    }
    

