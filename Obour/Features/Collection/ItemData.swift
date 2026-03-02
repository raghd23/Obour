//
//  ItemData.swift
//  Obour
//
//  Created by Yousra Abdelrahman on 23/08/1447 AH.
//

import Foundation

// MARK: - Items Data
struct ItemData {
    static let allItems: [Item] = [
        Item(
            id: "plant-1",
            name: "Eve Tree",
            description: "An optimistic plant that dances in the morning sun.",
            imageName: "item1",
            iconAsset: "leaf"
        ),
        Item(
            id: "plant-2",
            name: "Sand Flower",
            description: "It flowers in the most difficult times, a symbol of constant change.",
            imageName: "item2",
            iconAsset: "leaf.fill"
        ),
        Item(
            id: "plant-3",
            name: "Desert Rose",
            description: "A rare bloom that only appears under the stars.",
            imageName: "item-3",
            iconAsset: "sparkles"
        )
    ]

    static func getItem(by id: String) -> Item? {
        return allItems.first { $0.id == id }
    }
}
