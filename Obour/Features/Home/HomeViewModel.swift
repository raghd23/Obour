//
//  HomeViewModel.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    
    // The current journey displayed
    @Published var currentJourney: Journey?
    
    // All journeys in the catalog (shared between views)
    @Published var journeys: [Journey] = []
    
    // MARK: - Initializer
    init(catalog: JourneyCatalog? = nil) {
        if let catalog = catalog {
            journeys = catalog.journeys
        }
        currentJourney = journeys.first
    }
    
    // Converts Figma-style RGB to SwiftUI Color
    func calculateRGB(r: Double, g: Double, b: Double, o: Double = 1.0) -> Color {
        Color(red: r/255, green: g/255, blue: b/255, opacity: o)
    }
    
    // Returns the background gradient based on currentJourney
    func backgroundGradient() -> LinearGradient {
        // For now, default if no journey
        guard let journey = currentJourney else {
            return LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: calculateRGB(r: 80, g: 22, b: 10), location: 0.37),
                    .init(color: calculateRGB(r: 34, g: 7, b: 2), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        
        // Optional: Map a journey.scene.backgroundKey to gradient colors if needed
        // For simplicity, assign fixed colors per journey for now
        switch journey.id {
        case "desert":
            return LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: calculateRGB(r: 80, g: 22, b: 10), location: 0.37),
                    .init(color: calculateRGB(r: 34, g: 7, b: 2), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        case "sea":
            return LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: calculateRGB(r: 20, g: 60, b: 80), location: 0.3),
                    .init(color: calculateRGB(r: 5, g: 25, b: 40), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        default:
            return LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: calculateRGB(r: 80, g: 22, b: 10), location: 0.37),
                    .init(color: calculateRGB(r: 34, g: 7, b: 2), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    // MARK: - Card swipe handling
    func rotateJourneys() {
        SoundManger.instance.playSound(sound: .card)
        HapticManger.instance.impact(style: .medium)
        guard !journeys.isEmpty else { return }
        let first = journeys.removeFirst()
        journeys.append(first)
        currentJourney = journeys.first
    }
#if DEBUG
static let preview: HomeViewModel = {
    let vm = HomeViewModel()
    vm.journeys = [
        Journey(
            id: "desert",
            title: "Journey In The Sand",
            description: "Mystery in the desert, light at the end",
            outline: "Red Horizon",
            subOutline: "10:00",
            imageName: "DesertCard",
            scenes: [],
            items: [],
            requiredItemIDs: [],
            journeyRules: JourneyRules(
                softLimitSeconds: 480,
                hardLimitSeconds: 600,
                lostNoProgressSeconds: 120,
                graceVolumeMultiplier: 1.2,
                lostVolumeMultiplier: 1.5
            )
        ),
        Journey(
            id: "sea",
            title: "Journey In The Sea",
            description: "Depth, waves, call of the see",
            outline: "Blue Horizon",
            subOutline: "12:00",
            imageName: "seaCard",
            scenes: [],
            items: [],
            requiredItemIDs: [],
            journeyRules: JourneyRules(
                softLimitSeconds: 600,
                hardLimitSeconds: 720,
                lostNoProgressSeconds: 150,
                graceVolumeMultiplier: 1.1,
                lostVolumeMultiplier: 1.4
            )
        )
    ]
    vm.currentJourney = vm.journeys.first
    return vm
}()
#endif

}

