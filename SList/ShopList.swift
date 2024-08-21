//
//  ShopList.swift
//  SList
//
//  Created by Gabriel Buchila on 21.08.2024.
//


import Foundation

public class ShopList: Codable, Identifiable{
    public var id = UUID()  // Add an id property
    public var name: String
    public var date: Date?
    public var allShoppItems: [ShoppItem] = []

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case date
        case allShoppItems
    }

    public init(name: String) {
        self.name = name
    }

    public init(name: String, date: Date) {
        self.name = name
        self.date = date
    }

    public func printName() {
        print("Hello, \(name)!")
    }

    public func setName(name: String) {
        self.name = name
    }

    // Implement Decodable initializer
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        date = try container.decodeIfPresent(Date.self, forKey: .date)
        allShoppItems = try container.decodeIfPresent([ShoppItem].self, forKey: .allShoppItems) ?? []
    }
}


import Foundation
