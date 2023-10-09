//
//  PaymentWebView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 9.6.2023.
//

import Foundation

import SwiftUI
import WebKit


/// PaymentWebView
///
/// A customised WebView for SwiftUI For handling payment web view responses. To use it in an UIViewController, see 'PaymentUIViewsLoader'
///
public struct PaymentWebView: UIViewRepresentable {
    
    /// URLRequest of the payment provider
    public let request: URLRequest
    
    /// PaymentDelegate for handling payment reponses
    public let delegate: PaymentDelegate?
    
    /// ContentType - normalPayment or addCard for loading and handling each type of view accordingly
    public let contentType: ContentType
    
    public enum ContentType {
        case normalPayment
        case addCard
    }
    
    public init(request: URLRequest,
                delegate: PaymentDelegate?,
                contentType: ContentType = .normalPayment) {
        self.request = request
        self.delegate = delegate
        self.contentType = contentType
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let wKWebView = WKWebView()
        wKWebView.navigationDelegate = context.coordinator
        return wKWebView
    }
    
    public func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(request)
    }
    
    public func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self, delegate: delegate, contentType: contentType)
    }
    
    public class WebViewCoordinator: NSObject, WKNavigationDelegate {
        let parent: PaymentWebView
        let delegate: PaymentDelegate?
        let contentType: ContentType

        init(_ parent: PaymentWebView, delegate: PaymentDelegate?, contentType: ContentType) {
            self.parent = parent
            self.delegate = delegate
            self.contentType = contentType
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

            if let urlString = navigationResponse.response.url?.absoluteString {
                PTLogger.log(message: "Response url: \(urlString)", level: .debug)
                let items = getQueryItems(urlString)
                
                switch contentType {
                case .addCard:
                    guard let tokenId = items[ParameterKeys.checkoutTokenizationId] else {
                        if let _ = items[ParameterKeys.checkoutStatus] {
                            let result = TokenizationResult(tokenizationId: "", status: .fail, error: PaytrailTokenError(type: .invalidToken, code: 404))
                            delegate?.onCardTokenizedIdReceived(result)
                        }

                        decisionHandler(.allow)
                        return
                    }
                    
                    guard let signature = items[ParameterKeys.signature], signature == hmacSignature(secret: PaytrailMerchant.shared.secret, headers: items, body: nil) else {
                        if let _ = items[ParameterKeys.checkoutStatus]  {
                            let result = TokenizationResult(tokenizationId: "", status: .fail, error: PaytrailTokenError(type: .invalidSignature, code: 404))
                            delegate?.onCardTokenizedIdReceived(result)
                        }

                        decisionHandler(.allow)
                        return
                    }
                    
                    let result = TokenizationResult(tokenizationId: tokenId, status: .ok)
                    delegate?.onCardTokenizedIdReceived(result)
                    
                case .normalPayment:
                    // Validate reponse signature
                    guard let status = items[ParameterKeys.checkoutStatus],
                            let transactionId = items[ParameterKeys.checkoutTransactionId],
                            let signature = items[ParameterKeys.signature],
                          signature == hmacSignature(secret: PaytrailMerchant.shared.secret, headers: items, body: nil) else {
                        if let transactionId = items[ParameterKeys.checkoutTransactionId], let _ = items[ParameterKeys.checkoutStatus]  {
                            PTLogger.log(message: "Signature mismatch, failing payment", level: .error)
                            // Return payment status fail when signatures mismatch
                            let result = PaymentResult(transactionId: transactionId, status: .fail, error: PaytrailPaymentError(type: .invalidSignature, code: 404))
                            delegate?.onPaymentStatusChanged(result)
                        }

                        decisionHandler(.allow)
                        return
                    }
                    let result = PaymentResult(transactionId: transactionId, status: PaymentStatus(rawValue: status) ?? .none)
                    delegate?.onPaymentStatusChanged(result)
                }
            }
            decisionHandler(.allow)
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let urlString = navigationAction.request.url?.absoluteString, urlString != "about:blank" else {
                decisionHandler(.cancel)
                return
            }
            PTLogger.log(message: "Request URL: \(urlString)", level: .debug)
            decisionHandler(.allow)
        }
    }
    
}
