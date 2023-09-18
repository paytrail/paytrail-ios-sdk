//
//  TokenizationRequestResponse.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 21.6.2023.
//

import Foundation


/// Response data model of card tokenization request.
///
public struct TokenizationRequestResponse: Codable {

    /** Token used to make authorization holds & charges on card */
    public var token: String
    
    /// TokenCustomerDetails of the customer
    public var customer: TokenCustomerDetails?
    
    /// Card object representing the payment card, can be saved locally for card token payment
    public var card: Card?

    public init(token: String, customer: TokenCustomerDetails? = nil, card: Card? = nil) {
        self.token = token
        self.customer = customer
        self.card = card
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case token
        case customer
        case card
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encodeIfPresent(customer, forKey: .customer)
        try container.encodeIfPresent(card, forKey: .card)
    }
}
