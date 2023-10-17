//
//  PaytrailError.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 28.6.2023.
//

import Foundation


/// PaytrailError
///
/// PayTrailError conforms Error protocol and is used in the SDK's error handlings.
///
public struct PayTrailError: Error {
    
    // Category of an error
    public let category: PaytrialErrorCategory
    
    // Error code if any
    public let code: Int?
    
    // Error message if any
    public let message: String?
    
    // Error payload in Codable if any, which should be coming from an API's call's result; when given, client is responsible for handling such a payload
    public let payload: Codable?
    
    // Description of the error
    public var description: String {
        "PaytrailError - category: \(category.rawValue), code: \(String(describing: code)), message: \(message ?? "")"
    }
    
    public init(type: PaytrialErrorCategory, 
                code: Int?,
                message: String?,
                payload: Codable? = nil) {
        self.category = type
        self.code = code
        self.message = message
        self.payload = payload
    }
}

/// PaytrialErrorCategory
///
/// PaytrialErrorCategory enum in string
///
public enum PaytrialErrorCategory: String {
    case invalidEndpint
    case invalidSignature
    case createPayment
    case getPayment
    case getToken
    case invalidToken
    case createTokenPayment
    case jsonDecode
    case threeDsPaymentSoftDecline
    case unknown
}
