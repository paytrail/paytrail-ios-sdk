//
//  GetPaymentAPI.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 16.6.2023.
//

import Foundation

public extension PaytrailPaymentAPIs {
    
    /// getPayment API for retrieving an existing payment
    /// - Parameters:
    ///   - merchantId: merchantId, i.e. account
    ///   - secret: merchant secret
    ///   - transactionId: transactionId, the id of the transaction
    ///   - completion: Result<Payment, Error>
    func getPayment(of merchantId: String, secret: String, transactionId: String, completion: @escaping (Result<Payment, Error>) -> Void) {
        let networkService: NetworkService = DefaultNetworkService()
        
        let path = "/payments/\(transactionId)"
        let headers = [
            "checkout-account": merchantId,
            "checkout-algorithm": "sha256",
            "checkout-method": "GET",
            "checkout-timestamp": getCurrentDateIsoString(),
            "checkout-transaction-id": transactionId,
            "checkout-nonce": UUID().uuidString
        ]
        
        let signature = hmacSignature(secret: secret, headers: headers, body: nil)
        
        let speicalHeader = ["signature": signature]
        let dataRequest: GetPaymentDataRequest = GetPaymentDataRequest(path: path, headers: headers, specialHeader: speicalHeader)
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
