//
//  TokenizationResult.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 3.7.2023.
//

import Foundation


public struct TokenizationResult: Equatable {
    
    public let tokenizationId: String
    public let status: PaymentStatus
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
