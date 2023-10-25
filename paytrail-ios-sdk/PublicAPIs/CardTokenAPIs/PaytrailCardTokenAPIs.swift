//
//  PaytrailTokenAPIs.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 20.6.2023.
//

import Foundation


/// PaymentTransactionType
///
/// PaymentTransactionType enum used in PaytrailCardTokenAPIs
///
public enum PaymentTransactionType: String {
    
    /// Customer initiated transaction
    case cit
    
    /// Merchant initiated transaction
    case mit
}

/// PaymentAuthorizationType
///
/// PaymentAuthorizationType enum containing 2 types of token authorization
///
public enum PaymentAuthorizationType: String {
    
    /// Token payment authorization will be on hold untill the app complete the transaction
    case authorizationHold = "authorization-hold"
    
    /// Token payment will be charged right away
    case charge
}

public class PaytrailCardTokenAPIs: PaytrailBaseAPIs {
    
    /// initiateCardTokenizationRequest API to create an add-card-form request
    /// - Parameters:
    ///   - merchantId: merchant id, i.e. account
    ///   - secret: merchant secret
    ///   - redirectUrls: Redirect Urls after add-card succeeded or failed
    ///   - callbackUrls: Callback Urls (optional) after add-card succeeded or failed
    ///   - language: The preferred language to load the add-card form, default EN
    /// - Returns: add-card-form URLRequest
    public class func initiateCardTokenizationRequest(merchantId: String = PaytrailMerchant.shared.merchantId,
                                                      secret: String = PaytrailMerchant.shared.secret,
                                                redirectUrls: CallbackUrls,
                                                callbackUrls: CallbackUrls? = nil,
                                                language: Language = .en) -> URLRequest?
    {
        
        guard validateCredentials(merchantId: merchantId, secret: secret) else {
            return nil
        }
        
        let addCardTokenEndpoint: String = ApiPaths.tokenization + ApiPaths.addCard

        guard let url = URL(string: baseUrl + addCardTokenEndpoint) else {
            PTLogger.log(message: "Failed initiate payment request, reason: invalid url.", level: .error)
            return nil
        }
        
        guard let urlSuccess = URL(string: redirectUrls.success), urlSuccess.host != nil, let urlCancel = URL(string: redirectUrls.cancel), urlCancel.host != nil else {
            PTLogger.log(message: "Failed initiate payment request, reason: invalid redirectUrls.", level: .error)
            return nil
        }
        
        let uniqueFields = [
            ParameterKeys.checkoutRedirectSuccessUrl: redirectUrls.success,
            ParameterKeys.checkoutRedirectCancelUrl: redirectUrls.cancel,
            ParameterKeys.checkoutCallbackSuccessUrl: callbackUrls?.success ?? "",
            ParameterKeys.checkoutCallbackCancelUrl: callbackUrls?.cancel ?? "",
            ParameterKeys.language: language.rawValue
        ]
        
        var parameters = getApiHeaders(merchantId, uniqueFields: uniqueFields, method: CheckoutMethod.post)
        
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
            PTLogger.log(message: "Failed initiate payment request, reason: empty request body.", level: .error)
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
    public class func getToken(tokenizedId: String, 
                               merchantId: String = PaytrailMerchant.shared.merchantId,
                               secret: String = PaytrailMerchant.shared.secret,
                               completion: @escaping (Result<TokenizationRequestResponse, PayTrailError>) -> Void) {
        
        guard validateCredentials(merchantId: merchantId, secret: secret) else {
            return
        }
        
        let networkService: NetworkService = NormalPaymentNetworkService()
        let path = "\(ApiPaths.tokenization)/\(tokenizedId)"

        let uniqueFields = [ParameterKeys.checkoutTokenizationId: tokenizedId]
        let headers = getApiHeaders(merchantId, uniqueFields: uniqueFields, method: CheckoutMethod.post)
                
        let signature = hmacSignature(secret: secret, headers: headers, body: nil)
        let signatureHeader = [ParameterKeys.signature: signature]
        
        let dataRequest: CardTokenizationRequest = CardTokenizationRequest(path: path, headers: headers, specialHeader: signatureHeader)
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
    public class func createTokenPayment(merchantId: String = PaytrailMerchant.shared.merchantId,
                            secret: String = PaytrailMerchant.shared.secret,
                            payload: PaymentRequestBody,
                            transactionType: PaymentTransactionType,
                            authorizationType: PaymentAuthorizationType,
                            completion: @escaping (Result<TokenPaymentRequestResponse, PayTrailError>) -> Void) {
        
        guard validateCredentials(merchantId: merchantId, secret: secret) else {
            return
        }
        
        let networkService: NetworkService = TokenPaymentNetworkService()
        
        let path = ApiPaths.paymentsToken + "/\(transactionType.rawValue)/\(authorizationType.rawValue)"
        let body = try? JSONSerialization.data(withJSONObject: jsonEncode(of: payload), options: .prettyPrinted)
        
        let headers = getApiHeaders(merchantId, method: CheckoutMethod.post)
        
        let signature = hmacSignature(secret: secret, headers: headers, body: body)
        let signatureHeader = [ParameterKeys.signature: signature]
        
        let dataRequest: CreateTokenPaymentDataRequest = CreateTokenPaymentDataRequest(headers: headers, body: body, specialHeader: signatureHeader, path: path)
        networkService.request(dataRequest) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    /// tokenCommit API for commit any authorization-hold transaction
    /// - Parameters:
    ///   - merchantId: merchantId, i.e. account
    ///   - secret: merchant secret
    ///   - transactionId: onhold transactionId
    ///   - payload: onhold payment payload which can be different than the original
    ///   - completion: Result<TokenPaymentRequestResponse, Error>
    public class func tokenCommit(merchantId: String = PaytrailMerchant.shared.merchantId,
                                 secret: String = PaytrailMerchant.shared.secret,
                                 transactionId: String,
                                 payload: PaymentRequestBody,
                                 completion: @escaping (Result<TokenPaymentRequestResponse, PayTrailError>) -> Void) {
        
        guard validateCredentials(merchantId: merchantId, secret: secret) else {
            return
        }
        
        let networkService: NetworkService = TokenPaymentNetworkService()
        
        let path = ApiPaths.payments + "/\(transactionId)" + ApiPaths.tokenCommit
        let body = try? JSONSerialization.data(withJSONObject: jsonEncode(of: payload), options: .prettyPrinted)
        
        let uniqueFields = [ParameterKeys.checkoutTransactionId: transactionId]
        let headers = getApiHeaders(merchantId, uniqueFields: uniqueFields, method: CheckoutMethod.post)

        let signature = hmacSignature(secret: secret, headers: headers, body: body)
        let signatureHeader = [ParameterKeys.signature: signature]
        let dataRequest: CreateTokenPaymentDataRequest = CreateTokenPaymentDataRequest(headers: headers, body: body, specialHeader: signatureHeader, path: path)
        networkService.request(dataRequest) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /// tokenRevert API for reverting an onhold transaction
    /// - Parameters:
    ///   - merchantId: merchantId, i.e. acount
    ///   - secret: merchant secret
    ///   - transactionId: onhold transactionId
    ///   - completion: Result<TokenPaymentRequestResponse, Error>
    public class func tokenRevert(merchantId: String = PaytrailMerchant.shared.merchantId,
                                 secret: String = PaytrailMerchant.shared.secret,
                                 transactionId: String,
                                 completion: @escaping (Result<TokenPaymentRequestResponse, PayTrailError>) -> Void) {
        
        guard validateCredentials(merchantId: merchantId, secret: secret) else {
            return
        }
        
        let networkService: NetworkService = TokenPaymentNetworkService()
        let path = ApiPaths.payments + "/\(transactionId)" + ApiPaths.tokenRevert
        
        let uniqueFields = [ParameterKeys.checkoutTransactionId: transactionId]
        let headers = getApiHeaders(merchantId, uniqueFields: uniqueFields, method: CheckoutMethod.post)
        
        let signature = hmacSignature(secret: secret, headers: headers, body: nil)
        let signatureHeader = [ParameterKeys.signature: signature]
        
        let dataRequest: CreateTokenPaymentDataRequest = CreateTokenPaymentDataRequest(headers: headers, body: nil, specialHeader: signatureHeader, path: path)
        networkService.request(dataRequest) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /// payAndAddCard API handles payment as well as adding a new card. If the flow succeeds, it calls the Callback Url with the additional parameter of 'checkout-card-token' to the merchant's backend who will then save the card token and communicate with the client when needed. Note: do not use this API when the merchant backend is not setup for this.
    /// See: https://docs.paytrail.com/#/?id=pay-and-add-card
    /// - Parameters:
    ///   - merchantId: merchantId, i.e. account
    ///   - secret: merchant secret
    ///   - payload: paylaod data, i.e. PaymentRequestBody
    ///   - completion: Result<PayAndAddCardRequestResponse, Error>) -> Void
    public class func payAndAddCard(merchantId: String = PaytrailMerchant.shared.merchantId,
                       secret: String = PaytrailMerchant.shared.secret,
                       payload: PaymentRequestBody,
                       completion: @escaping (Result<PayAndAddCardRequestResponse, PayTrailError>) -> Void) {
        
        guard validateCredentials(merchantId: merchantId, secret: secret) else {
            return
        }
        
        let networkService: NetworkService = NormalPaymentNetworkService()
        let body = try? JSONSerialization.data(withJSONObject: jsonEncode(of: payload), options: .prettyPrinted)
        
        let headers = getApiHeaders(merchantId, method: CheckoutMethod.post)
        
        let signature = hmacSignature(secret: secret, headers: headers, body: body)        
        let signatureHeader = [ParameterKeys.signature: signature]
        let dataRequest: PayAndAddCardDataRequest = PayAndAddCardDataRequest(headers: headers, body: body, specialHeader: signatureHeader)
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
