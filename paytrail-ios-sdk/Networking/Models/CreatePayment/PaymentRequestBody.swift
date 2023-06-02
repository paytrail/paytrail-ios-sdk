//
//  PaymentRequestBody.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

/// PaymentRequestBody
///
/// - Required Properties:
///  - stamp : String // Merchant specific unique stamp, e.g. an UUID. Max length: 200
///  - reference : String // Merchant reference for the payment. Max length: 200
///  - amount : Int // Total amount of the payment (sum of items), VAT should be included in amount unless `usePricesWithoutVat` is set to true
///  - currency : String // Currency string, e.g. "EUR"
///  - language : String // Alpha-2 language code for the payment process, e.g. "FI"
///  - items : [Item] // Payment item array, see Item
///  - customer: Customer // Customer, see Customer
///  - redirectUrls : CallbackUrls // Redirect Urls, see CallbackUrls
///
/// - Optional Properties:
///  - callbackUrls : CallbackUrls? // see CallbackUrls
///  - orderId: String? // Order ID. Used for eg. Collector payments order ID. If not given, merchant reference is used instead. Max length: 60
///  - deliveryAddress: Address? // Delivery address, see Address
///  - invoicingAddress: Address? // Invoicing address, see Address
///  - manualInvoiceActivation: Bool? // If paid with invoice payment method, the invoice will not be activated automatically immediately. Currently only supported with Collector.
///  - callbackDelay: Int? // Callback delay in seconds. If callback URLs and delay are provided, callbacks will be called after the delay. max: 900, min: 0
///  - groups: [PaymentType]? // Optionally return only payment methods for selected groups
///  - usePricesWithoutVat: Bool? // If true, `amount` and `items.unitPrice` should be sent to API without VAT, and final VAT-included prices are calculated by Paytrail's system (with prices rounded to closest cent). Also, when true, items must be included.
public struct PaymentRequestBody : Codable {
    let stamp : String
    let reference : String
    let amount : Int
    let currency : String
    let language : String
    let items : [Item]
    let customer : Customer
    let redirectUrls : CallbackUrls
    let callbackUrls : CallbackUrls?
    let orderId: String?
    let deliveryAddress: Address?
    let invoicingAddress: Address?
    let manualInvoiceActivation: Bool?
    let callbackDelay: Int?
    let groups: [PaymentType]?
    let usePricesWithoutVat: Bool?
    
    init(stamp: String,
         reference: String,
         amount: Int,
         currency: String,
         language: String,
         items: [Item],
         customer: Customer,
         redirectUrls: CallbackUrls,
         callbackUrls: CallbackUrls? = nil,
         orderId: String? = nil,
         deliveryAddress: Address? = nil,
         invoicingAddress: Address? = nil,
         manualInvoiceActivation: Bool? = nil,
         callbackDelay: Int? = nil,
         groups: [PaymentType]? = nil,
         usePricesWithoutVat: Bool? = nil) {
        self.stamp = stamp
        self.reference = reference
        self.amount = amount
        self.currency = currency
        self.language = language
        self.items = items
        self.customer = customer
        self.redirectUrls = redirectUrls
        self.callbackUrls = callbackUrls
        self.orderId = orderId
        self.deliveryAddress = deliveryAddress
        self.invoicingAddress = invoicingAddress
        self.callbackDelay = callbackDelay
        self.manualInvoiceActivation = manualInvoiceActivation
        self.usePricesWithoutVat = usePricesWithoutVat
        self.groups = groups
    }
}

/// Customer
///
/// - Properties:
///  - email: String // Customer email address, format: email
///  - firstName: String? // Customer first name
///  - lastName: String? // Customer last name
///  - phone: String? // Customer phone number
///  - vatId: String? // Company VAT ID in international format
public struct Customer: Codable {
    let email : String
    let firstName: String?
    let lastName: String?
    let phone: String?
    let vatId: String?
    
    init(email: String, firstName: String? = nil, lastName: String? = nil, phone: String? = nil, vatId: String? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.vatId = vatId
    }
}

/// Item
///
///- Properties:
///  - unitPrice: Int64 // Unit price of an item in currency minor unit, eg. EUR cents. VAT should be included in amount unless `usePricesWithoutVat` is set to true.          Min: 0, max: 99999999
///  - units: Int64 // Number of units. Min: 1, max: 10000000
///  - vatPercentage: Int // Item VAT percentage. Min: 0, max: 100
///  - productCode: String // Merchant specific product code, maxLength: 100
///  - deliveryDate: String? // Estimated delivery date, e.g. '2018-03-07'
///  - description: String? // Merchant specific product description, maxLength: 1000
///  - category: String? // Item product category, maxLength: 100
///  - merchant: String? // Submerchant ID. Required for shop-in-shop payments, leave out from normal payments, maxLength: 10
///  - stamp: String? // Submerchant specific unique stamp. Required for shop-in-shop payments, leave out from normal payments, maxLength: 200
///  - reference: String? // Submerchant reference for the item. Required for shop-in-shop payments, leave out from normal payments, maxLength: 200
///  - orderId: String? // Order ID. Used for eg. Collector payments order ID. If not given, merchant reference is used instead, maxLength: 60
/// - commission: Commission? // See Commission
public struct Item: Codable {
    let unitPrice: Int64
    let units: Int64
    let vatPercentage: Int
    let productCode: String
    let deliveryDate: String?
    let description: String?
    let category: String?
    let merchant: String?
    let stamp: String?
    let reference: String?
    let orderId: String?
    let commission: Commission?
    init(unitPrice: Int64, units: Int64, vatPercentage: Int, productCode: String, deliveryDate: String? = nil, description: String? = nil, category: String? = nil, merchant: String? = nil, stamp: String? = nil, reference: String? = nil, orderId: String? = nil, commission: Commission? = nil) {
        self.unitPrice = unitPrice
        self.units = units
        self.vatPercentage = vatPercentage
        self.productCode = productCode
        self.deliveryDate = stamp
        self.description = description
        self.category = category
        self.merchant = merchant
        self.stamp = stamp
        self.reference = reference
        self.orderId = orderId
        self.commission = commission
    }
}

/// Commission
///
/// - Properties:
///  - merchant: String // Merchant who get's the commission money. This merchant id can not be deleted, has to be active and has to have same reseller with the merchant who initiated/created the webtrade. MaxLength: 10
///  - amount: Int32 // Commission amount in currency minor unit, eg. EUR cents. VAT not applicable. This field is needed only for specific shop-in-shop payments, usually not needed. Max: 99999999
public struct Commission: Codable {
    let merchant: String
    let amount: Int32
    init(merchant: String, amount: Int32) {
        self.merchant = merchant
        self.amount = amount
    }
}

/// CallbackUrls
///
/// - Properties:
///  - success: String //URL to call when payment is succesfully paid. Can called multiple times; one must ensure idempotency of this endpoint, maxLength: 300
///  - cancel: String // URL to call when payment is cancelled and not fulfilled. Can called multiple times; one must ensure idempotency of this endpoint, maxLength: 300
public struct CallbackUrls: Codable {
    let success : String
    let cancel : String
    init(success: String, cancel: String) {
        self.success = success
        self.cancel = cancel
    }
}

/// Address
///
/// - Properties:
///  - streetAddress: String // Street address, maxLength: 200
///  - postalCode: String // Postal code, pattern: '^\d+$', e.g.'00100', maxLength: 15
///  - city: String // City, maxLength: 200
///  - country: String // Country. Alpha-2 country code, e.g. 'SE'
///  - county: String? // County or top-level geographic subdivision, maxLength: 200
public struct Address: Codable {
    let streetAddress: String
    let postalCode: String
    let city: String
    let country: String
    let county: String?
    
    init(streetAddress: String, postalCode: String, city: String, country: String, county: String? = nil){
        self.streetAddress = streetAddress
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.county = county
    }
}

public enum PaymentType: String, Codable {
    case mobile, bank, creditcard, credit, other
}



