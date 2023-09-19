//
//  PaymentMethodGroup.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

/// PaymentMethodGroup
///
/// An data model equivalent to the data model 'PaymentMethodGroupData' in Paytrail's web SDK. See https://docs.paytrail.com/#/?id=paymentmethodgroupdata
///
public struct PaymentMethodGroup: Codable, Hashable {
    
    /// ID of the group
    let id : String?
    
    /// Localized name of the group
    let name : String?
    
    /// URL to PNG version of the group icon
    let icon : String?
    
    /// URL to SVG version of the group icon. Using the SVG icon is preferred
    let svg : String?
    
    /// PaymentMethodProvider array if available
    let providers: [PaymentMethodProvider]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case icon = "icon"
        case svg = "svg"
        case providers = "providers"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        svg = try values.decodeIfPresent(String.self, forKey: .svg)
        providers = try values.decodeIfPresent([PaymentMethodProvider].self, forKey: .providers)
    }

}
