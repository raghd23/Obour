//
//  ItemSpot.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

struct ItemSpot: Identifiable, Codable, Hashable {
    let id: String
    let itemID: ItemID
    let position: Point

    /// Discovery tuning
    let pickupRadius: Double

    /// Sound guidance
    let soundKey: String
    let falloffDistance: Double
}
