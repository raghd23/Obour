//
//  ItemData.swift
//  Obour
//
//  Created by Yousra Abdelrahman on 23/08/1447 AH.
//

import Foundation

struct ItemData {
    static let allItems: [Items] = [
        Items(
            id: "plant-1",
            name: "Eve Tree",
            description: "An optimistic plant that dances in the morning sun.",
            imageAsset: "item1",
            iconAsset: "leaf"
        ),
        Items(
            id: "plant-2",
            name: "Sand Flower",
            description: "It flowers in the most difficult times, a symbol of constant change.",
            imageAsset: "item2",
            iconAsset: "leaf.fill"
        ),
        // Add more items here
    ]

    static func getItem(by id: String) -> Items? {
        return allItems.first { $0.id == id }
    }
}
