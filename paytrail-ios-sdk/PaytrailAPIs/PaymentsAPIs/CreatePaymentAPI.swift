//
//  CreatePayment.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

public class PaytrailPaymentAPIs: PaytrailAPIs {    
    public func createPayment(of merchantId: String, secret: String, headers: [String: String], payload: PaymentRequestBody, completion: @escaping (Result<PaymentRequestResponse, Error>) -> Void) {
        let networkService: NetworkService = DefaultNetworkService()
        let body = jsonEncode(of: payload)
        let signature = hmacSignature(secret: secret, headers: headers, body: body)
        var newHeaders = headers
        newHeaders["signature"] = signature
        let dataRequest: CreatePaymentDataRequest = CreatePaymentDataRequest(headers: newHeaders, body: body)
        networkService.request(dataRequest) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
