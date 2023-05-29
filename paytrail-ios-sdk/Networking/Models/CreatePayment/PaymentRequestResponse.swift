//
//  PaymentRequestResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

public struct PaymentRequestResponse : Codable {
    let transactionId : String?
    let href : String?
    let reference : String?
    let terms : String?
    let groups : [PaymentGroup]?
    let providers : [Provider]?
    let customProviders : CustomProvider?

    enum CodingKeys: String, CodingKey {
        case transactionId = "transactionId"
        case href = "href"
        case reference = "reference"
        case terms = "terms"
        case groups = "groups"
        case providers = "providers"
        case customProviders = "customProviders"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        href = try values.decodeIfPresent(String.self, forKey: .href)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        terms = try values.decodeIfPresent(String.self, forKey: .terms)
        groups = try values.decodeIfPresent([PaymentGroup].self, forKey: .groups)
        providers = try values.decodeIfPresent([Provider].self, forKey: .providers)
        customProviders = try values.decodeIfPresent(CustomProvider.self, forKey: .customProviders)
    }

}
