//
//  TokenCustomerDetails.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 21.6.2023.
//

import Foundation


/// TokenCustomerDetails
///
/// TokenCustomerDetails data model representing a customer
/// 
public struct TokenCustomerDetails: Codable {

    /** Customer IP address */
    public var networkAddress: String
    /** Customer country code */
    public var countryCode: String

    public init(networkAddress: String, countryCode: String) {
        self.networkAddress = networkAddress
        self.countryCode = countryCode
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case networkAddress = "network_address"
        case countryCode = "country_code"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(networkAddress, forKey: .networkAddress)
        try container.encode(countryCode, forKey: .countryCode)
    }
}
