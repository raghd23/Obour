//
//  JourneyRecord.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Foundation

struct JourneyRecord: Codable, Hashable {
    /// Items discovered in this journey
    var collectedItemIDs: Set<ItemID>

    /// Optional resume support (future-proof)
    var lastSceneID: SceneID?
    var explorationElapsedSeconds: Double?
    var lastCollectedSecond: Double?

    /// Outcome of the last run
    var lastSunriseCompleted: Bool?
}
