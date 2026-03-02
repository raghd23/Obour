//
//  JourneyViewModel.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Foundation
import Combine

final class JourneyViewModel: ObservableObject {
    weak var appState: AppState?
    
    func startJourney() {
        print("🚀 Starting journey: \(appState?.journey.title ?? "Unknown")")
    }
}
