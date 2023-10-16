//
//  PaytrailError.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 28.6.2023.
//

import Foundation


/// PaytrailError
///
/// Public PaytrailError protocol to be conformed by all the Paytrail error types
///
public protocol PaytrailError: Error {
    
    associatedtype Payload
    /// Type of the error
    var type: PaytrialErrorType { get set }
    
    /// Cdoe of the error if any
    var code: Int? { get set }
    
    /// Payload of the error if any
    var payload: Payload? { get set }
    
    /// Error description
    var description: String { get }
}

extension PaytrailError {
    public var description: String {
        "PaytrailError: \(type.rawValue), code: \(String(code ?? 404))"
    }
}

public class PTError: Error {
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

public class PTTokenError: PTError {
    public typealias T = TokenPaymentThreeDsReponse
}

public class PTPaymentError: PTError {
    public typealias T = PaymentErrorResponse
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


/// PaytrailGenericError
///
/// PaytrailGenericError data model, representing a generic error
///
public struct PaytrailGenericError: PaytrailError, Error {
    
    
    public typealias Payload = NSError
    public var type: PaytrialErrorType
    public var code: Int?
    public var payload: Payload?
    public var description: String {
        "PaytrailError: \(type.rawValue), code: \(String(code ?? 404)), payload: \(payload?.localizedDescription ?? "")"
    }
    public static let _default = PaytrailGenericError(type: .unknown, code: nil, payload: nil)
}


/// PaytrailPaymentError
///
/// PaytrailPaymentError data model, representing a payment error
///
public struct PaytrailPaymentError: PaytrailError, Error {
    public typealias Payload = PaymentErrorResponse
    public var type: PaytrialErrorType
    public var code: Int?
    public var payload: Payload?
    public var description: String {
        "PaytrailError: \(type.rawValue), code: \(String(code ?? 404)), payload: \(payload?.localizedDescription ?? "")"
    }
}


/// PaytrailTokenError
///
/// PaytrailTokenError data model, representing a token payment error
///
public struct PaytrailTokenError: PaytrailError, Error {
    public typealias Payload = TokenPaymentThreeDsReponse
    public var type: PaytrialErrorType
    public var code: Int?
    public var payload: Payload?
    public var description: String {
        "PaytrailError: \(type.rawValue), code: \(String(code ?? 404)), payload: \(payload?.localizedDescription ?? "")"
    }
}
