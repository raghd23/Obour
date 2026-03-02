//
//  JourneyCatalog.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

//import Foundation
//
//struct JourneyCatalog: Codable, Hashable {
//    let journeys: [Journey]
//}
import Foundation

struct JourneyCatalog: Codable, Hashable {
    let journeys: [Journey]

    // ✅ Add this initializer
    init(journeys: [Journey] = JourneyCatalog.defaultJourneys) {
        self.journeys = journeys
    }

    // ✅ Add default journeys here
    static let defaultJourneys: [Journey] = [
        Journey(
            id: "desert",
            title: "Journey In The Sand",
            description: "Mystery in the desert, light at the end",
            outline: "Red Horizon",
            subOutline: "10:00",
            imageName: "DesertCard",
            scenes: [],
            journeyRules: JourneyRules(
                softLimitSeconds: 480,
                hardLimitSeconds: 600,
                lostNoProgressSeconds: 120,
                graceVolumeMultiplier: 1.2,
                lostVolumeMultiplier: 1.5
            )
        )
    ]
}
