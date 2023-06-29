//
//  Constants.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 26.6.2023.
//

import Foundation

public struct ParameterKeys {
    static let checkoutAccount = "checkout-account"
    static let checkoutAlgorithm = "checkout-algorithm"
    static let checkoutMethod = "checkout-method"
    static let checkoutNonce = "checkout-nonce"
    static let checkoutTimestamp = "checkout-timestamp"
    static let checkoutTransactionId = "checkout-transaction-id"
    static let checkoutRedirectSuccessUrl = "checkout-redirect-success-url"
    static let checkoutRedirectCancelUrl = "checkout-redirect-cancel-url"
    static let checkoutCallbackSuccessUrl = "checkout-callback-success-url"
    static let checkoutCallbackCancelUrl = "checkout-callback-cancel-url"
    static let checkoutTokenizationId = "checkout-tokenization-id"
    static let checkoutStatus = "checkout-status"
    static let language = "language"
    static let signature = "signature"
}

public struct CheckoutAlgorithm {
    static let sha256 = "sha256"
    static let sha512 = "sha512"
}

public struct CheckoutMethod {
    static let get = "GET"
    static let post = "POST"
}

public struct ApiPaths {
    static let payments = "/payments"
    static let tokenization = "/tokenization"
    static let addCard = "/addcard-form"
    static let paymentsToken = "/payments/token"
    static let tokenCommit = "/token/commit"
    static let tokenRevert = "/token/revert"
}

public struct InvalidAcquirerResponseCode {
    static let nets = [111, 119, 165, 200, 207, 208, 209, 902, 908, 909]
    static let amex = [181, 183, 187, 189, 200]
}
