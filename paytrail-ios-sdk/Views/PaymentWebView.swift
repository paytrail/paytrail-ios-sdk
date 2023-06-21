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
/// A customised WebView for SwiftUI For handling payment web view responses
///
/// **Properties:**
/// - request: URLRequest - the URLRequest of the payment provider
/// - delegate: PaymentDelegate? - PaymentDelegate for handling payment reponses
/// - merchant: PaytrailMerchant - Current merchant needed for signature validation
///
public struct PaymentWebView: UIViewRepresentable {
    
    let request: URLRequest
    let delegate: PaymentDelegate?
    let merchant: PaytrailMerchant
    var contentType: ContentType = .normalPayment
    
    public enum ContentType {
        case normalPayment
        case addCard
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
        WebViewCoordinator(self, delegate: delegate, merchant: merchant, contentType: contentType)
    }
    
    public class WebViewCoordinator: NSObject, WKNavigationDelegate {
        let parent: PaymentWebView
        let delegate: PaymentDelegate?
        let merchant: PaytrailMerchant
        let contentType: ContentType

        init(_ parent: PaymentWebView, delegate: PaymentDelegate?, merchant: PaytrailMerchant, contentType: ContentType) {
            self.parent = parent
            self.delegate = delegate
            self.merchant = merchant
            self.contentType = contentType
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

            if let urlString = navigationResponse.response.url?.absoluteString {
                print("Response url: \(urlString)")
                let items = getQueryItems(urlString)
                
                switch contentType {
                case .addCard:
                    guard let tokenId = items["checkout-tokenization-id"], let signature = items["signature"], signature == hmacSignature(secret: merchant.secret, headers: items, body: nil) else {
                        decisionHandler(.allow)
                        return
                    }
                    delegate?.onCardTokenizedIdReceived(tokenId)
                case .normalPayment:
                    // Validate reponse signature
                    guard let status = items["checkout-status"], let signature = items["signature"], signature == hmacSignature(secret: merchant.secret, headers: items, body: nil) else {
                        if let _ = items["checkout-status"] {
                            print("signature mismatch, failing payment")
                            // Return payment status fail when signatures mismatch
                            delegate?.onPaymentStatusChanged(PaymentStatus.fail.rawValue)
                        }
                        decisionHandler(.allow)
                        return
                    }
                    delegate?.onPaymentStatusChanged(status)
                }
            }
            decisionHandler(.allow)
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let urlString = navigationAction.request.url?.absoluteString, urlString != "about:blank" else {
                decisionHandler(.cancel)
                return
            }
            print(urlString)
            decisionHandler(.allow)
        }
    }
    
}
