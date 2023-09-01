//
//  ShoppingItem.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.8.2023.
//

import Foundation

struct ShoppingItem: Identifiable, Equatable {
    let id: String
    let productName: String
    let description: String
    var units: Int
    let price: Int64
    let image: String
    let currency: String
    let upperLimit: Int
    
    public static func == (lhs: ShoppingItem, rhs: ShoppingItem) -> Bool {
        lhs.id == rhs.id
    }
    
    mutating func updateUnits(of newUnits: Int) {
        units = newUnits
    }
    
    func toProductItem(shoppingItem: Self) -> Item {
        Item(unitPrice: Int64(self.price * 100),
             units: Int64(self.units),
             vatPercentage: 24,
             productCode: self.id,
             description: self.productName
        )
    }
    
}
