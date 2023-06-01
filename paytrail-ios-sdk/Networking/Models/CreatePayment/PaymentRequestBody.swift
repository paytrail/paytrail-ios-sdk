//
//  PaymentRequestBody.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

public struct PaymentRequestBody : Codable {
    let stamp : String?
    let reference : String?
    let amount : Int?
    let currency : String?
    let language : String?
    let items : [Item]?
    let customer : Customer?
    let redirectUrls : RedirectUrls?
    let callbackUrls : CallbackUrls?
    
    init(stamp: String, reference: String, amount: Int, currency: String, language: String, items: [Item], customer: Customer?, redirectUrls: RedirectUrls?, callbackUrls: CallbackUrls?) {
        self.stamp = stamp
        self.reference = reference
        self.amount = amount
        self.currency = currency
        self.language = language
        self.items = items
        self.customer = customer
        self.redirectUrls = redirectUrls
        self.callbackUrls = callbackUrls
    }
}

public struct Customer : Codable {
    let email : String?
    init(email: String?) {
        self.email = email
    }
}

public struct RedirectUrls : Codable {
    let success : String?
    let cancel : String?
    init(success: String?, cancel: String?) {
        self.success = success
        self.cancel = cancel
    }
}

public struct Item : Codable {
    let unitPrice : Int?
    let units : Int?
    let vatPercentage : Int?
    let productCode : String?
    let deliveryDate : String?
    init(unitPrice: Int?, units: Int?, vatPercentage: Int?, productCode: String?, stamp: String?) {
        self.unitPrice = unitPrice
        self.units = units
        self.vatPercentage = vatPercentage
        self.productCode = productCode
        self.deliveryDate = stamp
    }
}

public struct CallbackUrls : Codable {
    let success : String?
    let cancel : String?
    init(success: String?, cancel: String?) {
        self.success = success
        self.cancel = cancel
    }
}



