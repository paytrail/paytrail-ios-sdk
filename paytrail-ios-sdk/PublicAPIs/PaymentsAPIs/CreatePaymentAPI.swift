//
//  CreatePayment.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation
import UIKit

public class PaytrailPaymentAPIs: PaytrailBaseAPIs {
    
    /// createPayment API to get payments
    /// - Parameters:
    ///   - merchantId: merchant ID, or aggregate merchant ID in shop-in-shops
    ///   - secret: merchant secret key, or aggregate merchant serect key in shop-in-shops
    ///   - payload: paylaod data,see PaymentRequestBody
    ///   - completion: Result<PaymentRequestResponse, Error>
    public class func createPayment(of merchantId: String = PaytrailMerchant.shared.merchantId,
                                    secret: String = PaytrailMerchant.shared.secret,
                                    payload: PaymentRequestBody,
                                    completion: @escaping (Result<PaymentRequestResponse, Error>) -> Void) {
        
        guard validateCredentials(merchantId: merchantId, secret: secret) else {
            return
        }
        
        let networkService: NetworkService = NormalPaymentNetworkService()
        let body = try? JSONSerialization.data(withJSONObject: jsonEncode(of: payload), options: .prettyPrinted)
        
        let headers = getApiHeaders(merchantId, method: CheckoutMethod.post)
        
        let signature = hmacSignature(secret: secret, headers: headers, body: body)
        let signatureHeader = [ParameterKeys.signature: signature]
        
        let dataRequest: CreatePaymentDataRequest = CreatePaymentDataRequest(headers: headers, body: body, specialHeader: signatureHeader)
        networkService.request(dataRequest) { result in
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
    public class func initiatePaymentRequest(from provider: PaymentMethodProvider) -> URLRequest? {
        guard let urlString = provider.url, let url = URL(string: urlString) else {
            PTLogger.log(message: "Failed initiate payment request, reason: invalid Provider url", level: .error)
            return nil
        }
        
        guard let params = provider.parameters, !params.isEmpty else {
            PTLogger.log(message: "Failed initiate payment request, reason: invalid Provider parameters", level: .error)
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
            PTLogger.log(message: "Failed initiate payment request, reason: empty request body.", level: .error)
            return nil
        }
        request.httpBody = body
        return request
    }
    
    
    /// getGroupedPaymentProviders API for returning a group of providers without initiating a payment
    /// - Parameters:
    ///   - merchantId: Merchant ID in string
    ///   - secret: Merchant Secret in string
    ///   - amount: The amount for returninig a provider. Note: some providers are only available when amount meets the minimal requirement
    ///   - groups: PaymentType of providers to be returned
    ///   - language: Preferred language, default Language.en
    ///   - completion: Result<PaymentMethodGroupDataResponse, Error>
    public class func getGroupedPaymentProviders(of merchantId: String, secret: String, amount: Int, groups: [PaymentType] = [], language: Language = .en, completion: @escaping (Result<PaymentMethodGroupDataResponse, Error>) -> Void) {
                
        guard validateCredentials(merchantId: merchantId, secret: secret) else {
            return
        }
        
        let networkService: NetworkService = NormalPaymentNetworkService()
        let path = ApiPaths.getPaymentGroupedProviders
        
        let headers = getApiHeaders(merchantId, method: CheckoutMethod.get)
        
        let signature = hmacSignature(secret: secret, headers: headers, body: nil)
        let signatureHeader = [ParameterKeys.signature: signature]

        let queryItems = [
            ParameterKeys.amount: "\(amount)",
            ParameterKeys.groups: groups.map { $0.rawValue }.joined(separator: ","),
            ParameterKeys.language: language.rawValue
        ]
        
        let dataRequest: GetGroupedPaymentProvidersRequest = GetGroupedPaymentProvidersRequest(queryItems: queryItems, path: path, headers: headers, specialHeader: signatureHeader)
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

