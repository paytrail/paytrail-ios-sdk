//
//  PaymentUIViewsLoader.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 14.9.2023.
//

import Foundation
import UIKit
import SwiftUI

extension UIViewController {
    
    /// loadPaymentUIWebView for loading a PaymentWebView (SwiftUI view) in an UIViewController.
    /// - Parameters:
    ///   - request: URLRequest of the PaymentWebView
    ///   - merchant: PaytrailMerchant
    ///   - delegate: PaymentDelegate who takes care of PaymentWebView callbacks
    /// - Returns: a loaded payment web UIView. Layout constraints need to be given in order to load it properly.
    public func loadPaymentUIWebView(from request: URLRequest, merchant: PaytrailMerchant, delegate: PaymentDelegate) -> UIView {
        
        let paymentWebController = UIHostingController(rootView: PaymentWebView(request: request, delegate: delegate, merchant: merchant))
        let paymentWebview = paymentWebController.view!
        paymentWebview.translatesAutoresizingMaskIntoConstraints = false
        addChild(paymentWebController)
        view.addSubview(paymentWebview)
        paymentWebController.didMove(toParent: self)
        return paymentWebview
    }
    
    
    /// loadPaymentProvidersUIView for loading a PaymentProvidersVCView (SwiftUI view) in an UIViewController
    /// - Parameters:
    ///   - providers: [PaymentMethodProvider]
    ///   - groups: [PaymentMethodGroup]
    ///   - delegate: PaymentProvidersVCViewDelegate
    /// - Returns: A loaded payment providers UIView. Layout constraints need to be given in order to load it properly.
    public func loadPaymentProvidersUIView(with providers: [PaymentMethodProvider], groups: [PaymentMethodGroup], delegate: PaymentProvidersVCViewDelegate) -> UIView {
        
        let providersController = UIHostingController(rootView: PaymentProvidersVCView(providers: providers, groups: groups, delegate: delegate))
        let providerView = providersController.view!
        providerView.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(providersController)
        self.view.addSubview(providerView)
        providersController.didMove(toParent: self)
        return providerView
    }
}
