//
//  JourneyViewModel.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Observation

@Observable
final class JourneyViewModel {

    let journey: Journey
    var hasStarted: Bool = false

    init(journey: Journey) {
        self.journey = journey
    }

    func startJourney() {
        hasStarted = true
    }
}

