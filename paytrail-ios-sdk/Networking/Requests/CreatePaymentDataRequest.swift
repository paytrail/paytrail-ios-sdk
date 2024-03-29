//
//  CreatePaymentDataRequest.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

struct CreatePaymentDataRequest: DataRequest {
    
    typealias Response = PaymentRequestResponse
    var headers: [String : String]
   
    var body: Data?
    var queryItems: [String : String] = [:]
    
    var specialHeader: [String : String]
    
    var path: String = ApiPaths.payments
    
    var method: HTTPMethod {
        HTTPMethod.post
    }
    
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(PaymentRequestResponse.self, from: data)
    }
}
