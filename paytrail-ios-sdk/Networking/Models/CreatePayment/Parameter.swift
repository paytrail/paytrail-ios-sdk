//
//  Parameter.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation


/// Parameter
///
/// Parameter data model of a PaymentMethodProvider, or of a PTApplePay
///
public struct Parameter: Codable, Hashable {
    
    /// Name of the parameter
    let name : String?
    
    /// Value of the parameter
    let value : String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case value = "value"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }
}
