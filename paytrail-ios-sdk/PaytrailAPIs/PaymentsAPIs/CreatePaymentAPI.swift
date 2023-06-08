//
//  CreatePayment.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation
import UIKit

open class PaytrailPaymentAPIs: PaytrailAPIs {
    
    /// createPayment API to get payments
    /// - Parameters:
    ///   - merchantId: merchant ID, or aggregate merchant ID in shop-in-shops
    ///   - secret: merchant secret key, or aggregate merchant serect key in shop-in-shops
    ///   - payload: paylaod data,see PaymentRequestBody
    ///   - completion: Result<PaymentRequestResponse, Error>
    public func createPayment(of merchantId: String, secret: String, payload: PaymentRequestBody, completion: @escaping (Result<PaymentRequestResponse, Error>) -> Void) {
        let networkService: NetworkService = DefaultNetworkService()
        let body = try? JSONSerialization.data(withJSONObject: jsonEncode(of: payload), options: .prettyPrinted)
        
        let headers = [
            "checkout-algorithm": "sha256",
            "checkout-method": "POST",
            "checkout-nonce": UUID().uuidString,
            "checkout-timestamp": dateIsoString,
            "checkout-account": merchantId
        ]
        
        let signature = hmacSignature(secret: secret, headers: headers, body: body)
        
        let speicalHeader = ["signature": signature]
        let dataRequest: CreatePaymentDataRequest = CreatePaymentDataRequest(headers: headers, body: body, specialHeader: speicalHeader)
        networkService.request(dataRequest) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// renderPaymentProviderImage API to render a provider icon to UIImage
    /// - Parameters:
    ///   - url: Payment provider image url
    ///   - completion: Result<UIImage, Error>) -> Void
    public func renderPaymentProviderImage(by url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let imageRequest = PaymentImageDataRequest(url: url)
        let networkService: NetworkService = DefaultNetworkService()
        networkService.request(imageRequest) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    var dateIsoString: String {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return iso8601DateFormatter.string(from: Date())
    }

}
