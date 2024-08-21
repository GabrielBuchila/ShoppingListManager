//
//  ShopItem.swift
//  MyShoppingList
//
//  Created by Gabriel Buchila on 27.08.2023.
//

import Foundation

public class ShoppItem: Codable, Identifiable{
    public var itemName: String
    public var quantity: String
    // Add other properties as needed

    enum CodingKeys: String, CodingKey {
        case itemName
        case quantity
        // Add other coding keys as needed
    }

    public init(itemName: String, quantity: String) {
        self.itemName = itemName
        self.quantity = quantity
        // Initialize other properties as needed
    }

    // Implement the required initializer for Decodable
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let itemName = try container.decode(String.self, forKey: .itemName)
        let quantity = try container.decode(String.self, forKey: .quantity)
        // Decode other properties as needed

        // Call the designated initializer
        self.init(itemName: itemName, quantity: quantity)
    }

    // Implement the Encodable method if necessary
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(itemName, forKey: .itemName)
        try container.encode(quantity, forKey: .quantity)
        // Encode other properties as needed
    }
}

