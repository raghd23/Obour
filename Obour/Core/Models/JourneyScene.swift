//
//  Scene.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Foundation

struct JourneyScene: Identifiable, Codable, Hashable {
    let id: SceneID
    let type: SceneType

    /// Optional aesthetic hooks
    let backgroundKey: String?
    let ambientAudioKey: String?

    /// Only meaningful for exploration scenes (empty otherwise)
    let itemSpots: [ItemSpot]
}

enum SceneType: String, Codable, Hashable {
    case walk
    case fireStory
    case exploration
    case sunrise
}

