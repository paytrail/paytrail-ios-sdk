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
    class func getPayment(of merchantId: String = PaytrailMerchant.shared.merchantId,
                          secret: String = PaytrailMerchant.shared.secret,
                          transactionId: String,
                          completion: @escaping (Result<Payment, PTError>) -> Void) {
        
        guard validateCredentials(merchantId: merchantId, secret: secret) else {
            return
        }
        
        let networkService: NetworkService = NormalPaymentNetworkService()
        let path = "\(ApiPaths.payments)/\(transactionId)"
        let uniqueFields = [ParameterKeys.checkoutTransactionId: transactionId]
        let headers = getApiHeaders(merchantId, uniqueFields: uniqueFields, method: CheckoutMethod.get)
        
        let signature = hmacSignature(secret: secret, headers: headers, body: nil)
        
        let signatureHeader = [ParameterKeys.signature: signature]
        let dataRequest: GetPaymentDataRequest = GetPaymentDataRequest(path: path, headers: headers, specialHeader: signatureHeader)
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
