//
//  JourneyRules.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Foundation

struct JourneyRules: Codable, Hashable {
    /// Grace begins after this (e.g. 480 = 8 min)
    let softLimitSeconds: Double

    /// Absolute end of exploration (e.g. 600 = 10 min)
    let hardLimitSeconds: Double

    /// Considered "lost" if no item collected for X seconds
    let lostNoProgressSeconds: Double

    /// Guidance amplification
    let graceVolumeMultiplier: Double
    let lostVolumeMultiplier: Double
}
