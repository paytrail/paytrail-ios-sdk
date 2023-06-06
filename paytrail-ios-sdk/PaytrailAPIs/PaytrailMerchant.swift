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
    
    let merchantId: String /// merchant ID, or aggregate merchant ID in shop-in-shops
    let secret: String /// merchant secret key, or aggregate merchant serect key in shop-in-shops
    
    public static var shared: PaytrailMerchant = PaytrailMerchant(merchantId: "", secret: "")
    
    internal required init(merchantId: String, secret: String) {
        self.merchantId = merchantId
        self.secret = secret
        
    }
    
    /// Create merchant method
    /// - Parameters:
    ///   - merchantId: merchant ID, or aggregate merchant ID in shop-in-shops
    ///   - secret: merchant secret key, or aggregate merchant serect key in shop-in-shops
    /// - Returns: A shared-instance PaytrailMerchant object
    public static func create(merchantId: String, secret: String) -> PaytrailMerchant {
        shared = Self(merchantId: merchantId, secret: secret)
        return shared
    }
    
}


