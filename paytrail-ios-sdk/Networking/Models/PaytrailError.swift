//
//  PaytrailError.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 28.6.2023.
//

import Foundation

public protocol PaytrailError: Error {
    associatedtype Payload
    var type: PaytrialErrorType { get set }
    var code: Int? { get set }
    var payload: Payload? { get set }
    var description: String { get }
}

extension PaytrailError {
    var description: String {
        "PaytrailError: \(type.rawValue), code: \(String(code ?? 404))"
    }
}

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

public struct PaytrailGenericError: PaytrailError {
    public typealias Payload = NSError
    public var type: PaytrialErrorType
    public var code: Int?
    public var payload: Payload?
    public var description: String {
        "PaytrailError: \(type.rawValue), code: \(String(code ?? 404)), payload: \(payload?.localizedDescription ?? "")"
    }
    public static let _default = PaytrailGenericError(type: .unknown, code: nil, payload: nil)
}

public struct PaytrailPaymentError: PaytrailError {
    public typealias Payload = PaymentErrorResponse
    public var type: PaytrialErrorType
    public var code: Int?
    public var payload: Payload?
    public var description: String {
        "PaytrailError: \(type.rawValue), code: \(String(code ?? 404)), payload: \(payload?.localizedDescription ?? "")"
    }
}

public struct PaytrailTokenError: PaytrailError {
    public typealias Payload = TokenPaymentThreeDsReponse
    public var type: PaytrialErrorType
    public var code: Int?
    public var payload: Payload?
    public var description: String {
        "PaytrailError: \(type.rawValue), code: \(String(code ?? 404)), payload: \(payload?.localizedDescription ?? "")"
    }
}
