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
    var amount: Int
    let price: Int64
    let image: String
    let currency: String
    let upperLimit: Int
    
    public static func == (lhs: ShoppingItem, rhs: ShoppingItem) -> Bool {
        lhs.id == rhs.id
    }
    
    mutating func updateAmount(of newAmount: Int) {
        amount = newAmount
    }
    
}
