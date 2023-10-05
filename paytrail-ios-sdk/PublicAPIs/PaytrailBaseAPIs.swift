//
//  PaytrailBaseAPIs.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.10.2023.
//

import Foundation

public protocol PaytrailBaseAPIs {
    static func validateCredentials(merchantId: String, secret: String, place: String) -> Bool
}

extension PaytrailBaseAPIs {
    public static func validateCredentials(merchantId: String, secret: String, place: String = #function) -> Bool {
        guard !merchantId.isEmpty && !secret.isEmpty else {
            PTLogger.log(message: "Merchant credentials not given, abort \(place) API call", level: .error)
            return false
        }
        return true
    }
}
