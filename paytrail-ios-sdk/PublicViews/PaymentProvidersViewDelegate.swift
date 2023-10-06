//
//  PaymentProvidersViewDelegate.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 13.9.2023.
//

import SwiftUI


/// PaymentProvidersViewDelegate
///
/// A public protocol for PaymentProvidersView handling subsequent payment request.
///
public protocol PaymentProvidersViewDelegate {
    
    /// onPaymentRequestSelected
    /// - Parameter request: current selected payment provider URLRequest
    func onPaymentRequestSelected(of request: URLRequest)
}
