//
//  PaymentDelegate.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 21.6.2023.
//

import Foundation

/// PaymentDelegate
///
/// Protocol for handling Payment responses
public protocol PaymentDelegate {
    
    /// Handle payment status change
    /// - Parameter status: status string of a payment flow, see PaymentStatus
    ///
    func onPaymentStatusChanged(_ paymentResult: PaymentResult)
    func onCardTokenizedIdReceived(_ tokenizationResult: TokenizationResult)
}

extension PaymentDelegate {
    func onPaymentStatusChanged(_ paymentResult: PaymentResult) {}
    func onCardTokenizedIdReceived(_ tokenizationResult: TokenizationResult) {}
}
