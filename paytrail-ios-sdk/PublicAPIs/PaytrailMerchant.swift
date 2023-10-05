//
//  PaytrailMerchant.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.6.2023.
//

import Foundation

/// A class represents a PaytrailMerchant object
///
public class PaytrailMerchant {
    
    public let merchantId: String /// merchant ID, or aggregate merchant ID in shop-in-shops
    public let secret: String /// merchant secret key, or aggregate merchant serect key in shop-in-shops

    public static var shared: PaytrailMerchant = PaytrailMerchant(merchantId: "", secret: "") /// Shared PaytrailMerchant object for authentication
    
    /// Create a shared PaytrailMerchant for all the APIs' authentication
    /// - Parameters:
    ///   - merchantId: merchant ID, or aggregate merchant ID in shop-in-shops
    ///   - secret: merchant secret key, or aggregate merchant serect key in shop-in-shops
    public static func create(merchantId: String, secret: String) {
        shared = PaytrailMerchant(merchantId: merchantId, secret: secret)
    }
    
    private init(merchantId: String, secret: String) {
        self.merchantId = merchantId
        self.secret = secret
    }
}
