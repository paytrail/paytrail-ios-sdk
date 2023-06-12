//
//  UrlStringHandler.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 12.6.2023.
//

import Foundation

public func getQueryItems(_ urlString: String) -> [String: String] {
    var queryItems: [String: String] = [:]
    var components: NSURLComponents? = nil
    
    let linkUrl = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
    if let linkUrl = linkUrl {
        components = NSURLComponents(url: linkUrl, resolvingAgainstBaseURL: true)
    }

    for item in components?.queryItems ?? [] {
        queryItems[item.name] = item.value?.removingPercentEncoding
    }
    
    return queryItems
}

private func getURLComonents(_ urlString: String?) -> NSURLComponents? {
    var components: NSURLComponents? = nil
    let linkUrl = URL(string: urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
    if let linkUrl = linkUrl {
        components = NSURLComponents(url: linkUrl, resolvingAgainstBaseURL: true)
    }
    return components
}
