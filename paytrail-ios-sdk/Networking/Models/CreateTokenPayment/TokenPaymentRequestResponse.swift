//
//  TokenPaymentRequestResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 27.6.2023.
//

import Foundation

public struct TokenPaymentRequestResponse: Codable {
    
    let transactionId: String?

    enum CodingKeys: String, CodingKey {
        case transactionId = "transactionId"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
    }
}

public struct TokenPaymentThreeDsReponse: Codable {
    
    let transactionId: String?
    let threeDSecureUrl: String?
    
    var localizedDescription: String {
        guard let transactionId = transactionId, let threeDSecureUrl = threeDSecureUrl else {
            return ""
        }
        return "{status: \(transactionId), message: \(threeDSecureUrl)}"
    }
    
    enum CodingKeys: String, CodingKey {
        case transactionId = "transactionId"
        case threeDSecureUrl = "threeDSecureUrl"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        threeDSecureUrl = try values.decodeIfPresent(String.self, forKey: .threeDSecureUrl)
    }
}
