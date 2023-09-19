//
//  PaymentRequestBody.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

/// PaymentRequestBody
///
/// **Required Properties:**
///  - stamp : Merchant specific unique stamp, e.g. an UUID. Max length: 200
///  - reference : Merchant reference for the payment. Max length: 200
///  - amount : Total amount of the payment (sum of items), VAT should be included in amount unless `usePricesWithoutVat` is set to true
///  - currency : Currency string, e.g. "EUR"
///  - language : Alpha-2 language code string for the payment process, e.g. "FI"
///  - items : Payment item array, see Item
///  - customer: Customer, see Customer
///  - redirectUrls : Redirect Urls, see CallbackUrls
///
/// **Optional Properties:**
///  - callbackUrls : CallbackUrls? // see CallbackUrls
///  - orderId: String? // Order ID. Used for eg. Collector payments order ID. If not given, merchant reference is used instead. Max length: 60
///  - deliveryAddress: Address? // Delivery address, see Address
///  - invoicingAddress: Address? // Invoicing address, see Address
///  - manualInvoiceActivation: Bool? // If paid with invoice payment method, the invoice will not be activated automatically immediately. Currently only supported with Collector.
///  - callbackDelay: Int? // Callback delay in seconds. If callback URLs and delay are provided, callbacks will be called after the delay. max: 900, min: 0
///  - groups: [PaymentType]? // Optionally return only payment methods for selected groups
///  - usePricesWithoutVat: Bool? // If true, `amount` and `items.unitPrice` should be sent to API without VAT, and final VAT-included prices are calculated by Paytrail's system (with prices rounded to closest cent). Also, when true, items must be included.
///  - token: String? // Payment card token received from request to /tokenization/{checkout-tokenization-id}

public struct PaymentRequestBody : Codable {
    public let stamp : String
    public let reference : String
    public let amount : Int
    public let currency : Currency
    public let language : Language
    public let items : [Item]
    public let customer : Customer
    public let redirectUrls : CallbackUrls
    public let callbackUrls : CallbackUrls?
    public let orderId: String?
    public let deliveryAddress: Address?
    public let invoicingAddress: Address?
    public let manualInvoiceActivation: Bool?
    public let callbackDelay: Int?
    public let groups: [PaymentType]?
    public let usePricesWithoutVat: Bool?
    public let token: String?
    
    public init(stamp: String,
         reference: String,
         amount: Int,
         currency: Currency,
         language: Language,
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
         usePricesWithoutVat: Bool? = nil,
         token: String? = nil) {
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
        self.token = token
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
    public let email : String
    public let firstName: String?
    public let lastName: String?
    public let phone: String?
    public let vatId: String?
    
    public init(email: String, firstName: String? = nil, lastName: String? = nil, phone: String? = nil, vatId: String? = nil) {
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
public struct Item: Codable, Equatable {
    public let unitPrice: Int
    public let units: Int
    public let vatPercentage: Int
    public let productCode: String
    public let deliveryDate: String?
    public let description: String?
    public let category: String?
    public let merchant: String?
    public let stamp: String?
    public let reference: String?
    public let orderId: String?
    public let commission: Commission?
    
    public init(unitPrice: Int, units: Int, vatPercentage: Int, productCode: String, deliveryDate: String? = nil, description: String? = nil, category: String? = nil, merchant: String? = nil, stamp: String? = nil, reference: String? = nil, orderId: String? = nil, commission: Commission? = nil) {
        self.unitPrice = unitPrice
        self.units = units
        self.vatPercentage = vatPercentage
        self.productCode = productCode
        self.deliveryDate = deliveryDate
        self.description = description
        self.category = category
        self.merchant = merchant
        self.stamp = stamp
        self.reference = reference
        self.orderId = orderId
        self.commission = commission
    }
    
    public static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.productCode == rhs.productCode
    }
}

/// Commission
///
/// - Properties:
///  - merchant: String // Merchant who get's the commission money. This merchant id can not be depublic leted, has to be active and has to have same reseller with the merchant who initiated/created the webtrade. MaxLength: 10
///  - amount: Int32 // Commission amount in currency minor unit, eg. EUR cents. VAT not applicable. This field is needed only for specific shop-in-shop payments, usually not needed. Max: 99999999
public struct Commission: Codable {
    public let merchant: String
    public let amount: Int32
    public init(merchant: String, amount: Int32) {
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
    public let success : String
    public let cancel : String
    public init(success: String, cancel: String) {
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
    public let streetAddress: String
    public let postalCode: String
    public let city: String
    public let country: String
    public let county: String?
    
    public init(streetAddress: String, postalCode: String, city: String, country: String, county: String? = nil){
        self.streetAddress = streetAddress
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.county = county
    }
}

public enum Language: String, Codable {
    case en = "EN"
    case fi = "FI"
    case sv = "SV"
}

public enum PaymentType: String, Codable {
    case mobile, bank, creditcard, credit, other
}




