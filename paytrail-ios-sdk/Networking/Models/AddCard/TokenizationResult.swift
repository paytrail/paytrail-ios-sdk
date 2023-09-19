//
//  TokenizationResult.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 3.7.2023.
//

import Foundation


/// TokenizationResult
///
/// TokenizationResult after adding a card on PaymentWebView, see API 'initiateCardTokenizationRequest(of:secret:redirectUrls:callbackUrls:language:)'.
///
public struct TokenizationResult: Equatable {
    
    /// Token id for retrieving the card token to be used for payments
    public let tokenizationId: String
    
    /// Status of the general Payment request
    public let status: PaymentStatus
    
    /// PaytrailTokenError if any
    public let error: PaytrailTokenError?
    
    public init(tokenizationId: String, status: PaymentStatus, error: PaytrailTokenError? = nil) {
        self.tokenizationId = tokenizationId
        self.status = status
        self.error = error
    }
    
    public static func == (lhs: TokenizationResult, rhs: TokenizationResult) -> Bool {
        lhs.tokenizationId == rhs.tokenizationId
    }
    
}
