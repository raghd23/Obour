//
//  Items.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Foundation

struct Items: Identifiable, Codable, Hashable {
    let id: ItemID
    let name: String
    let description: String

    /// Collection UI
    let imageAsset: String
    let iconAsset: String
}
