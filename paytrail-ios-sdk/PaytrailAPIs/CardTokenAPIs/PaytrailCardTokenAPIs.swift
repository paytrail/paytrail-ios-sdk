//
//  PaytrailTokenAPIs.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 20.6.2023.
//

import Foundation

open class PaytrailCardTokenAPIs {
    
    let addCardTokenEndpoint: String = "/tokenization/addcard-form"
        
    
    /// initiateCardTokenizationRequest API to create an add-card-form request
    /// - Parameters:
    ///   - merchantId: merchant id, i.e. account
    ///   - secret: merchant secret
    ///   - redirectUrls: Redirect Urls after add-card succeeded or failed
    ///   - callbackUrls: Callback Urls (optional) after add-card succeeded or failed
    ///   - language: The preferred language to load the add-card form, default EN
    /// - Returns: add-card-form URLRequest
    public func initiateCardTokenizationRequest(of merchantId: String,
                                                secret: String,
                                                redirectUrls: CallbackUrls,
                                                callbackUrls: CallbackUrls? = nil,
                                                language: Language = .en) -> URLRequest? {
        guard let url = URL(string: baseUrl + addCardTokenEndpoint) else {
            print("Error,failed initiate payment request, reason: invalid url")
            return nil
        }
        
        var parameters: [String: String] = [
            "checkout-account": merchantId,
            "checkout-algorithm": "sha256",
            "checkout-method": "POST",
            "checkout-nonce": UUID().uuidString,
            "checkout-timestamp": getCurrentDateIsoString(),
            "checkout-redirect-success-url": redirectUrls.success,
            "checkout-redirect-cancel-url": redirectUrls.cancel,
            "checkout-callback-success-url": callbackUrls?.success ?? "",
            "checkout-callback-cancel-url": callbackUrls?.cancel ?? "",
            "language": language.rawValue
        ]
        
        let signature = hmacSignature(secret: secret, headers: parameters, body: nil)
        parameters["signature"] = signature
        
        guard !parameters.isEmpty else {
            print("Error,failed initiate card tokenization request, reason: invalid parameters")
            return nil
        }
        
        guard var urlComponent = URLComponents(string: url.absoluteString) else { return nil }
        var queryItems: [URLQueryItem] = []
        parameters.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
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
    
    func getToken(of tokenizedId: String, merchantId: String, secret: String,  completion: @escaping (Result<TokenizationRequestResponse, Error>) -> Void) {
        
        let networkService: NetworkService = DefaultNetworkService()
        
        let headers = [
            "checkout-algorithm": "sha256",
            "checkout-method": "POST",
            "checkout-nonce": UUID().uuidString,
            "checkout-timestamp": getCurrentDateIsoString(),
            "checkout-account": merchantId,
            "checkout-tokenization-id": tokenizedId
        ]
        
        let signature = hmacSignature(secret: secret, headers: headers, body: nil)
        let path = "/tokenization/\(tokenizedId)"
        let speicalHeader = ["signature": signature]
        let dataRequest: CardTokenizationRequest = CardTokenizationRequest(path: path, headers: headers, specialHeader: speicalHeader)
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
