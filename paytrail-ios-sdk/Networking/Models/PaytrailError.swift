//
//  PaytrailError.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 28.6.2023.
//

import Foundation


/// PaytrailError
///
public class PayTrailError: Error {
    public typealias T = Codable
    public let type: PaytrialErrorType
    public let code: Int?
    public let message: String?
    public let payload: T?
    public var description: String {
        "PaytrailError - type: \(type.rawValue), code: \(String(describing: code)), message: \(message ?? "")"
    }
    
    public init(type: PaytrialErrorType, 
                code: Int?,
                message: String?,
                payload: T? = nil) {
        self.type = type
        self.code = code
        self.message = message
        self.payload = payload
    }
}

/// PaytrialErrorType
///
/// PaytrialErrorType enum in string
///
public enum PaytrialErrorType: String {
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
