//
//  PaytrailMerchant.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.6.2023.
//

import Foundation

/// PaytrailMerchant contains the credentials of a merchant or shop-in-shop merchant
///
public class PaytrailMerchant {
    
    /// Merchant ID, or aggregate merchant ID in shop-in-shops
    public let merchantId: String
    
    /// Merchant secret key, or aggregate merchant serect key in shop-in-shops
    public let secret: String
    
    /// Merchant shop-in-shop ID
    public let sisId: String
    
    /// Shared PaytrailMerchant object for authentication
    public static var shared: PaytrailMerchant = PaytrailMerchant(merchantId: "", secret: "", sisId: "")
    
    /// Create a shared PaytrailMerchant for all the APIs' authentication
    /// - Parameters:
    ///   - merchantId: merchant ID, or aggregate merchant ID in shop-in-shops
    ///   - secret: merchant secret key, or aggregate merchant serect key in shop-in-shops
    ///   - sisId: merchant shop-in-shop Id, given when having a shop-in-shop merchant account
    public static func create(merchantId: String, secret: String, sisId: String = "") {
        shared = PaytrailMerchant(merchantId: merchantId, secret: secret, sisId: sisId)
    }
    
    private init(merchantId: String, secret: String, sisId: String) {
        self.merchantId = merchantId
        self.secret = secret
        self.sisId = sisId
    }
}
