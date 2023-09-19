//
//  ApplePay.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation


/// PTApplePay
///
/// PTApplePay data model for Apple Pay only appearing in a CustomProvider
///
public struct PTApplePay : Codable {
    
    /// parameters for Apple Pay
    let parameters : [Parameter]?

    enum CodingKeys: String, CodingKey {

        case parameters = "parameters"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        parameters = try values.decodeIfPresent([Parameter].self, forKey: .parameters)
    }

}
