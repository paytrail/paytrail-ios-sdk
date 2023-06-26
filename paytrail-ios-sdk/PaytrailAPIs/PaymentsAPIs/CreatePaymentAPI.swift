//
//  CreatePayment.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation
import UIKit

open class PaytrailPaymentAPIs {
    
    var delegate: PaymentDelegate?
    
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
            ParameterKeys.checkoutAlgorithm: CheckoutAlgorithm.sha256,
            ParameterKeys.checkoutMethod: CheckoutMethod.post,
            ParameterKeys.checkoutNonce: UUID().uuidString,
            ParameterKeys.checkoutTimestamp: getCurrentDateIsoString(),
            ParameterKeys.checkoutAccount: merchantId
        ]
        
        let signature = hmacSignature(secret: secret, headers: headers, body: body)
        
        let speicalHeader = [ParameterKeys.signature: signature]
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
    
    /// initiatePaymentRequest API to create a payment provider URLRequest
    ///
    /// To be called to start a payment flow
    /// - Parameter provider: PaymentMethodProvider of the request
    /// - Returns: URLRequest for the given PaymentMethodProvider
    public func initiatePaymentRequest(from provider: PaymentMethodProvider) -> URLRequest? {
        guard let urlString = provider.url, let url = URL(string: urlString) else {
            print("Error,failed initiate payment request, reason: invalid Provider url")
            return nil
        }
        
        guard let params = provider.parameters, !params.isEmpty else {
            print("Error,failed initiate payment request, reason: invalid Provider parameters")
            return nil
        }
        guard var urlComponent = URLComponents(string: urlString) else { return nil }
        var queryItems: [URLQueryItem] = []
        params.forEach {
            let urlQueryItem = URLQueryItem(name: $0.name ?? "", value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        urlComponent.queryItems = queryItems
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = ["content-type": "application/x-www-form-urlencoded"]
        guard let body = urlComponent.query?.data(using: .utf8), !body.isEmpty else {
            print("Error,failed initiate payment request, reason: Empty request body")
            return nil
        }
        request.httpBody = body
        return request
    }

}
