//
//  Parameter.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation


/// Parameter
///
/// Parameter of a PaymentMethodProvider
///
/// - Properties:
///  - name: String? // Name of the form input, e.g. VALUUTTALAJI
///  - value: String? // Value of the form input, e.g. EUR
///
public struct Parameter : Codable {
    let name : String?
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
