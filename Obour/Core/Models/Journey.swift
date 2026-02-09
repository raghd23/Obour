//
//  Journey.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Foundation

typealias JourneyID = String
typealias SceneID   = String
typealias ItemID    = String

struct Journey: Identifiable, Codable, Hashable {
    let id: JourneyID
    let title: String
    let description: String

    /// Ordered flow: walk → fireStory → nightExploration → sunrise
    let scenes: [JourneyScene]

    /// Items that belong to this journey only
    let items: [Items]

    /// Required to trigger completed sunrise early
    let requiredItemIDs: [ItemID]

    /// Controls timing, grace, lost detection, guidance strength
    let journeyRules: JourneyRules
}
