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
}

public struct Customer : Codable {
    let email : String?
}

public struct RedirectUrls : Codable {
    let success : String?
    let cancel : String?
}

public struct Item : Codable {
    let unitPrice : Int?
    let units : Int?
    let vatPercentage : Int?
    let productCode : String?
    let stamp : String?
}

public struct CallbackUrls : Codable {
    let success : String?
    let cancel : String?
}



