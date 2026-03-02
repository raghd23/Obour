//
//  AppState.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
// Combine is required for ObservableObject and @Published
import Foundation
import Combine

final class AppState: ObservableObject {

    // MARK: - Navigation Routes
    enum Route: Hashable {
        case splash
        case journeyV
        case desertWalking
        case desertFireStory
        case nightExploration
        case collection
        case end
    }
    
    // MARK: - Published Properties
    
    /// Current navigation route
    @Published var route: Route = .splash
    
    /// The single desert journey (just metadata, no item tracking)
    let journey: Journey = .desertJourney
    
    /// ✅ Track discovered items separately (persisted)
    @Published var discoveredItemIDs: Set<ItemID> = []
    
    // MARK: - Computed Properties
    
    /// Get all discovered items as Item objects
    var discoveredItems: [Item] {
        discoveredItemIDs.compactMap { ItemData.getItem(by: $0) }
    }
    
    /// Check if all items are discovered
    var isComplete: Bool {
        let requiredItems = ["plant-1", "plant-2", "plant-3"]
        return requiredItems.allSatisfy { discoveredItemIDs.contains($0) }
    }
    
    /// Progress count
    var discoveryProgress: String {
        "\(discoveredItemIDs.count)/3"
    }
    
    // MARK: - Item Discovery
    
    /// Discover an item in night exploration
    func discoverItem(_ itemID: ItemID) {
        // Verify item exists
        guard ItemData.getItem(by: itemID) != nil else {
            print("⚠️ Warning: Item '\(itemID)' doesn't exist in ItemData")
            return
        }
        
        // Don't add duplicates
        guard !discoveredItemIDs.contains(itemID) else {
            print("ℹ️ Item '\(itemID)' already discovered")
            return
        }
        
        discoveredItemIDs.insert(itemID)
        saveProgress()
        
        print("✅ Item '\(itemID)' discovered!")
        print("📊 Progress: \(discoveryProgress)")
    }
    
    /// Reset all discoveries (for testing/replay)
    func resetProgress() {
        discoveredItemIDs.removeAll()
        saveProgress()
        print("🔄 Progress reset")
    }
    
    // MARK: - Persistence
    
    private let discoveryKey = "discovered_items"
    
    /// Save discovered items to UserDefaults
    private func saveProgress() {
        let itemsArray = Array(discoveredItemIDs)
        UserDefaults.standard.set(itemsArray, forKey: discoveryKey)
        print("💾 Progress saved: \(discoveryProgress)")
    }
    
    /// Load discovered items from UserDefaults
    func loadProgress() {
        if let saved = UserDefaults.standard.array(forKey: discoveryKey) as? [String] {
            discoveredItemIDs = Set(saved)
            print("📂 Progress loaded: \(discoveryProgress)")
        } else {
            print("📂 No saved progress found")
        }
    }
    
    // MARK: - Initialization
    
    init() {
        loadProgress()
    }
}
