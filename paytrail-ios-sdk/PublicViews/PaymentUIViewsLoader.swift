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
    
    /// For loading a PaymentWebView (SwiftUI view) in an UIViewController.
    /// - Parameters:
    ///   - request: URLRequest of the PaymentWebView
    ///   - delegate: PaymentDelegate who takes care of PaymentWebView callbacks
    /// - Returns: a loaded payment web UIView. Layout constraints need to be given in order to load it properly.
    public func loadPaymentUIWebView(from request: URLRequest, delegate: PaymentDelegate) -> UIView {
        
        let paymentWebController = UIHostingController(rootView: PaymentWebView(request: request, delegate: delegate))
        let paymentWebview = paymentWebController.view!
        paymentWebview.translatesAutoresizingMaskIntoConstraints = false
        addChild(paymentWebController)
        view.addSubview(paymentWebview)
        paymentWebController.didMove(toParent: self)
        return paymentWebview
    }
    
    
    /// For loading a PaymentProvidersView (SwiftUI view) in an UIViewController
    /// - Parameters:
    ///   - themes: PaytrailThemes
    ///   - providers: [PaymentMethodProvider]
    ///   - groups: [PaymentMethodGroup]
    ///   - delegate: PaymentProvidersViewDelegate
    /// - Returns: A loaded payment providers UIView. Layout constraints need to be given in order to load it properly.
    public func loadPaymentProvidersUIView(with themes: PaytrailThemes = PaytrailThemes(viewMode: .normal()),
                                           providers: [PaymentMethodProvider],
                                           groups: [PaymentMethodGroup],
                                           delegate: PaymentProvidersViewDelegate) -> UIView {
        
        let providersController = UIHostingController(rootView: PaymentProvidersView(themes: themes, providers: providers, groups: groups, paymentRequest: nil, delegate: delegate))
        let providerView = providersController.view!
        providerView.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(providersController)
        self.view.addSubview(providerView)
        providersController.didMove(toParent: self)
        return providerView
    }
}

