//
//  PaymentRequestResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation


/// PaymentRequestResponse
///
/// Response for a successful payment request. Merchant ecom site can then either redirectthe user to the URL given in href, or render the payment provider forms onsite. For each payment method an HTML form needs to be rendered using the parameters returned for each payment method provider.
///
/// **Properties:**
/// - transactionId: String? // Checkout assigned transaction ID for the payment.
/// - href: String? // Unique URL to hosted payment gateway.
/// - reference: String? // The bank reference used for the payments.
/// - terms: String? // Text containing a link to the terms of payment
/// - groups: [PaymentMethodGroup]? // Contains data about the payment method groups. Contains only the groups found in the response's providers. See PaymentGroup
/// - providers: [PaymentMethodProvider]? // See PaymentMethodProvider
///
public struct PaymentRequestResponse: Codable {
    public let transactionId : String?
    public let href : String?
    public let reference : String?
    public let terms : String?
    public let groups : [PaymentMethodGroup]?
    public let providers : [PaymentMethodProvider]?
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

