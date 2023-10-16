//
//  PaymentResult.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 3.7.2023.
//

import Foundation


/// PaymentResult
///
/// PaymentResult data model created in PaymentWebView after a payment response.
///
public struct PaymentResult: Equatable {
    
    /// Transaction id of a payment
    public let transactionId: String
    
    /// Status of a payment
    public let status: PaymentStatus
    
    /// Error of a payment if any
    public let error: PayTrailError?
    
    public init(transactionId: String, status: PaymentStatus, error: PayTrailError? = nil) {
        self.transactionId = transactionId
        self.status = status
        self.error = error
    }
    
    public static func == (lhs: PaymentResult, rhs: PaymentResult) -> Bool {
        lhs.transactionId == rhs.transactionId
    }
}
