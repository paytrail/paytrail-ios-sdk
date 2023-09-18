//
//  TokenPaymentRequestResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 27.6.2023.
//

import Foundation


/// Response data model for the card token payment requests
///
public struct TokenPaymentRequestResponse: Codable {
    
    /// Transaction id of the token payment
    public let transactionId: String?

    enum CodingKeys: String, CodingKey {
        case transactionId = "transactionId"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
    }
}


/// Response data model for the card token payment 3DS, which is treated as a soft decline with status code 403. App needs to redirect user to the 3DS secure page to finish the token payment.
///
public struct TokenPaymentThreeDsReponse: Codable {
    
    /// Transaction id of the token payment
    public let transactionId: String?
    
    /// 3DS secure URL to redirect to
    public let threeDSecureUrl: String?
    
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
