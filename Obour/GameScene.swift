//
//  GameScene.swift
//  Obour
//
//  Created by Raghad Alzemami on 14/08/1447 AH.
//
/*
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
*/

//
//  GameScene.swift
//  Obour
//
//  Created by Raghad Alzemami on 14/08/1447 AH.
//
import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - Nodes
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    private var moon: SKSpriteNode?
    private let cameraNode = SKCameraNode()

    // MARK: - Scene lifecycle
    override func didMove(to view: SKView) {

        // MARK: Camera
        camera = cameraNode
        addChild(cameraNode)
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)

        // MARK: Label
        label = childNode(withName: "//helloLabel") as? SKLabelNode
        label?.alpha = 0.0
        label?.run(.fadeIn(withDuration: 2.0))

        // MARK: Moon 🌙
        setupMoon()
        runMoonPulse()
        runMoonFloat()

        // MARK: Spinny node (interaction effect)
        let w = (size.width + size.height) * 0.05
        spinnyNode = SKShapeNode(
            rectOf: CGSize(width: w, height: w),
            cornerRadius: w * 0.3
        )

        if let spinnyNode = spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(.repeatForever(.rotate(byAngle: .pi, duration: 1)))
            spinnyNode.run(
                .sequence([
                    .wait(forDuration: 0.5),
                    .fadeOut(withDuration: 0.5),
                    .removeFromParent()
                ])
            )
        }

        // MARK: Start scene movement
        startSceneMovement()
    }

    // MARK: - Moon Setup
    private func setupMoon() {
        guard let moonNode = childNode(withName: "//Moon") as? SKSpriteNode else {
            print("❌ Moon not found in scene")
            return
        }

        // Store reference
        self.moon = moonNode

        // Detach from world
        moonNode.removeFromParent()

        // Position relative to screen
        moonNode.position = CGPoint(
            x: size.width * 0.35,
            y: size.height * 0.7
        )

        moonNode.zPosition = 1000
        cameraNode.addChild(moonNode)
    }

    // MARK: - Moon Actions
    private func runMoonPulse() {
        guard let moonNode = moon,
              let pulse = SKAction(named: "Pulse") else {
            return
        }

        pulse.speed = 0.6
        moonNode.run(.repeatForever(pulse), withKey: "moonPulse")
    }

    private func runMoonFloat() {
        guard let moonNode = moon else { return }

        let moveUp = SKAction.moveBy(x: 0, y: 12, duration: 4)
        let moveDown = SKAction.moveBy(x: 0, y: -12, duration: 4)

        moveUp.timingMode = .easeInEaseOut
        moveDown.timingMode = .easeInEaseOut

        let float = SKAction.sequence([moveUp, moveDown])
        moonNode.run(.repeatForever(float), withKey: "moonFloat")
    }

    // MARK: - Scene Movement
    private func startSceneMovement() {
        let moveRight = SKAction.moveBy(x: 300, y: 0, duration: 20)
        moveRight.timingMode = .linear

        let moveLeft = moveRight.reversed()
        let movement = SKAction.sequence([moveRight, moveLeft])

        cameraNode.run(.repeatForever(movement), withKey: "cameraMovement")
    }

    // MARK: - Touch helpers
    func touchDown(atPoint pos: CGPoint) {
        if let n = spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = .green
            addChild(n)
        }
    }

    func touchMoved(toPoint pos: CGPoint) {
        if let n = spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = .blue
            addChild(n)
        }
    }

    func touchUp(atPoint pos: CGPoint) {
        if let n = spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = .red
            addChild(n)
        }
    }

    // MARK: - Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let label = label,
           let pulse = SKAction(named: "Pulse") {
            label.run(pulse, withKey: "labelPulse")
        }

        for t in touches {
            touchDown(atPoint: t.location(in: self))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchMoved(toPoint: t.location(in: self))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchUp(atPoint: t.location(in: self))
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchUp(atPoint: t.location(in: self))
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Future audio / emotion driven motion
    }
}
