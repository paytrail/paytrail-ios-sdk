//
//  WebView.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 9.6.2023.
//

import Foundation

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL
    var method: HTTPMethod = .get
    var headers: [String: String] = ["content-type": "application/json; charset=utf-8"]
    var query: [Parameter] = []
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
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
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        //        let bodyData = try? JSONSerialization.data(withJSONObject: jsonEncode(of: query), options: .prettyPrinted)
        //        request.httpBody = bodyData
        webView.load(request)
    }
}
