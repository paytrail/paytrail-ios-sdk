//
//  PayAndAddCardRequestResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 22.8.2023.
//

import Foundation


/// PayAndAddCardRequestResponse
///
/// Response data model for pay and add card request. See API 'payAndAddCard(of:secret:payload:completion:)'.
///
public struct PayAndAddCardRequestResponse: Codable {

    /// Transaction id of the token payment
    public var transactionId: String?
    
    /// Redirect URL of the token payment
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
