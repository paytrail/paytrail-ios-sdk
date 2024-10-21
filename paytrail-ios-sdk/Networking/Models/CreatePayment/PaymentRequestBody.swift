//
//  PaymentRequestBody.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

/// PaymentRequestBody
///
/// PaymentRequestBody data model for APIs 'createPayment(of:secret:payload:completion:)' and 'createTokenPayment(of:secret:payload:transactionType:authorizationType:completion:)'. The latter API requires a card token.
///
public struct PaymentRequestBody : Codable {
    
    /// Merchant specific unique stamp, e.g. an UUID. Max length: 200
    public let stamp : String
    
    /// Merchant reference for the payment. Max length: 200
    public let reference : String
    
    /// Total amount of the payment in currency's minor units, e.g. for Euros use cents. Must match the total sum of items and must be more than zero. By default amount should include VAT, unless usePricesWithoutVat is set to true. Maximum value of 99999999
    public let amount : Int
    
    /// Currency, only EUR supported at the moment
    public let currency : Currency
    
    /// Payment's language, currently supported are FI, SV, and EN
    public let language : Language
    
    /// Array of items. Always required for Shop-in-Shop payments. Required if VAT calculations are wanted in settlement reports.
    public let items : [Item]
    
    /// Customer information, see Customer
    public let customer : Customer
    
    /// Where to redirect browser after a payment is paid or cancelled
    public let redirectUrls : CallbackUrls
    
    /// Which url to ping after this payment is paid or cancelled
    public let callbackUrls : CallbackUrls?
    
    /// Order ID. Used for e.g. Walley/Collector payments order ID. If not given, merchant reference is used instead.
    public let orderId: String?
    
    /// Delivery address
    public let deliveryAddress: Address?
    
    /// Invoicing address
    public let invoicingAddress: Address?
    
    /// If paid with invoice payment method, the invoice will not be activated automatically immediately. Currently only supported with Walley/Collector.
    public let manualInvoiceActivation: Bool?
    
    /// Callback URL polling delay in seconds. If callback URLs are given, the call can be delayed up to 900 seconds. Default: 0
    public let callbackDelay: Int?
    
    /// Instead of all enabled payment methods, return only those of given groups. It is highly recommended to use list providers before initiating the payment if filtering by group. If the payment methods are rendered in the webshop the grouping functionality can be implemented based on the group attribute of each returned payment instead of filtering when creating a payment.
    public let groups: [PaymentType]?
    
    /// If true, amount and items.unitPrice should be sent to API not including VAT, and final amount is calculated by Paytrail's system using the items' unitPrice and vatPercentage (with amounts rounded to closest cent). Also, when true, items must be included.
    public let usePricesWithoutVat: Bool?
    
    /// Payment card token received from request to /tokenization/{checkout-tokenization-id}
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
/// Customer data model representing a Customer, belonging to PaymentRequestBody
///
public struct Customer: Codable {
    
    /// Email. Maximum of 200 characters.
    public let email : String
    
    /// First name (required for OPLasku and Walley/Collector). Maximum of 50 characters.
    public let firstName: String?
    
    /// Last name (required for OPLasku and Walley/Collector). Maximum of 50 characters.
    public let lastName: String?
    
    /// Phone number
    public let phone: String?
    
    /// VAT ID, if any
    public let vatId: String?
    
    /// Company name, if any
    public let companyName: String?
    
    public init(email: String, firstName: String? = nil, lastName: String? = nil, phone: String? = nil, vatId: String? = nil, companyName: String? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.vatId = vatId
        self.companyName = companyName
    }
}

/// Item
///
/// Item data model representing a purchased item, belonging to PaymentRequestBody.
///
public struct Item: Codable, Equatable {
    
    /// Price per unit, in each country's minor unit, e.g. for Euros use cents. By default price should include VAT, unless usePricesWithoutVat is set to true. No negative values accepted. Maximum value of 2147483647, minimum value is 0.
    public let unitPrice: Int
    
    /// Quantity, how many items ordered. Negative values are not supported.
    public let units: Int
    
    /// VAT percentage. Values between 0 and 100 are allowed with one decimal place.
    public let vatPercentage: Decimal
    
    /// Merchant product code. May appear on invoices of certain payment methods. Maximum of 100 characters
    public let productCode: String
    
    /// (Deprecated) When is this item going to be delivered. This field is deprecated but remains here as a reference for old integrations.
    public let deliveryDate: String?
    
    /// Item description. May appear on invoices of certain payment methods. Maximum of 1000 characters.
    public let description: String?
    
    /// Merchant specific item category
    public let category: String?
    
    /// Merchant ID for the item. Required for Shop-in-Shop payments, do not use for normal payments.
    public let merchant: String?
    
    /// Unique identifier for this item. Required for Shop-in-Shop payments. Required for item refunds.
    public let stamp: String?
    
    /// Reference for this item. Required for Shop-in-Shop payments.
    public let reference: String?
    
    /// Item level order ID (suborder ID). Mainly useful for Shop-in-Shop purchases.
    public let orderId: String?
    
    /// Shop-in-Shop commission. Do not use for normal payments.
    public let commission: Commission?
    
    public init(unitPrice: Int, units: Int, vatPercentage: Decimal, productCode: String, deliveryDate: String? = nil, description: String? = nil, category: String? = nil, merchant: String? = nil, stamp: String? = nil, reference: String? = nil, orderId: String? = nil, commission: Commission? = nil) {
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
/// Commission data model representing a Commission, belonging to a PaymentRequestBody
///
public struct Commission: Codable {
    
    /// Merchant(id) who gets the commission
    public let merchant: String
    
    /// Amount of commission in currency's minor units, e.g. for Euros use cents. VAT not applicable.
    public let amount: Int
    
    public init(merchant: String, amount: Int) {
        self.merchant = merchant
        self.amount = amount
    }
}

/// CallbackUrls
///
/// CallbackUrls data model representing a set of callback or redirect urls, belonging to a PaymentRequestBody
///
public struct CallbackUrls: Codable {
    
    /// Called on successful payment
    public let success : String
    
    /// Called on cancelled payment
    public let cancel : String
    
    public init(success: String, cancel: String) {
        self.success = success
        self.cancel = cancel
    }
}

/// Address
///
/// Address data model representing a delivery or an invoicing address, belonging to a PaymentRequestBody
///
public struct Address: Codable {
    
    /// Street address. Maximum of 50 characters.
    public let streetAddress: String
    
    /// Postal code. Maximum of 15 characters.
    public let postalCode: String
    
    /// City. maximum of 30 characters.
    public let city: String
    
    /// County/State
    public let country: String
    
    /// Alpha-2 country code
    public let county: String?
    
    public init(streetAddress: String, postalCode: String, city: String, country: String, county: String? = nil){
        self.streetAddress = streetAddress
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.county = county
    }
}


/// Language
///
/// Language enum, currently only supporting en, fi, and sv
///
public enum Language: String, Codable {
    case en = "EN"
    case fi = "FI"
    case sv = "SV"
}

/// PaymentType
///
/// PaymentType enum, currently including 5 types
/// 
public enum PaymentType: String, Codable {
    case mobile, bank, creditcard, credit, other
}




