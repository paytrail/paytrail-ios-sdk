//
//  CustomProvider.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation


/// CustomProvider
///
/// Providers which require custom implementation. Currently used only by Apple Pay.
///
public struct CustomProvider: Codable {
    
    /// PTApplePay object
    let applepay : PTApplePay?

    enum CodingKeys: String, CodingKey {

        case applepay = "applepay"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        applepay = try values.decodeIfPresent(PTApplePay.self, forKey: .applepay)
    }
}
