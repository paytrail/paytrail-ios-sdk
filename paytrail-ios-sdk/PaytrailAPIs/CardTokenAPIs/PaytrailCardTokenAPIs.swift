//
//  PaytrailTokenAPIs.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 20.6.2023.
//

import Foundation

open class PaytrailCardTokenAPIs {
    
    public enum PaymentTransactionType: String {
        case cit, mit
    }
    
    public enum PaymentAuthorizationType: String {
        case authorizationHold = "authorization-hold"
        case charge
    }
        
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
        
        let addCardTokenEndpoint: String = ApiPaths.tokenization + ApiPaths.addCard

        guard let url = URL(string: baseUrl + addCardTokenEndpoint) else {
            print("Error,failed initiate payment request, reason: invalid url")
            return nil
        }
        
        guard let urlSuccess = URL(string: redirectUrls.success), urlSuccess.host != nil, let urlCancel = URL(string: redirectUrls.cancel), urlCancel.host != nil else {
            print("Error,failed initiate payment request, reason: invalid redirectUrls")
            return nil
        }
        
        var parameters: [String: String] = [
            ParameterKeys.checkoutAccount: merchantId,
            ParameterKeys.checkoutAlgorithm: CheckoutAlgorithm.sha256,
            ParameterKeys.checkoutMethod: CheckoutMethod.post,
            ParameterKeys.checkoutNonce: UUID().uuidString,
            ParameterKeys.checkoutTimestamp: getCurrentDateIsoString(),
            ParameterKeys.checkoutRedirectSuccessUrl: redirectUrls.success,
            ParameterKeys.checkoutRedirectCancelUrl: redirectUrls.cancel,
            ParameterKeys.checkoutCallbackSuccessUrl: callbackUrls?.success ?? "",
            ParameterKeys.checkoutCallbackCancelUrl: callbackUrls?.cancel ?? "",
            ParameterKeys.language: language.rawValue
        ]
        
        let signature = hmacSignature(secret: secret, headers: parameters, body: nil)
        parameters[ParameterKeys.signature] = signature
        
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
    
    
    /// getToken API for retrieving the card token by the tokenizedId to be used when creating a token payment. 
    /// - Parameters:
    ///   - tokenizedId: tokenizedId of a payment card
    ///   - merchantId: merchantId, i.e. account
    ///   - secret: merchant secret
    ///   - completion: Result<TokenizationRequestResponse, Error>
    func getToken(of tokenizedId: String, merchantId: String, secret: String,  completion: @escaping (Result<TokenizationRequestResponse, Error>) -> Void) {
        
        // TODO: use another service
        let networkService: NetworkService = NormalPaymentNetworkService()
        
        let headers = [
            ParameterKeys.checkoutAlgorithm: CheckoutAlgorithm.sha256,
            ParameterKeys.checkoutMethod: CheckoutMethod.post,
            ParameterKeys.checkoutNonce: UUID().uuidString,
            ParameterKeys.checkoutTimestamp: getCurrentDateIsoString(),
            ParameterKeys.checkoutAccount: merchantId,
            ParameterKeys.checkoutTokenizationId: tokenizedId
        ]
        
        let signature = hmacSignature(secret: secret, headers: headers, body: nil)
        let path = "\(ApiPaths.tokenization)/\(tokenizedId)"
        let speicalHeader = [ParameterKeys.signature: signature]
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
    
    /// createTokenPayment API for creating a token payment
    /// - Parameters:
    ///   - merchantId: merchantId, i.e. account
    ///   - secret: merchant secret
    ///   - payload: paylaod data of a PaymentRequestBody which needs to have a 'token' property of a saved card
    ///   - transactionType: PaymentTransactionType, can be CIT or MIT
    ///   - authorizationType: PaymentAuthorizationType, can be 'authorizationHold' or 'charge'
    ///   - completion: Result<TokenPaymentRequestResponse, Error>
    func createTokenPayment(of merchantId: String,
                            secret: String,
                            payload: PaymentRequestBody,
                            transactionType: PaymentTransactionType,
                            authorizationType: PaymentAuthorizationType,
                            completion: @escaping (Result<TokenPaymentRequestResponse, Error>) -> Void) {
        
        let networkService: NetworkService = TokenPaymentNetworkService()
        
        let path = ApiPaths.paymentsToken + "/\(transactionType.rawValue)/\(authorizationType.rawValue)"
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
        let dataRequest: CreateTokenPaymentDataRequest = CreateTokenPaymentDataRequest(headers: headers, body: body, specialHeader: speicalHeader, path: path)
        networkService.request(dataRequest) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    /// commitAuthorizationHold API for commit any authorization-hold transaction
    /// - Parameters:
    ///   - merchantId: merchantId, i.e. account
    ///   - secret: merchant secret
    ///   - transactionId: onhold transactionId
    ///   - payload: onhold payment payload which can be different than the original
    ///   - completion: Result<TokenPaymentRequestResponse, Error>
    func commitAuthorizationHold(of merchantId: String,
                                 secret: String,
                                 transactionId: String,
                                 payload: PaymentRequestBody,
                                 completion: @escaping (Result<TokenPaymentRequestResponse, Error>) -> Void) {
        let networkService: NetworkService = TokenPaymentNetworkService()
        
        let path = ApiPaths.payments + "/\(transactionId)" + ApiPaths.tokenCommit
        let body = try? JSONSerialization.data(withJSONObject: jsonEncode(of: payload), options: .prettyPrinted)
        
        let headers = [
            ParameterKeys.checkoutAlgorithm: CheckoutAlgorithm.sha256,
            ParameterKeys.checkoutMethod: CheckoutMethod.post,
            ParameterKeys.checkoutNonce: UUID().uuidString,
            ParameterKeys.checkoutTimestamp: getCurrentDateIsoString(),
            ParameterKeys.checkoutAccount: merchantId,
            ParameterKeys.checkoutTransactionId: transactionId
        ]
        
        let signature = hmacSignature(secret: secret, headers: headers, body: body)
        
        let speicalHeader = [ParameterKeys.signature: signature]
        let dataRequest: CreateTokenPaymentDataRequest = CreateTokenPaymentDataRequest(headers: headers, body: body, specialHeader: speicalHeader, path: path)
        networkService.request(dataRequest) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /// revertAuthorizationHold API for reverting an onhold transaction
    /// - Parameters:
    ///   - merchantId: merchantId, i.e. acount
    ///   - secret: merchant secret
    ///   - transactionId: onhold transactionId
    ///   - completion: Result<TokenPaymentRequestResponse, Error>
    func revertAuthorizationHold(of merchantId: String,
                                 secret: String,
                                 transactionId: String,
                                 completion: @escaping (Result<TokenPaymentRequestResponse, Error>) -> Void) {
        
        let networkService: NetworkService = TokenPaymentNetworkService()
        
        let path = ApiPaths.payments + "/\(transactionId)" + ApiPaths.tokenRevert
        let headers = [
            ParameterKeys.checkoutAlgorithm: CheckoutAlgorithm.sha256,
            ParameterKeys.checkoutMethod: CheckoutMethod.post,
            ParameterKeys.checkoutNonce: UUID().uuidString,
            ParameterKeys.checkoutTimestamp: getCurrentDateIsoString(),
            ParameterKeys.checkoutAccount: merchantId,
            ParameterKeys.checkoutTransactionId: transactionId
        ]
        
        let signature = hmacSignature(secret: secret, headers: headers, body: nil)
        
        let speicalHeader = [ParameterKeys.signature: signature]
        let dataRequest: CreateTokenPaymentDataRequest = CreateTokenPaymentDataRequest(headers: headers, body: nil, specialHeader: speicalHeader, path: path)
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
