//
//  DesertScene.swift
//  Obour
//

import SpriteKit
import AVFoundation
import CoreMotion

final class DesertScene: SKScene {

    // MARK: - Navigation
    var onReachEnd: (() -> Void)?

    enum ControlMode { case holdToMove, tiltToMove, autoScroll }
    private var controlMode: ControlMode = .autoScroll

    // MARK: - Nodes
    private var world: SKNode!
    private var hud: SKNode!
    private var backgroundNode: SKSpriteNode!
    private var mountainsNode: SKSpriteNode!
    private var tentNode: SKSpriteNode!
    private var fireNode: SKSpriteNode!
    private var moonNode: SKSpriteNode!
    private var manNode: SKSpriteNode!
    private var smokeNode: SKSpriteNode!

    // Fade overlay
    private var fadeNode: SKSpriteNode!

    // MARK: - Camera
    private let cameraNode = SKCameraNode()

    // MARK: - Bounds
    private var minCameraX: CGFloat = 0
    private var maxCameraX: CGFloat = 0

    // MARK: - State
    private var didTriggerEnd = false
    private var lastTime: TimeInterval = 0

    // MARK: - Hold Control
    private var isTouching = false
    private var holdDirection: CGFloat = 0
    private let holdSpeed: CGFloat = 900

    // MARK: - Tilt Control
    private let motion = CMMotionManager()
    private let tiltSpeed: CGFloat = 1200
    private let tiltDeadZone: CGFloat = 0.06
    private let tiltNormalizeDivisor: CGFloat = 0.6

    // MARK: - Auto Scroll
    private let autoSpeed: CGFloat = 400
    private var autoDirection: CGFloat = 1

    // MARK: - Audio
    private var musicPlayer: AVAudioPlayer?

    // MARK: - Scene Setup
    override func didMove(to view: SKView) {

        size = view.bounds.size
        scaleMode = .resizeFill
        anchorPoint = .zero

        view.ignoresSiblingOrder = true
        view.shouldCullNonVisibleNodes = true
        view.isAsynchronous = true

        guard
            let w = childNode(withName: "//world"),
            let h = childNode(withName: "//hud")
        else {
            assertionFailure("Missing //world or //hud")
            return
        }

        world = w
        hud = h

        guard
            let bg   = world.childNode(withName: "background") as? SKSpriteNode,
            let mts  = world.childNode(withName: "mountains")  as? SKSpriteNode,
            let tent = world.childNode(withName: "tent")       as? SKSpriteNode,
            let fire = world.childNode(withName: "fire")       as? SKSpriteNode,
            let moon = world.childNode(withName: "moon")       as? SKSpriteNode,
            let man  = world.childNode(withName: "man")        as? SKSpriteNode,
            let smoke = world.childNode(withName: "smoke")     as? SKSpriteNode
        else {
            assertionFailure("Missing named sprites")
            return
        }

        backgroundNode = bg
        mountainsNode = mts
        tentNode = tent
        fireNode = fire
        moonNode = moon
        manNode = man
        smokeNode = smoke

        // MARK: Camera Setup
        camera = cameraNode
        addChild(cameraNode)
        cameraNode.position = CGPoint(x: size.width * 0.5,
                                      y: size.height * 0.5)

        // Attach HUD to camera
        hud.removeFromParent()
        cameraNode.addChild(hud)
        hud.position = .zero
        hud.zPosition = 10_000

        computeCameraBounds()

        if controlMode == .tiltToMove {
            startMotion()
        }

        // MARK: Fade Setup
        fadeNode = SKSpriteNode(color: .black, size: size)
        fadeNode.position = .zero
        fadeNode.zPosition = 20_000
        fadeNode.alpha = 1
        cameraNode.addChild(fadeNode)

        // Fade IN
        fadeNode.run(.fadeOut(withDuration: 1.0))

        // Background music
        SoundManger.instance.playBackgroundMusic()
    }

    override func willMove(from view: SKView) {
        stopMotion()
        SoundManger.instance.stopBackgroundMusic()
    }

    // MARK: - Update Loop
    override func update(_ currentTime: TimeInterval) {

        let dt = lastTime == 0 ? 0 : (currentTime - lastTime)
        lastTime = currentTime
        guard dt > 0 else { return }

        switch controlMode {

        case .holdToMove:
            if isTouching, holdDirection != 0 {
                let dx = holdSpeed * CGFloat(dt) * holdDirection
                cameraNode.position.x =
                    clamp(cameraNode.position.x + dx,
                          minCameraX, maxCameraX)
            }

        case .tiltToMove:
            let input = tiltInput()
            if input != 0 {
                let dx = tiltSpeed * CGFloat(dt) * input
                cameraNode.position.x =
                    clamp(cameraNode.position.x + dx,
                          minCameraX, maxCameraX)
            }

        case .autoScroll:
            let dx = autoSpeed * CGFloat(dt) * autoDirection
            cameraNode.position.x =
                clamp(cameraNode.position.x + dx,
                      minCameraX, maxCameraX)
        }

        cameraNode.position.y = size.height * 0.5

        // Trigger transition
        if !didTriggerEnd {
            let tentX = tentNode.convert(.zero, to: self).x
            let endThresholdX = min(maxCameraX, tentX)

            if cameraNode.position.x >= endThresholdX - 10 {
                didTriggerEnd = true
                goToTravellerStory()
            }
        }
    }

    // MARK: - Fade Transition
    private func goToTravellerStory() {

        stopMotion()

        let fadeOut = SKAction.fadeIn(withDuration: 1.0)

        fadeNode.run(fadeOut) { [weak self] in
            DispatchQueue.main.async {
                self?.onReachEnd?()
            }
        }
    }

    // MARK: - Touch Controls
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard controlMode == .holdToMove,
              let t = touches.first else { return }

        isTouching = true
        updateHoldDirection(from: t)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard controlMode == .holdToMove,
              isTouching,
              let t = touches.first else { return }

        updateHoldDirection(from: t)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard controlMode == .holdToMove else { return }
        isTouching = false
        holdDirection = 0
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    private func updateHoldDirection(from touch: UITouch) {
        guard let v = view else { return }
        let p = touch.location(in: v)
        holdDirection = (p.x >= v.bounds.midX) ? 1 : -1
    }

    // MARK: - Motion
    private func startMotion() {
        guard motion.isDeviceMotionAvailable else { return }
        motion.deviceMotionUpdateInterval = 1.0 / 60.0
        motion.startDeviceMotionUpdates()
    }

    private func stopMotion() {
        motion.stopDeviceMotionUpdates()
    }

    private func tiltInput() -> CGFloat {
        guard let roll = motion.deviceMotion?.attitude.roll else { return 0 }

        var x = CGFloat(roll) / tiltNormalizeDivisor
        x = max(-1, min(1, x))

        if abs(x) < tiltDeadZone { return 0 }
        return x
    }

    // MARK: - Camera Bounds
    private func computeCameraBounds() {

        let worldFrame = world.calculateAccumulatedFrame()
        let halfW = size.width * 0.5

        minCameraX = worldFrame.minX + halfW
        maxCameraX = worldFrame.maxX - halfW

        if maxCameraX < minCameraX {
            maxCameraX = minCameraX
        }

        cameraNode.position.x =
            clamp(cameraNode.position.x,
                  minCameraX, maxCameraX)

        cameraNode.position.y = size.height * 0.5
    }

    // MARK: - Utility
    private func clamp(_ v: CGFloat,
                       _ minV: CGFloat,
                       _ maxV: CGFloat) -> CGFloat {
        max(minV, min(maxV, v))
    }
}
