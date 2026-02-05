//
//  JourneyArchive.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Foundation

struct JourneyArchive: Codable, Hashable {
    /// One record per journey
    var journeys: [JourneyID: JourneyRecord]
}
