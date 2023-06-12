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

//        guard var urlComponent = URLComponents(string: url.absoluteString) else { return }
//
//        var queryItems: [URLQueryItem] = []
//
//        query.forEach {
//            let urlQueryItem = URLQueryItem(name: $0.name ?? "", value: $0.value)
//            urlComponent.queryItems?.append(urlQueryItem)
//            queryItems.append(urlQueryItem)
//        }
//
//        urlComponent.queryItems = queryItems
//
//        guard let url = urlComponent.url else {
//            return
//        }
        print(url)
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
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            //            print(navigationAction.request.url)
            //            print(navigationAction.request.url?.pathComponents)
            if let urlString = navigationAction.request.url?.absoluteString {
                let items = getQueryItems(urlString)
                print(items)
    
                delegate?.onPaymentStatusChanged(items["checkout-status"] ?? "")
            }
            decisionHandler(.allow)
        }
        
    }
}
