//
//  PaymentMethodGroupDataResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.9.2023.
//

import Foundation


/// PaymentMethodGroupDataResponse
///
/// PaymentMethodGroupDataResponse data model returned from the API 'PaymentMethodGroupDataResponse'
///
public struct PaymentMethodGroupDataResponse: Codable {
    
    /// PaymentMethodGroup array if any
    public let groups : [PaymentMethodGroup]?
    
    /// PaymentMethodProvider array if any
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
