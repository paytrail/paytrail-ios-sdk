//
//  PaymentRequestResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation


/// PaymentRequestResponse
///
/// The response JSON object contains the transaction ID of the payment and list of provider data. The response also contains a HMAC verification headers and cof-request-id header. Storing or logging the request ID header is advised for possible debug needs.
///
public struct PaymentRequestResponse: Codable {
    
    /// Assigned transaction ID for the payment
    public let transactionId : String?
    
    /// URL to hosted payment gateway. Redirect (HTTP GET) user here if the payment forms cannot be rendered directly inside the web shop.
    public let href : String?
    
    /// The bank reference used for the payments
    public let reference : String?
    
    /// Localized text with a link to the terms of payment
    public let terms : String?
    
    /// Array of payment method group data with localized names and URLs to icons. Contains only the groups found in the providers of the response
    public let groups : [PaymentMethodGroup]?
    
    /// Array of providers.
    public let providers : [PaymentMethodProvider]?
    
    /// Providers which require custom implementation. Currently used only by Apple Pay.
    public let customProviders : CustomProvider?

    enum CodingKeys: String, CodingKey {
        case transactionId = "transactionId"
        case href = "href"
        case reference = "reference"
        case terms = "terms"
        case groups = "groups"
        case providers = "providers"
        case customProviders = "customProviders"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        href = try values.decodeIfPresent(String.self, forKey: .href)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        terms = try values.decodeIfPresent(String.self, forKey: .terms)
        groups = try values.decodeIfPresent([PaymentMethodGroup].self, forKey: .groups)
        providers = try values.decodeIfPresent([PaymentMethodProvider].self, forKey: .providers)
        customProviders = try values.decodeIfPresent(CustomProvider.self, forKey: .customProviders)
    }

}

