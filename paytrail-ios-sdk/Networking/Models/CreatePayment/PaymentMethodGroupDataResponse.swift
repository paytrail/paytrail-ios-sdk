//
//  PaymentMethodGroupDataResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.9.2023.
//

import Foundation

public struct PaymentMethodGroupDataResponse: Codable {
    
    public let groups : [PaymentMethodGroup]?
    public let providers : [PaymentMethodProvider]?


    enum CodingKeys: String, CodingKey {
        case groups
        case providers
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        groups = try values.decodeIfPresent([PaymentMethodGroup].self, forKey: .groups)
        providers = try values.decodeIfPresent([PaymentMethodProvider].self, forKey: .providers)
    }
}
