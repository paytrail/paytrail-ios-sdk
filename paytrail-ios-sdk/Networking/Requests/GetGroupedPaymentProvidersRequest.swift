//
//  GetGroupedPaymentProvidersRequest.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.9.2023.
//

import Foundation

struct GetGroupedPaymentProvidersRequest: DataRequest {
    
    typealias Response = PaymentMethodGroupDataResponse
    var queryItems: [String : String]
    var path: String
    var headers: [String : String]
    var specialHeader: [String : String]
    var body: Data? = nil
    
    var method: HTTPMethod {
        HTTPMethod.get
    }
    
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(PaymentMethodGroupDataResponse.self, from: data)
    }
    
}
