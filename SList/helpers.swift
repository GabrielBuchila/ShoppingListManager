//
//  helpers.swift
//  SList
//
//  Created by Gabriel Buchila on 21.08.2024.
//

import Foundation

func retriveAllListFromJson(_ allShopList : inout [ShopList?]){
    // Retrieve from File
    if let data = try? Data(contentsOf: fileURL!),
       let savedShopList = try? JSONDecoder().decode([ShopList?].self, from: data) {
        allShopList = savedShopList
    }
}

func saveAllListFromJson(shopListToSave : [ShopList?]){
    // Save to File
    let data = try? JSONEncoder().encode(shopListToSave)
    try? data?.write(to: fileURL!)
}
