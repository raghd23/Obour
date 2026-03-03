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
            name: String(localized:"Eve Tree"),
            description: String(localized:"""
Eve Tree is easy to find.
It's a strong tree that grows in the Saudi desert. Despite the intense heat of the sun, it stays green and full of life.
It symbolizes hope and feelings that renew and bloom even in the toughest conditions.
"""),
            imageName: "item1",
            iconAsset: "leaf",
            // ✅ NEW VALUES
            isPoisonous: false,
            length: String(localized:"2.0m"),
            specialFeature: String(localized:"Aromatic"),
            season: String(localized:"Spring")
        ),
        Item(
            id: "plant-2",
            name: String(localized:"Desert Thorn"),
            description: String(localized: """
                Easy to find
                The Desert Thorn is a desert shrub covered in sharp thorns. It may look harsh, but it produces small red berries that birds eat and rely on for food. It reminds us that behind toughness, there can be goodness and beauty for those who are patient.
                """),
            imageName: "item2",
            iconAsset: "leaf.fill",
            // ✅ NEW VALUES
            isPoisonous: true,
            length: String(localized:"3.0m"),
            specialFeature: String(localized:"Medicinal"),
            season: String(localized:"Summer")
        ),
        Item(
            id: "plant-3",
            name: String(localized:"Samh plant"),
            description: String(localized:"""
                Samh plant is Rare to find
                It is a desert shrub that grows in harsh conditions. 
                In times of drought, its seeds were food for the Bedouins, who collected them one by one from the sand. 
                This plant carries within it the history of the people who lived on this land before you.
                """),
            imageName: "item-3",
            iconAsset: "sparkles",
            // ✅ NEW VALUES
            isPoisonous: false,
            length: String(localized:"5.0m"),
            specialFeature: String(localized:"Nutritional"),
            season: String(localized:"Winter")
        )
    ]

    static func getItem(by id: String) -> Item? {
        return allItems.first { $0.id == id }
    }
}
