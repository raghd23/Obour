//
//  CollectionViewModel.swift
//  Obour
//
//  Created by Yousra Abdelrahman on 21/08/1447 AH.
//
import SwiftUI
import Combine

final class CollectionViewModel: ObservableObject {

    // MARK: - Immutable input
    let journey: Journey
    // MARK: - Persistence
    private let collectedItemsKey = "CollectedItemsKey"

    // MARK: - Published UI state
    @Published private(set) var items: [Items]
    @Published var currentItem: Items?

    // MARK: - Init
    init(journey: Journey) {
        self.journey = journey
        // Don't assign journey.items yet; list starts empty
        self.items = []
        self.currentItem = nil
        loadCollectedItems() // load saved items if any
    }
    
    // MARK: - Add an item when triggered by scene
    func addItem(_ item: Items) {
        guard !items.contains(where: { $0.id == item.id }) else { return }
        items.append(item)
        currentItem = items.first
        saveCollectedItems() // save to persistent storage
        print("Added item: \(item.name)")
    }
    // MARK: - Persistence

    func saveCollectedItems() {
        let ids = items.map { $0.id }
        UserDefaults.standard.set(ids, forKey: collectedItemsKey)
    }

    func loadCollectedItems() {
        guard let savedIDs = UserDefaults.standard.array(forKey: collectedItemsKey) as? [String] else { return }
        items = savedIDs.compactMap { ItemData.getItem(by: $0) }
        currentItem = items.first
    }


    // MARK: - Card rotation (same pattern as Home)
    func rotateItems() {
        SoundManger.instance.playSound(sound: .card)
        HapticManger.instance.impact(style: .medium)
        guard !items.isEmpty else { return }
        let first = items.removeFirst()
        items.append(first)
        currentItem = items.first
    }

    // MARK: - Placeholder for future item interaction
    func didSelectItem(_ item: Items) {
        // TODO: Hook item detail / encyclopedia / AR / sound later
    }
    func curtainShowItem(byID id: String) {
        guard let item = ItemData.getItem(by: id) else { return }
        addItem(item)
    }
    
}


//Later, when a SpriteKit node is triggered, you just call:
//
//collectionVM.curtainShowItem(byID: "plant-1")

