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
    func onPaymentStatusChanged(_ status: String)
    func onCardTokenizedIdReceived(_ tokenizedId: String)
}

extension PaymentDelegate {
    func onPaymentStatusChanged(_ status: String) {}
    func onCardTokenizedIdReceived(_ tokenizedId: String) {}
}
