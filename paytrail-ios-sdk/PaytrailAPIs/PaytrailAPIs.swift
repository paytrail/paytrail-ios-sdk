//
//  Test.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 26.5.2023.
//

import Foundation

public protocol PaytrailAPIs {
    func createPayment(of merchantId: String, secret: String, headers: [String: String], payload: PaymentRequestBody, completion: @escaping (Result<PaymentRequestResponse, Error>) -> Void)
}
