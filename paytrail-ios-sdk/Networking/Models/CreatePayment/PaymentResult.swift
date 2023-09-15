//
//  PaymentResult.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 3.7.2023.
//

import Foundation

public struct PaymentResult: Equatable {
        
    public let transactionId: String
    public let status: PaymentStatus
    public let error: PaytrailPaymentError?
    
    public init(transactionId: String, status: PaymentStatus, error: PaytrailPaymentError? = nil) {
        self.transactionId = transactionId
        self.status = status
        self.error = error
    }
    
    public static func == (lhs: PaymentResult, rhs: PaymentResult) -> Bool {
        lhs.transactionId == rhs.transactionId
    }
}
