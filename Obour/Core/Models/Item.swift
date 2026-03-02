//
//  Items.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import Foundation

typealias ItemID = String

// MARK: - Item Model
struct Item: Identifiable, Codable, Hashable {
    let id: ItemID
    let name: String
    let description: String?
    let imageName: String?
    let iconAsset: String?
}
