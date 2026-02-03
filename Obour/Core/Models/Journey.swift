//
//  Journey.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
// Foundation provides UUID and basic data types
import Foundation

// Identifiable allows SwiftUI to track journeys uniquely
struct Journey: Identifiable {
    
    // Unique identifier for this journey
    let id: UUID
    
    // Display name shown to the user
    let title: String
    
    // Ordered list of scenes that make up the journey
    // Each scene represents a moment in time
    //let scenes: [JourneyScene]
}
