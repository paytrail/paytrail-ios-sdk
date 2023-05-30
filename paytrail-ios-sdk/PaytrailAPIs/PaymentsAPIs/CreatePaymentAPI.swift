//
//  CreatePayment.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation
import Combine

public extension PaytrailAPIs {
    func createPayment(of merchantId: String, secret: String, headers: [String: String], payload: PaymentRequestBody, completion: @escaping (Result<PaymentRequestResponse, Error>) -> Void) {
        let networkService: NetworkService = DefaultNetworkService()
        let body = jsonEncode(of: payload)
        let dataRequest: CreatePaymentDataRequest = CreatePaymentDataRequest(headers: headers, body: body)
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
