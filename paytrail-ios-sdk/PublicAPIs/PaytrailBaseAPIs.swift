//
//  PaytrailBaseAPIs.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.10.2023.
//

import Foundation

public protocol PaytrailBaseAPIs {
    static func validateCredentials(merchantId: String, secret: String, place: String) -> Bool
    static func getApiHeaders(_ merchantId: String,
                                     uniqueFields: [String: String],
                                     method: String) -> [String: String]
}

extension PaytrailBaseAPIs {
    public static func validateCredentials(merchantId: String, secret: String, place: String = #function) -> Bool {
        guard !merchantId.isEmpty && !secret.isEmpty else {
            PTLogger.log(message: "Merchant credentials not given, abort \(place) API call.", level: .error)
            return false
        }
        
        PTLogger.log(message: "Merchant credentials found, calling \(place) API.", level: .debug)
        return true
    }
    
    public static func getApiHeaders(_ merchantId: String,
                                     uniqueFields: [String: String] = [:],
                                     method: String) -> [String: String] {
        
        let headers = [
            ParameterKeys.checkoutAccount: merchantId,
            ParameterKeys.checkoutAlgorithm: CheckoutAlgorithm.sha256,
            ParameterKeys.checkoutMethod: method,
            ParameterKeys.checkoutTimestamp: getCurrentDateIsoString(),
            ParameterKeys.checkoutNonce: UUID().uuidString
        ]
        
        let combinedHeaders = headers.merging(uniqueFields, uniquingKeysWith: { (first, _) in first })

        return combinedHeaders
    }
    
}
