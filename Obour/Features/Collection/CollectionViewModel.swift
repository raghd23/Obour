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

    // MARK: - Published UI state
    @Published private(set) var items: [Items]
    @Published var currentItem: Items?

    // MARK: - Init
    init(journey: Journey) {
        self.journey = journey
        self.items = journey.items
        self.currentItem = journey.items.first
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
}

#if DEBUG
extension CollectionViewModel {

    static let preview: CollectionViewModel = {
        let sampleItems: [Items] = [
            Items(
                id: "plant-1",
                name: "Eve Tree",
                description: "An optimistic plant that dances in the morning sun. An optimistic plant that dances in the morning sun. An optimistic plant that dances in the morning sun. An optimistic plant that dances in the morning sun.",
                imageAsset: "item1",
                iconAsset: "leaf"
            ),
            Items(
                id: "plant-2",
                name: "Sand Flower",
                description: "It flowers in the most difficult times, a symbol of constant emtional change. It flowers in the most difficult times, a symbol of constant emtional change. It flowers in the most difficult times, a symbol of constant emtional change.",
                imageAsset: "item2",
                iconAsset: "leaf.fill"
            )
        ]

        let previewJourney = Journey(
            id: "preview-journey",
            title: "Experamental Journey",
            description: "Used for preview only.",
            outline: nil,
            subOutline: nil,
            imageName: nil,
            scenes: [],
            items: sampleItems,
            requiredItemIDs: [],
            journeyRules: JourneyRules(
                softLimitSeconds: 0,
                hardLimitSeconds: 0,
                lostNoProgressSeconds: 0,
                graceVolumeMultiplier: 1,
                lostVolumeMultiplier: 1
            )
        )

        return CollectionViewModel(journey: previewJourney)
    }()
}
#endif

