//
//  PayAndAddCardRequestResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 22.8.2023.
//

import Foundation

public struct PayAndAddCardRequestResponse: Codable {

    public var transactionId: String?
    public var redirectUrl: String?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case transactionId
        case redirectUrl
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encodeIfPresent(redirectUrl, forKey: .redirectUrl)
    }
}
