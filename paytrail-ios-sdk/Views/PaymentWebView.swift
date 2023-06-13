//
//  WebView.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 9.6.2023.
//

import Foundation

import SwiftUI
import WebKit

struct PaymentWebView: UIViewRepresentable {
    var url: URL
    var method: HTTPMethod = .get
    var headers: [String: String] = ["content-type": "application/json; charset=utf-8"]
    var query: [Parameter] = []
    var delegate: PaymentDelegate?
    
    func makeUIView(context: Context) -> WKWebView {
        let wKWebView = WKWebView()
        wKWebView.navigationDelegate = context.coordinator
        return wKWebView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        webView.load(request)
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self, delegate: delegate)
    }
    
    class WebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: PaymentWebView
        var delegate: PaymentDelegate?
        init(_ parent: PaymentWebView, delegate: PaymentDelegate?) {
            self.parent = parent
            self.delegate = delegate
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

            if let urlString = navigationResponse.response.url?.absoluteString {
                let items = getQueryItems(urlString)
                //                print(items)
                //                print(navigationResponse.response)
                guard let status = items["checkout-status"], let signature = items["signature"], signature == hmacSignature(secret: "SAIPPUAKAUPPIAS", headers: items, body: nil) else {
                    if let _ = items["checkout-status"] {
                        print("signature dismatch, failing payment")
                        delegate?.onPaymentStatusChanged(PaymentStatus.fail.rawValue)
                    }
                    decisionHandler(.allow)
                    return
                }
                delegate?.onPaymentStatusChanged(status)
            }
            decisionHandler(.allow)
        }
        
    }
}
