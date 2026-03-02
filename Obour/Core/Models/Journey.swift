//
//  Journey.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Foundation

typealias JourneyID = String
typealias SceneID = String

// MARK: - Journey Model
struct Journey: Identifiable, Codable, Hashable {
    let id: JourneyID
    let title: String
    let description: String
    
    /// UI-specific fields
    let outline: String?
    let subOutline: String?
    let imageName: String?

    /// Ordered flow: walk → fireStory → nightExploration → sunrise
    let scenes: [JourneyScene]

    /// Controls timing, grace, lost detection, guidance strength
    let journeyRules: JourneyRules
}

// MARK: - Journey Scene
struct JourneyScene: Codable, Hashable {
    let id: SceneID
    let type: SceneType
    let backgroundKey: String?
    let ambientAudioKey: String?
    let itemSpots: [String]  // For future use
    
    enum SceneType: String, Codable {
        case walk
        case fireStory
        case exploration  // Night exploration - only scene that collects items
        case sunrise
    }
}

// MARK: - Journey Rules
struct JourneyRules: Codable, Hashable {
    let softLimitSeconds: Int
    let hardLimitSeconds: Int
    let lostNoProgressSeconds: Int
    let graceVolumeMultiplier: Double
    let lostVolumeMultiplier: Double
}

// MARK: - Sample Journey Data
extension Journey {
    static let desertJourney = Journey(
        id: "desert-red-horizon",
        title: "Red Horizon",
        description: String(localized:"A journey that takes you from the tales of travelers and the stillness of the sands to exploring the secrets of desert plants and collecting their treasures."),
        outline: String(localized:"Red"),
        subOutline: String(localized:"Horizon"),
        imageName: "RedSunMounten",
        scenes: [
            JourneyScene(
                id: "walk",
                type: .walk,
                backgroundKey: nil,
                ambientAudioKey: nil,
                itemSpots: []
            ),
            JourneyScene(
                id: "fire",
                type: .fireStory,
                backgroundKey: nil,
                ambientAudioKey: nil,
                itemSpots: []
            ),
            JourneyScene(
                id: "night",
                type: .exploration,
                backgroundKey: nil,
                ambientAudioKey: nil,
                itemSpots: ["plant-1", "plant-2", "plant-3"]  // Items to find in night exploration
            ),
            JourneyScene(
                id: "sunrise",
                type: .sunrise,
                backgroundKey: nil,
                ambientAudioKey: nil,
                itemSpots: []
            )
        ],
        journeyRules: JourneyRules(
            softLimitSeconds: 600,
            hardLimitSeconds: 900,
            lostNoProgressSeconds: 120,
            graceVolumeMultiplier: 1.2,
            lostVolumeMultiplier: 0.8
        )
    )
}
